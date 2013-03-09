{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}
module Api
    ( app
    ) where

import           Web.Scotty
import           Control.Applicative     (ZipList, (<$>), (<*>))
import qualified Control.Applicative as CA 
import           Control.Monad           (mzero, (>>))
-- import           Control.Arrow           ((&&&))
-- import           Data.Monoid          (mappend)
-- import           Data.Maybe              (isNothing)
-- import           Data.HashMap.Strict     (union)
import           Control.Monad.Trans     (liftIO)
import           Data.Maybe              (fromJust)
import           Data.Text               (Text)
import           Data.Int               (Int64)
import qualified Data.Text               as T
import qualified Data.Aeson as A
import qualified Database.Persist as P
import qualified Database.Persist.GenericSql as PG
import qualified Database.Persist.Store  as PS
import qualified Network.HTTP.Types      as HT
import           Model
import           Model.Role
import           Model.SlotStatus
import           Model.NaviStatus
import           Model.MatchStatus
import           JsonHelper
import           DBHelper

app :: PG.ConnectionPool -> ScottyM ()
app p = do
    let db = runDB p

    post "/user/regist" $ withRescue $ do
        value    <- jsonData
        liftIO $ print value
        key      <- db $ P.insert (value :: User)
        resource <- db $ P.get key
        case resource of
            Just (User name email pass dept role) -> json True 
            _ -> json False

    get "/slots" $ withRescue $ do
        slots <- db $ P.selectList ([] :: [P.Filter Slot]) []
        json slots

    get "/slots/:slotId" $ withRescue $ do
        key      <- strToKey <$> param "slotId"
        slotDetail <- db $ do
            s <- fromJust <$> P.get key
            let slot = P.Entity key s
            l <- P.get $ fromJust $ slotLeader s
            let leader = P.Entity (fromJust $ slotLeader s) (fromJust l)
            ms <- mapM P.get $ slotMembers s
            let members = P.Entity <$> (CA.ZipList (slotMembers s)) <*> (CA.ZipList (fromJust <$> ms))
            return (slot, leader, CA.getZipList members)
        json (slotDetail :: SlotDetail)

    get "/slots/:slotId/schedules" $ withRescue $ do
        key      <- strToKey <$> param "slotId"
        schedules <- db $ P.selectList [SlotScheduleSlotId P.==. key] []
        json schedules
--         scheduleWithDrivers <- db $ do
--             schedules <-  P.selectList [SlotScheduleSlotId P.==. key] []
--             let driverIds = map (fromJust . slotScheduleDriverId . PG.entityVal) $ schedules
--             drivers <-  mapM P.get driverIds
--             return $ zip schedules $ CA.getZipList $ P.Entity <$> (CA.ZipList driverIds) <*> (CA.ZipList (fromJust <$> drivers))
--         json (scheduleWithDrivers :: [SlotScheduleWithDriver])

    post "/slots/:slotId/schedules" $ withRescue $ do
        entities <- (jsonData ::  ActionM [(P.Entity SlotSchedule)])
        result  <- db $ mapM_ (P.repsert <$> PG.entityKey <*> PG.entityVal) entities
        json result

    get "/navigators" $ withRescue $ do
        navigators <- db $ P.selectList [UserRole P.==. Just Navigator]  []
        json navigators 

    get "/navigator/:naviId/schedules" $ withRescue $ do
        key      <- strToKey <$> param "naviId"
        naviSchedules <- db $ P.selectList [NavigatorScheduleNaviId P.==. key] []
        json naviSchedules 

    post "/navigator/:naviId/schedules" $ withRescue $ do
        entities <- (jsonData ::  ActionM [(P.Entity NavigatorSchedule)])
        -- result  <- db $ foldr1 (>>) $ (P.repsert <$> PG.entityKey <*> PG.entityVal) <$> entities
        result  <- db $ mapM_ (P.repsert <$> PG.entityKey <*> PG.entityVal) entities
        json result

type SlotScheduleWithDriver = (P.Entity SlotSchedule, P.Entity User)
instance A.FromJSON SlotScheduleWithDriver where
    parseJSON o@(A.Object v) = (,) <$> (v A..: "schedule") 
                                   <*>  (v A..: "driver")
    parseJSON _            = mzero

instance A.ToJSON SlotScheduleWithDriver where
    toJSON (s, d) = A.object [ "schedule" A..= A.toJSON s
                                , "driver" A..=  A.toJSON d
                                ]

type SlotDetail = (P.Entity Slot, P.Entity User, [P.Entity User])
instance A.FromJSON SlotDetail where
    parseJSON o@(A.Object v) = (,,) <$> (v A..: "slot") 
                                    <*>  (v A..: "leader")
                                    <*>  (v A..: "members")
    parseJSON _            = mzero

instance A.ToJSON SlotDetail where
    toJSON (s, l, m) = A.object [ "slot" A..= A.toJSON s
                                , "leader" A..=  A.toJSON l
                                , "members" A..=  A.toJSON m
                                ]

-- instance (A.FromJSON a) => A.FromJSON (Text, a) where
--     parseJSON o@(A.Object v) = (,) <$> (v A..: "id") 
--                                    <*>  (v A..: "body")
--     parseJSON _            = mzero
-- 
-- instance (A.ToJSON a) => A.ToJSON (Text, a) where
--     toJSON (x, o) = A.object [ "id" A..= x
--                              , "body" A..=  A.toJSON o
--                              ]

instance (A.FromJSON a) => A.FromJSON (P.Entity a) where
    parseJSON o@(A.Object v) = P.Entity <$> (P.Key . PS.PersistInt64 <$> v A..: "id") 
                                        <*> (v A..: "body")
    parseJSON _              = mzero

instance (A.ToJSON a) => A.ToJSON (P.Entity a) where
    -- toJSON o = (A.object [ "id" A..= P.entityKey o ]) `mappend` (A.toJSON $ P.entityVal o )
    toJSON o = A.object [ "id" A..= (unPersistValue . P.unKey $ P.entityKey o)
                             , "body" A..=  P.entityVal o
                             ]
      where
        unPersistValue :: PS.PersistValue -> Int64
        unPersistValue (PS.PersistText a) = read . T.unpack $ a
        unPersistValue (PS.PersistInt64 a) = a
        unPersistValue a = error $ show a ++ " was not able to convert"
