{-# LANGUAGE OverloadedStrings #-}

module Render where

import           AWSLambda.Events.APIGateway
import           Control.Lens
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy.Internal as BSL
import           Data.Maybe
import           Data.Text
import           Data.Text.Encoding
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

getProxyBody :: Http.Response BSL.ByteString -> IO Text
getProxyBody resFromGivenUrl = return . LazyText.toStrict . LazyText.decodeUtf8 $ resFromGivenUrl ^. Http.responseBody

findUrl :: [(BS.ByteString, Maybe BS.ByteString)] -> Maybe BS.ByteString
findUrl []     = Nothing
findUrl (q:qs) = if fst q == "url" then snd q else findUrl qs

handler :: APIGatewayProxyRequest Text -> IO (APIGatewayProxyResponse Text)
handler request = do
  let urlRequested = decodeUtf8 $ fromMaybe "" $ findUrl $ request ^. agprqQueryStringParameters

  r <- Http.get $ "https://ios10m3q6k.execute-api.us-east-1.amazonaws.com/dev/endpoint/" <> unpack urlRequested
  body <- getProxyBody r

  htmlRes 200 body

