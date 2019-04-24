{-# LANGUAGE OverloadedStrings #-}

module Proxy where

import           AWSLambda.Events.APIGateway
import           Control.Lens
import qualified Data.ByteString.Lazy.Internal as BSL
import qualified Data.HashMap.Strict as HMS
import           Data.Text
import qualified Data.Text.Lazy as LazyText
import qualified Data.Text.Lazy.Encoding as LazyText
import qualified Network.Wreq as Http

mainHandler :: IO ()
mainHandler = apiGatewayMain handler

htmlRes :: Int -> Text -> IO (APIGatewayProxyResponse Text)
htmlRes status proxyBody = pure $ htmlResWithNoBody status & responseBody ?~ proxyBody
  where
    htmlResWithNoBody :: Int -> APIGatewayProxyResponse Text
    htmlResWithNoBody statusCode = APIGatewayProxyResponse statusCode [("Content-Type", "text/html")] Nothing    

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

