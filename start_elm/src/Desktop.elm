module Desktop exposing (..)

import Alias exposing (..)
import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Inp


updateUsername : String -> LoginForm -> LoginForm
updateUsername u info =
    { info | username = u }


updatePassword : String -> LoginForm -> LoginForm
updatePassword p info =
    { info | password = p }


updateGuideline : Bool -> LoginForm -> LoginForm
updateGuideline agree info =
    { info | guideline = agree }


bar : Model -> Element Msg
bar m =
    row
        [ width fill
        , height <| px 120
        , Background.color col.obj_background
        ]
        [ el [ width fill, height fill ]
            (image
                [ centerY
                , height (fill |> maximum 120)
                ]
                { src = "logo.png", description = "Logo" }
            )
        , column [ width fill, height fill, alignRight, spacing 2, padding 10 ]
            [ el [ Font.color col.obj_foreground, alignRight, Font.size 14 ] (text "Not a member?")
            , Inp.username [ width shrink, alignRight, height <| px 32 ]
                { onChange = \new -> UpdateRegisterInfo <| updateUsername new m.registerInfo
                , text = m.registerInfo.username
                , placeholder = Just (Inp.placeholder [ Font.size 10 ] (text "username"))
                , label = Inp.labelRight [ centerY ] (none)
                }
            , Inp.currentPassword [ width shrink, alignRight, height <| px 32 ]
                { onChange = \new -> UpdateRegisterInfo <| updatePassword new m.registerInfo
                , text = m.registerInfo.password
                , placeholder = Just (Inp.placeholder [ Font.size 10 ] (text "password"))
                , label = Inp.labelRight [ centerY ] (none)
                , show = False
                }
            , Inp.button
                [ alignRight
                , Background.color <| rgb 1 1 1
                , Border.width 0
                , Border.rounded 2
                , Border.glow col.obj_foreground 1
                , Border.color col.obj_background
                , moveDown 2
                , moveLeft 4
                ]
                { onPress = Just RegisterSend
                , label = el [ Font.color col.obj_background, Font.size 17, moveDown 1 ] (text "Register")
                }
            ]
        ]
