{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Akahsa.Commands (
    stripOuchCommand,
    stripPainsCommand,
    sayHi
) where

import           Text.Regex.TDFA ((=~))
import qualified Data.Text as T (Text, pack, unpack, append)
import qualified Web.Slack as S (SlackBot, Event(Message))
import qualified Web.Slack.Message as M (sendMessage)

type Regex = String

stripRegex :: Regex -> String -> Maybe String
stripRegex regex text =
    let prefixMatch = text =~ regex :: (String,String,String)
     in case prefixMatch of
          (_,"",_)   -> Nothing
          (_,_,rest) -> Just rest

stripOuchCommand :: T.Text -> Maybe T.Text
stripOuchCommand = fmap T.pack . stripRegex "^/?[Oo]uch[,:.]?[[:space:]]*" . T.unpack

stripPainsCommand :: T.Text -> Maybe T.Text
stripPainsCommand = fmap T.pack . stripRegex "^/?[Pp]ains[,:.]?[[:space:]]*" . T.unpack

sayHi :: S.SlackBot ()
sayHi (S.Message cid _ (stripOuchCommand -> Just pain) _ _ _) =
    M.sendMessage cid ("So you're hurting? " `T.append` pain)
sayHi (S.Message cid _ (stripPainsCommand -> Just _) _ _ _) =
    M.sendMessage cid "Here are the pains: ..."
sayHi (S.Message cid _ _ _ _ _) = M.sendMessage cid "Hello, World!"
sayHi _ = return ()

