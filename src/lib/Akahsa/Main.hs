{-# LANGUAGE OverloadedStrings #-}

-- TODO update resolver in stack.yaml + remove transformers from
-- akahsa.cabal, and remove slack-api from stack.yaml and move to cabal file instead
module Akahsa.Main (
    runPainBot
) where

import System.Environment (getEnv)
import Web.Slack (runBot, SlackConfig(..))
import Akahsa.Commands (sayHi)
import Database.Persist.Sql (runMigration)
import Database.Persist.Postgresql (withPostgresqlPool)
import Control.Monad.IO.Class (liftIO)
import Data.Pool (withResource)
import Control.Monad.Reader (runReaderT)
import Control.Monad.Logger (runStdoutLoggingT)
import Akahsa.Model (migrateAll)

runPainBot :: IO ()
runPainBot = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = SlackConfig { _slackApiToken = token }
    let connectionString = "host=localhost port=5432 user=salemove dbname=akahsa password=salemovepass"
    runStdoutLoggingT $ withPostgresqlPool connectionString 2 (\pool -> do
        withResource pool $ runReaderT (runMigration migrateAll)
        liftIO $ runBot conf (sayHi pool) ())
