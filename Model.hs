{-# LANGUAGE EmptyDataDecls       #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeSynonymInstances #-}
module Model where

import           Control.Monad (mzero)
import           Control.Applicative
import           Data.Text
import           Data.Time.Clock (UTCTime) -- UTCTime has ToJSON
import           Database.Persist
import           Database.Persist.Sqlite
import           Database.Persist.TH
import qualified Data.Aeson as A
import           GHC.Generics
import           Model.Role
import           Model.SlotStatus
import           Model.NaviStatus
import           Model.MatchStatus

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|

User json
    name Text
    email Text
    password Text
    dept Department
    role Role Maybe
    UniqueUser email
    deriving Show

Slot json
    slotName SlotName
    dept Department
    leader UserId Maybe
    members [UserId]
    UniqueSlot slotName
    deriving Show

SlotSchedule json
    slotId SlotId
    date   UTCTime
    driverId UserId Maybe
    status SlotStatus
    surrogate SlotSurrogate
    UniqueSlotSchedule surrogate
    deriving Show

NavigatorSchedule json
    naviId UserId
    date   UTCTime
    available Available Maybe
    status NaviStatus
    surrogate NaviSurrogate
    UniqueNavigatorSchedule surrogate
    deriving Show

Match json
    date UTCTime
    slot SlotId
    driver UserId Maybe
    navigator UserId Maybe
    status MatchStatus
    deriving Show

|]

data Department
    = ATCQ | SCHA | DENKI 
    deriving (Show, Read, Eq, Enum)
 
data SlotName
    = ATCQ1 | ATCQ2 | ATCQ3 | SCHA1 | DENKI1
    deriving (Show, Read, Eq, Enum)

data Available
    = OK | NO 
    deriving (Show, Read, Eq, Enum)
 
type SlotSurrogate = (SlotId, UTCTime)

type NaviSurrogate = (UserId, UTCTime)
 
derivePersistField "Role"
derivePersistField "Department"
derivePersistField "SlotName"
derivePersistField "SlotStatus"
derivePersistField "Available"
derivePersistField "NaviStatus"
derivePersistField "MatchStatus"
derivePersistField "SlotSurrogate"
derivePersistField "NaviSurrogate"

-- $(deriveJSON id ''Department)
instance A.FromJSON Department where
    parseJSON (A.Object v) = read <$> (v A..: "dept")
    parseJSON _            = mzero

instance A.ToJSON Department where
    toJSON ATCQ = A.object [ "dept" A..= ("ATCQ" :: String) ]
    toJSON SCHA = A.object [ "dept" A..= ("SCHA" :: String) ]
    toJSON DENKI = A.object [ "dept" A..= ("DENKI" :: String) ]

instance A.FromJSON SlotName where
    parseJSON (A.Object v) = read <$> (v A..: "slotName")
    parseJSON _            = mzero

instance A.ToJSON SlotName where
    toJSON ATCQ1 = A.object [ "slotName" A..= ("ATCQ1" :: String) ]
    toJSON ATCQ2 = A.object [ "slotName" A..= ("ATCQ2" :: String) ]
    toJSON ATCQ3 = A.object [ "slotName" A..= ("ATCQ3" :: String) ]
    toJSON SCHA1 = A.object [ "slotName" A..= ("SCHA1" :: String) ]
    toJSON DENKI1 = A.object [ "slotName" A..= ("DENKI1" :: String) ]

instance A.FromJSON Available where
    parseJSON (A.Object v) = read <$> (v A..: "available")
    parseJSON _            = mzero

instance A.ToJSON Available where
    toJSON OK = A.object [ "available" A..= ("OK" :: String) ]
    toJSON NO = A.object [ "available" A..= ("NO" :: String) ]
