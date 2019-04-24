{-# LANGUAGE OverloadedStrings #-}

module Main where

import           AWSLambda.Events.APIGateway
import           Control.Lens
import           Data.Aeson
import           Data.Aeson.Embedded
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy.Internal as BSL
import qualified Data.HashMap.Strict as HMS
import           Data.Maybe
import           Data.Text
import qualified Data.Text.Lazy as LazyText
import qualified Data.Text.Lazy.Encoding as LazyText
import qualified Network.Wreq as Http

main = apiGatewayMain handler

htmlRes :: Int -> Text -> IO (APIGatewayProxyResponse Text)
htmlRes status proxyBody = pure $ htmlResWithNoBody status & responseBody ?~ proxyBody
  where
    htmlResWithNoBody :: Int -> APIGatewayProxyResponse Text
    htmlResWithNoBody status = APIGatewayProxyResponse status [("Content-Type", "text/html")] Nothing    

protocol :: String
protocol = "https://"

getProxyBody :: Http.Response BSL.ByteString -> IO Text
getProxyBody resFromGivenUrl = return . LazyText.toStrict . LazyText.decodeUtf8 $ resFromGivenUrl ^. Http.responseBody

handler :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
handler request = do
  let urlPath = HMS.lookup "url" $ request ^. agprqPathParameters

  case urlPath of
    Just path ->
      (Http.get $ protocol <> unpack path) 
        >>= getProxyBody
        >>= htmlRes 200
    Nothing -> htmlRes 500 "No path found"

