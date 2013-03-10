{-# LANGUAGE OverloadedStrings #-}
module JsonHelper where

import qualified Data.Aeson              as AE
import           Data.Monoid             (mconcat)
import           Data.Text               (pack)
import           Data.Text.Lazy.Internal (Text)
import qualified Network.HTTP.Types      as HT
import           Web.Scotty              (ActionM, body, json, rescue, status)

withRescue :: ActionM () -> ActionM ()
withRescue a = a `rescue` rescue'
  where
    rescue' e = case e of
      "jsonData: no parse" -> invalidJSON
      other                -> errorJSON other

invalidJSON :: ActionM ()
invalidJSON = do
  b <- body
  status HT.status400
  json $ AE.object ["message" AE..= mconcat ["Invalid JSON format: ", b]]

errorJSON :: Text -> ActionM ()
errorJSON error = do
    status HT.status400
    json $ AE.object ["message" AE..= mconcat ["error happend: ", error]]
