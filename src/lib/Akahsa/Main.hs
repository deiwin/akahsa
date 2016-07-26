{-# LANGUAGE OverloadedStrings #-}

module Akahsa.Main (
    runBot
) where

import           System.Environment (getEnv)
import qualified Web.Slack as S (runBot)
import qualified Web.Slack.Config as C (SlackConfig(..))
import qualified Akahsa.Commands as Com (sayHi)

runBot :: IO ()
runBot = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = C.SlackConfig { C._slackApiToken = token }
    S.runBot conf Com.sayHi ()

