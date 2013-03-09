{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeSynonymInstances #-}
module Appbase
    ( app
    ) where

import           Control.Applicative     ((<$>))
import           Control.Monad.Trans
import           Data.Data
import           Data.Text ()
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           Web.Scotty              hiding (body)

data Info = Info {
    name   :: String
  , unread :: Int
  } deriving (Data, Typeable)

app :: ScottyM ()
app = do

    get "/" $
        file "app/views/index.html"
