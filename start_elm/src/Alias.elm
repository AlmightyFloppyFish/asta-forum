module Alias exposing (..)

import Http
import Browser.Events exposing (..)
import Task exposing (..)
import Browser.Dom


type alias Model =
    { winSize : WinSize
    , burgerIsActive : Bool
    , activePage : Page
    , loginInfo : LoginForm
    , registerInfo : LoginForm
    , user : String
    }


type alias LoginForm =
    { username : String, password : String, guideline : Bool }


type alias WinSize =
    { width : Int, height : Int }


type Page
    = Forum
    | Login
    | Register
    | Logout


type Msg
    = OnResize Int Int
    | InitEvent Browser.Dom.Viewport
    | ActivateBurger
    | SetActivePage Page
    | UpdateLoginInfo LoginForm
    | UpdateRegisterInfo LoginForm
    | LoginSend
    | LoginResv (Result Http.Error ())
    | RegisterSend
    | RegisterResv (Result Http.Error ())


initEvent : Cmd Msg
initEvent =
    Browser.Dom.getViewport
        |> Task.perform InitEvent


subscriptions : Model -> Sub Msg
subscriptions model =
    onResize OnResize
