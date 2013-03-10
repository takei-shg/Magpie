{-# LANGUAGE OverloadedStrings #-}

import qualified Config
import           Control.Exception
import           Control.Monad
import qualified Data.Text               as T
import           Data.Time.Clock         (UTCTime)
import qualified Database.Persist.Sqlite as P
import           DBHelper                (runDB)
import           Model
import qualified Model.MatchStatus       as MS
import qualified Model.NaviStatus        as NS
import           Model.Role
import qualified Model.SlotStatus        as SS
import           System.Directory        (doesDirectoryExist)

main :: IO ()
main = do
    d <- doesDirectoryExist "db"
    unless d $ fail "Directory ./db does not exist. Retry after creating ./db"

    development <- Config.get (T.unpack "config/database.yml") "development" "database"
    pool <- P.createSqlitePool development 3

    _ <- clearData pool

    atcq_leader <- runDB pool $ P.insert $ User "Q-Tip" "q-tip@atcq.com" "q-tip@atcq.com" ATCQ (Just Driver)
    atcq1 <- runDB pool $ P.insert $ User "AliShaheed" "alishaheed@atcq.com" "alishaheed@atcq.com" ATCQ (Just Navigator)
    atcq2 <- runDB pool $ P.insert $ User "Phife" "phife@atcq.com" "phife@atcq.com" ATCQ  (Just Driver)
    atcq3 <- runDB pool $ P.insert $ User "Jarobi" "jarobi@atcq.com" "jarobi@atcq.com" ATCQ  (Just Driver)
    scha_leader <- runDB pool $ P.insert $ User "bose" "bose@schadara.com" "bose@schadara.com" SCHA  (Just Driver)
    scha1 <- runDB pool $ P.insert $ User "ani" "ani@schadara.com" "ani@schadara.com" SCHA  (Just Driver)
    scha2 <- runDB pool $ P.insert $ User "shinco" "shinco@schadara.com" "shinco@schadara.com" SCHA  (Just Navigator)
    denki_leader <- runDB pool $ P.insert $ User "Pierre" "pierre@denki.gr" "pierre@denki.gr" DENKI  (Just Driver)
    denki1 <- runDB pool $ P.insert $ User "takkyu" "takkyu@denki.gr" "takkyu@denki.gr" DENKI  (Just Driver)

    slot1 <- runDB pool $ P.insert $ (Slot ATCQ1 ATCQ (Just atcq_leader) [atcq1 , atcq2])
    slot2 <- runDB pool $ P.insert $ (Slot SCHA1 ATCQ (Just scha_leader) [scha1, scha2])
    slot3 <- runDB pool $ P.insert $ (Slot DENKI1 DENKI (Just denki_leader) [denki1])

    qtipSche1 <- runDB pool $ P.insert $ (NavigatorSchedule atcq1 d_2_26 (Just OK) NS.NOTYET (atcq1, d_2_26))
    qtipSche2 <- runDB pool $ P.insert $ (NavigatorSchedule atcq1 d_2_28 (Just OK) NS.NOTYET (atcq1, d_2_28))
    qtipSche3 <- runDB pool $ P.insert $ (NavigatorSchedule atcq1 d_3_05 (Nothing) NS.NOTYET (atcq1, d_3_05))
    qtipSche4 <- runDB pool $ P.insert $ (NavigatorSchedule atcq1 d_3_07 (Just OK) NS.NOTYET (atcq1, d_3_07))
    qtipSche5 <- runDB pool $ P.insert $ (NavigatorSchedule atcq1 d_3_12 (Just NO) NS.NOTYET (atcq1, d_3_12))
    phifeSche1 <- runDB pool $ P.insert $ (NavigatorSchedule atcq2 d_2_26 (Just NO) NS.NOTYET (atcq2, d_2_26))
    phifeSche2 <- runDB pool $ P.insert $ (NavigatorSchedule atcq2 d_2_28 (Just OK) NS.NOTYET (atcq2, d_2_28))
    phifeSche3 <- runDB pool $ P.insert $ (NavigatorSchedule atcq2 d_3_05 (Nothing) NS.NOTYET (atcq2, d_3_05))
    phifeSche4 <- runDB pool $ P.insert $ (NavigatorSchedule atcq2 d_3_07 (Just OK) NS.NOTYET (atcq2, d_3_07))
    phifeSche5 <- runDB pool $ P.insert $ (NavigatorSchedule atcq2 d_3_12 (Just OK) NS.NOTYET (atcq2, d_3_12))

    atcq1Sche1 <- runDB pool $ P.insert $ (SlotSchedule slot1 d_2_26 (Just atcq1) SS.ASSIGNINED (slot1, d_2_26))
    atcq1Sche2 <- runDB pool $ P.insert $ (SlotSchedule slot1 d_2_28 (Just atcq2) SS.CANCELLED (slot1, d_2_28 ))
    atcq1Sche3 <- runDB pool $ P.insert $ (SlotSchedule slot1 d_3_05 (Just atcq1) SS.ASSIGNINED (slot1, d_3_05))
    atcq1Sche4 <- runDB pool $ P.insert $ (SlotSchedule slot1 d_3_07 (Just atcq2) SS.CANCELLED (slot1, d_3_07))
    atcq1Sche5 <- runDB pool $ P.insert $ (SlotSchedule slot1 d_3_12 (Just atcq1) SS.ASSIGNINED (slot1, d_3_12))

    return ()
      where
        d_2_26 = (read "2013-02-26 00:00:00 UTC") :: UTCTime
        d_2_28 = (read "2013-02-28 00:00:00 UTC") :: UTCTime
        d_3_05 = (read "2013-03-05 00:00:00 UTC") :: UTCTime
        d_3_07 = (read "2013-03-07 00:00:00 UTC") :: UTCTime
        d_3_12 = (read "2013-03-12 00:00:00 UTC") :: UTCTime


clearData :: P.ConnectionPool -> IO ()
clearData pool = do
    _ <- runDB pool $ P.deleteWhere ([] :: [P.Filter User])
    _ <- runDB pool $ P.deleteWhere ([] :: [P.Filter Slot])
    _ <- runDB pool $ P.deleteWhere ([] :: [P.Filter SlotSchedule])
    _ <- runDB pool $ P.deleteWhere ([] :: [P.Filter NavigatorSchedule])
    _ <- runDB pool $ P.deleteWhere ([] :: [P.Filter Match])
    return ()
