module Alias exposing (..)

import Browser.Events exposing (..)
import Element exposing (Device)
import Task exposing (..)
import Http
import Browser.Dom


type alias Model =
    { device : Window, flag : Bool }


type alias Window =
    { width : Int, height : Int }


type Msg
    = OnResize Int Int
    | InitSize Window
    | UserConfig (Result Http.Error Bool)


initEvent : Cmd Msg
initEvent =
    Browser.Dom.getViewport
        |> Task.perform (\vp -> InitSize { width = round vp.scene.width, height = round vp.scene.height })


subscriptions : Model -> Sub Msg
subscriptions model =
    onResize OnResize
