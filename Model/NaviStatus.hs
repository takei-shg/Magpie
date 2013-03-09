{-# LANGUAGE OverloadedStrings    #-}
module Model.NaviStatus where

import           Control.Monad (mzero)
import           Control.Applicative     ((<$>))
import           Data.Text (unpack)
import qualified Data.Aeson as A

data NaviStatus
    = NOTYET | MATCHED | CANCELLED | DONE | CLOSED
    deriving (Show, Read, Eq, Enum)

instance A.FromJSON NaviStatus where
    parseJSON (A.Object v) = read <$> (v A..: "status")
    parseJSON _            = mzero

instance A.ToJSON NaviStatus where
    toJSON NOTYET    = A.object [ "status" A..= ("NOTYET" :: String) ]
    toJSON MATCHED = A.object [ "status" A..= ("MATCHED" :: String) ]
    toJSON CANCELLED  = A.object [ "status" A..= ("CANCELLED" :: String) ]
    toJSON DONE      = A.object [ "status" A..= ("DONE" :: String) ]
    toJSON CLOSED = A.object [ "status" A..= ("CLOSED" :: String) ]
