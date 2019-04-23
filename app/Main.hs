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

html200Res :: Text -> IO (APIGatewayProxyResponse Text)
html200Res proxyBody = pure $ html200ResWithNoBody & responseBody ?~ proxyBody
  where
    html200ResWithNoBody :: APIGatewayProxyResponse Text
    html200ResWithNoBody = APIGatewayProxyResponse 200 [("Content-Type", "text/html")] Nothing

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
        >>= html200Res 
    Nothing -> html200Res "No path found"

