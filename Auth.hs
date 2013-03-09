{-# LANGUAGE OverloadedStrings #-}
-- derived from https://github.com/lucasdicioccio/haskell-paris-src/blob/master/Web/Scotty/Auth.hs
-- Now, it does not work.
module Auth where

import Web.Scotty as W
import Network.HTTP.Types.Status
import Network.Wai
import Control.Applicative((<$>))
import           Control.Monad.Trans     (MonadIO)
import qualified Data.ByteString.Base64 as B64
import qualified Data.ByteString as B
import qualified Data.Text.Lazy as TL
import qualified Database.Persist as P
import qualified Database.Persist.GenericSql as PG
import           Model 
import           DBHelper (runDB)
import           Data.Text             (unpack)
import           Data.Text.Encoding    (decodeUtf8)

data AuthResult = Authorized | Unauthorized deriving (Show)

toBool :: AuthResult -> Bool
toBool Authorized   = True
toBool Unauthorized = False

askBasicAuthentication :: ActionM ()
askBasicAuthentication = do
    W.status status401
    header "WWW-Authenticate" "Basic realm=\"please-auth\""
    html $ "unauthorized" 

checkAuthentified :: (B.ByteString -> B.ByteString -> AuthResult) -> ActionM AuthResult
checkAuthentified test = do
    hs <- (requestHeaders <$> request) >>= (return . lookup "Authorization")
    return $ maybe Unauthorized (authResult test) hs

authResult :: (B.ByteString -> B.ByteString -> AuthResult) -> B.ByteString -> AuthResult
authResult test b64AuthVal = either (\_ -> Unauthorized) (\(l,p) -> test l (B.drop 1 p)) authVal
    where authVal = (B64.decode $ B.drop 6 b64AuthVal) >>= (return . B.break (== columnSep))
                    where columnSep = B.head ":"

isAuthentified :: (B.ByteString -> B.ByteString -> AuthResult) -> W.ActionM Bool
isAuthentified test = (checkAuthentified test) >>= return . toBool

checkDB :: MonadIO m => PG.ConnectionPool -> B.ByteString -> B.ByteString -> m AuthResult
checkDB conPool user pass = do
    let db = runDB conPool
    storedUser <- db $ P.selectFirst [UserEmail P.==. (decodeUtf8 user)] []
    case storedUser of
        Nothing      -> return Unauthorized
        (Just sUser) -> case ((userPassword $ P.entityVal sUser) == (decodeUtf8 user)) of
                          False -> return Unauthorized
                          True  -> return Authorized

basicAuth :: (B.ByteString -> B.ByteString -> AuthResult) -> ActionM () -> ActionM ()
basicAuth test granted = do
    hs <- requestHeaders <$> request
    case lookup "Authorization" hs of
        Nothing     -> askBasicAuthentication
        (Just auth) -> case (authResult test auth) of
                        Authorized      -> granted
                        Unauthorized    -> askBasicAuthentication
