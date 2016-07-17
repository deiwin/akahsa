{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Main where

import           System.Environment (getEnv)
import           Text.Regex.TDFA ((=~))
import qualified Data.Text as T (Text, pack, unpack, append)
import qualified Web.Slack as S (runBot, SlackBot, Event(Message))
import qualified Web.Slack.Message as M (sendMessage)
import qualified Web.Slack.Config as C (SlackConfig(..))

stripOuchCommand' :: String -> Maybe String
stripOuchCommand' text =
    let regex = "^/?[Oo]uch[,:.]?[[:space:]]*" :: String
        prefixMatch = text =~ regex :: (String,String,String)
     in case prefixMatch of
          (_,"",_)   -> Nothing
          (_,_,rest) -> Just rest

stripOuchCommand :: T.Text -> Maybe T.Text
stripOuchCommand = fmap T.pack . stripOuchCommand' . T.unpack

sayHi :: S.SlackBot ()
sayHi (S.Message cid _ (stripOuchCommand -> Just pain) _ _ _) =
    M.sendMessage cid ("So you're hurting? " `T.append` pain)
sayHi (S.Message cid _ _ _ _ _) = M.sendMessage cid "Hello, World!"
sayHi _ = return ()

main :: IO ()
main = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    let conf = C.SlackConfig { C._slackApiToken = token }
    S.runBot conf sayHi ()

