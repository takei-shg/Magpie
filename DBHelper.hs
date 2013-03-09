{-# LANGUAGE OverloadedStrings #-}
module DBHelper
  ( runDB
  , strToKey
  , int64ToKey
  )  where

import           Data.Text (pack, unpack)
import           Data.Int (Int64)
import           Control.Monad.Trans     (liftIO, MonadIO)
import qualified Database.Persist as P
import qualified Database.Persist.Store as PS
import qualified Database.Persist.GenericSql as PG
import           Database.Persist.TH

runDB :: MonadIO m => PG.ConnectionPool -> PG.SqlPersist IO a -> m a
runDB p action = liftIO $ PG.runSqlPool action p

strToKey :: String -> PG.Key backend entity
strToKey x = PG.Key $ P.toPersistValue $ pack x

int64ToKey :: Int64 -> PG.Key backend entity
int64ToKey x = PG.Key $ P.toPersistValue x
