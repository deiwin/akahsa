{-# LANGUAGE OverloadedStrings #-}
module Main where

import           System.Environment (getEnv)
import qualified Network.Wai as Wai (responseLBS, Application)
import qualified Network.Wai.Handler.Warp as Warp (run)
import           Network.HTTP.Types (status200)

app :: Wai.Application
app req respond =
    respond $ Wai.responseLBS status200 [] "Hello World"

main :: IO ()
main = do
    token <- getEnv "AKAHSA_SLACK_TOKEN"
    url <- getEnv "AKAHSA_SLACK_URL"
    portString <- getEnv "AKAHSA_PORT"
    let port = read portString :: Int
    putStrLn ("token: \"" ++ token ++ "\", url: \"" ++ url ++ "\"")
    Warp.run port app
