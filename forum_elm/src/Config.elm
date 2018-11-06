module Config exposing (..)

import Alias exposing (..)
import Http
import Json.Decode exposing (..)


configDecoder : Decoder Bool
configDecoder =
    field "flag" bool


getUserConfig : Cmd Msg
getUserConfig =
    Http.send UserConfig (Http.get ("/forums/test.json") configDecoder)
