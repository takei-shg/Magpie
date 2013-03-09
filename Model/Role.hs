{-# LANGUAGE OverloadedStrings    #-}
module Model.Role where

import           Control.Monad (mzero)
import           Control.Applicative     ((<$>))
import           Data.Text (unpack)
import qualified Data.Aeson as A

data Role
    = Driver | Navigator
    deriving (Show, Read, Eq, Enum)
 
instance A.FromJSON Role where
    parseJSON (A.Object v) = read <$> (v A..: "role")
    parseJSON _            = mzero

instance A.ToJSON Role where
    toJSON Driver = A.object [ "role" A..= ("Driver" :: String) ]
    toJSON Navigator = A.object [ "role" A..= ("Navigator" :: String) ]
