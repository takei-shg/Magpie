{-# LANGUAGE OverloadedStrings    #-}
module Model.SlotStatus where

import           Control.Monad (mzero)
import           Control.Applicative     ((<$>))
import           Data.Text (unpack)
import qualified Data.Aeson as A

data SlotStatus
    = NOTYET | NODRIVER | ASSIGNINED | CANCELLED | DONE | CLOSED
    deriving (Show, Read, Eq, Enum)

instance A.FromJSON SlotStatus where
    parseJSON (A.Object v) = read <$> (v A..: "status")
    parseJSON _            = mzero

instance A.ToJSON SlotStatus where
    toJSON NOTYET    = A.object [ "status" A..= ("NOTYET" :: String) ]
    toJSON NODRIVER = A.object [ "status" A..= ("NODRIVER" :: String) ]
    toJSON ASSIGNINED = A.object [ "status" A..= ("ASSIGNINED" :: String) ]
    toJSON CANCELLED  = A.object [ "status" A..= ("CANCELLED" :: String) ]
    toJSON DONE      = A.object [ "status" A..= ("DONE" :: String) ]
    toJSON CLOSED = A.object [ "status" A..= ("CLOSED" :: String) ]
