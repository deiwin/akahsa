{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Main where

import           System.Environment (getEnv)
import qualified Data.Text as T (stripPrefix, append)
import qualified Web.Slack as S (runBot, SlackBot, Event(Message))
import qualified Web.Slack.Message as M (sendMessage)
import qualified Web.Slack.Config as C (SlackConfig(..))

sayHi :: S.SlackBot ()
sayHi (S.Message cid _ (T.stripPrefix "ouch " -> Just pain) _ _ _) =
    M.sendMessage cid ("So you're hurting? " `T.append` pain)
sayHi (S.Message cid _ _ _ _ _) = M.sendMessage cid "Hello, World!"
sayHi _ = return ()

main :: IO ()
main = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = C.SlackConfig { C._slackApiToken = token }
    S.runBot conf sayHi ()

