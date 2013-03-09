{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeSynonymInstances #-}

import qualified Data.Text                            as T
import qualified Database.Persist.Sqlite              as P
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Network.Wai.Middleware.Static        (addBase, staticPolicy)
import qualified Option as Option
import qualified Config as Config
import qualified Model as Model
import qualified Api as Api
import qualified Appbase as Appbase
import           Web.Scotty                           hiding (body)

main :: IO ()
main = do
    port        <- Option.port
    environment <- Option.environment
    database    <- Config.get (T.unpack "config/database.yml") environment "database"
    pool        <- P.createSqlitePool database 3

    scotty port $ do
        middleware logStdoutDev
        middleware $ staticPolicy $ addBase "app"
        Appbase.app
        Api.app pool
