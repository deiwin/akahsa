{-# LANGUAGE OverloadedStrings #-}

module Akahsa.Main (
    runPainBot
) where

import System.Environment (getEnv)
import Web.Slack (runBot)
import Web.Slack.Config (SlackConfig(..))
import Akahsa.Commands (sayHi)

runPainBot :: IO ()
runPainBot = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = SlackConfig { _slackApiToken = token }
    runBot conf sayHi ()

