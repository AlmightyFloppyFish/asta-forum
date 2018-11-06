module Mobile exposing (..)

import Alias exposing (..)
import Html
import Html.Attributes exposing (name, attribute)
import Task exposing (perform)
import Color exposing (col)
import List exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Inp


isMobile : WinSize -> Bool
isMobile s =
    if s.width < (s.height - 50) || s.width < 500 then
        True
    else
        False


bar : Model -> Element Msg
bar m =
    (row
        [ width fill
        , height <| px 39
        , Background.color col.obj_background
        , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 4, color = col.obj_background }
        ]
        [ html (Html.node "meta" [ name "viewport", attribute "content" "width=device-width, initial-scale=1" ] [])
        , burger m.burgerIsActive ActivateBurger
        , logo centerX "Asta Forum"
        ]
    )


logo : Attribute msg -> String -> Element msg
logo msg t =
    el
        [ moveLeft 20
        , Font.size 20
        , Font.color col.obj_foreground
        , msg
        ]
        (text t)


menu : List (Attribute msg) -> List (Element msg) -> Element msg
menu looks options =
    column looks options


menu_option : String -> msg -> Element msg
menu_option lab action =
    Inp.button
        [ width fill
        , mouseOver [ Background.color col.obj_foreground_hover ]
        , padding 20
        , Font.color col.obj_foreground
        ]
        { onPress = Just action, label = text lab }


burger : Bool -> msg -> Element msg
burger a m =
    Inp.button [ focused [] ]
        { onPress = Just m
        , label =
            if a then
                row [ padding 5, height fill, spacing 8 ] [ burger_line a, burger_line a, burger_line a ]
            else
                column [ padding 5, height fill, spacing 6 ] [ burger_line a, burger_line a, burger_line a ]
        }


burger_line : Bool -> Element msg
burger_line activated =
    if activated then
        el
            [ width (px 5)
            , height (px 29)
            , Background.color col.obj_foreground
            , Font.color col.obj_foreground
            , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 1, color = col.obj_foreground }
            ]
            (none)
    else
        el
            [ width (px 32)
            , height (px 5)
            , Background.color col.obj_foreground
            , Font.color col.obj_foreground
            , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 1, color = col.obj_foreground }
            ]
            (none)
