module Main exposing (..)

import Browser
import Color exposing (..)
import ForumList as Forums
import Task exposing (..)
import Html
import Alias exposing (..)
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Background as Ba
import Element.Border as Bo
import Element.Font as F
import Element.Input as I
import Element.Region as R
import Config exposing (getUserConfig)
import Browser


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { device = { width = 500, height = 500 }
      , flag = False
      }
    , Cmd.batch [ initEvent, getUserConfig ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        OnResize w h ->
            ( { m | device = { width = w, height = h } }, Cmd.none )

        InitSize win ->
            ( { m | device = win }, Cmd.none )

        UserConfig result ->
            case result of
                Ok config ->
                    ( { m | flag = config }, Cmd.none )

                Err _ ->
                    ( m, Cmd.none )


view : Model -> Html.Html Msg
view m =
    layout []
        (column
            [ width fill
            ]
            [ row [ width fill, height <| px 120, Ba.color col.obj_background ]
                -- TODO onclick on logo should go to root page with []forums
                [ el [ width fill, height fill ] (image [ centerY, height (fill |> maximum 120) ] { src = "logo.png", description = "Logo" })
                ]

            -- Plan is to List.map over all forums and run entry for index, index will be backend's "priority"
            , Forums.entry <|
                Forums.newForum "First Sample Forum"
                    [ "some categories"
                    , "like this one"
                    , "or this one"
                    , "baba"
                    , "baba"
                    , "baba"
                    , "baba"
                    , "baba"
                    ]
                    "1.png"
            , Forums.entry <|
                Forums.newForum "Another Forum"
                    [ "blba"
                    , "baba"
                    ]
                    "2.png"
            , text <| Debug.toString m.flag
            ]
        )
