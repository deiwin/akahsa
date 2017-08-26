{-# LANGUAGE OverloadedStrings #-}

-- TODO update resolver in stack.yaml + remove transformers from akahsa.cabal
module Akahsa.Main (
    runPainBot
) where

import System.Environment (getEnv)
import Web.Slack (runBot)
import Web.Slack.Config (SlackConfig(..))
import Akahsa.Commands (sayHi)
import Database.Persist.Postgresql (withPostgresqlPool)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Logger (runNoLoggingT)

runPainBot :: IO ()
runPainBot = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = SlackConfig { _slackApiToken = token }
    let connectionString = "host=localhost port=5432 user=salemove dbname=akahsa password=salemovepass"
    runNoLoggingT $ withPostgresqlPool connectionString 2 (\pool ->
        liftIO $ runBot conf (sayHi pool) ())
