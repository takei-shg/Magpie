{-# LANGUAGE OverloadedStrings    #-}
module Model.MatchStatus where

import           Control.Monad (mzero)
import           Control.Applicative     ((<$>))
import           Data.Text (unpack)
import qualified Data.Aeson as A

data MatchStatus
    = NOTPAIRED | PAIRED | CANCELLED | DONE
    deriving (Show, Read, Eq, Enum)

instance A.FromJSON MatchStatus where
    parseJSON (A.Object v) = read <$> (v A..: "status")
    parseJSON _            = mzero

instance A.ToJSON MatchStatus where
    toJSON NOTPAIRED = A.object [ "status" A..= ("NOTPAIRED" :: String) ]
    toJSON PAIRED    = A.object [ "status" A..= ("PAIRED" :: String) ]
    toJSON CANCELLED  = A.object [ "status" A..= ("CANCELLED" :: String) ]
    toJSON DONE      = A.object [ "status" A..= ("DONE" :: String) ]
