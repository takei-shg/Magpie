{-# LANGUAGE OverloadedStrings #-}

import           Control.Exception
import           Control.Monad
import qualified Data.Text               as T
import qualified Database.Persist        as P
import qualified Database.Persist.Sqlite as PS
import           System.Directory        (doesDirectoryExist)

import qualified Config
import           DBHelper                (runDB)
import           Model

main :: IO ()
main = do
    d <- doesDirectoryExist "db"
    unless d $ fail "Directory ./db does not exist. Retry after creating ./db"

    development <- Config.get (T.unpack "config/database.yml") "development" "database"
    pool <- PS.createSqlitePool development 3
    runDB pool $ PS.runMigration migrateAll
