{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Akahsa.Commands (
    stripOuchCommand,
    stripPainsCommand,
    sayHi
) where

-- TODO Parser instead?
import           Text.Regex.TDFA ((=~))
import Data.Text as T (Text, pack, unpack, unlines)
import Data.Monoid ((<>))
import qualified Web.Slack as S (SlackBot, Event(Message))
import qualified Web.Slack.Message as M (sendMessage)
import Database.Persist.Sql (SqlBackend)
import Database.Persist (insert, selectList, entityVal)
import Data.Pool (Pool, withResource)
import Akahsa.Model (Pain(Pain, painDescription))
import Control.Monad.Reader (runReaderT)
import Control.Monad.IO.Class (liftIO)

type Regex = String

stripRegex :: Regex -> String -> Maybe String
stripRegex regex text =
    let prefixMatch = text =~ regex :: (String,String,String)
     in case prefixMatch of
          (_,"",_)   -> Nothing
          (_,_,rest) -> Just rest

stripOuchCommand :: Text -> Maybe Text
stripOuchCommand = fmap pack . stripRegex "^/?[Oo]uch[,:.]?[[:space:]]*" . unpack

stripPainsCommand :: Text -> Maybe Text
stripPainsCommand = fmap pack . stripRegex "^/?[Pp]ains[,:.]?[[:space:]]*" . unpack

sayHi :: Pool SqlBackend -> S.SlackBot ()
sayHi pool (S.Message cid _ (stripOuchCommand -> Just pain) _ _ _) = do
    painId <- liftIO $ withResource pool $ runReaderT $ insert $ Pain pain
    liftIO $ print painId
    M.sendMessage cid ("So you're hurting? " <> pain)
sayHi pool (S.Message cid _ (stripPainsCommand -> Just _) _ _ _) = do
    pains <- liftIO $ withResource pool $ runReaderT $ selectList [] []
    M.sendMessage cid ("Here are the pains:\n" <> T.unlines (fmap (painDescription . entityVal) pains))
sayHi _ (S.Message cid _ _ _ _ _) = M.sendMessage cid "Hello, World!"
sayHi _ _ = return ()

