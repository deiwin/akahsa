{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Akahsa.Model (
    Pain,
    PainId,
    migrateAll
) where

import Database.Persist.TH (share, mkPersist, sqlSettings, mkMigrate, persistLowerCase)
import Data.Text (Text)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Pain
    description Text
    deriving Show
|]
