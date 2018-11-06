module Login exposing (..)

import Alias exposing (..)
import Http
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


updateUsername : String -> LoginForm -> LoginForm
updateUsername u info =
    { info | username = u }


updatePassword : String -> LoginForm -> LoginForm
updatePassword p info =
    { info | password = p }


updateGuideline : Bool -> LoginForm -> LoginForm
updateGuideline agree info =
    { info | guideline = agree }


page : Model -> String -> Element Msg
page m mode =
    column [ centerX, padding 20, spacing 20, width (shrink |> Element.maximum 800) ]
        [ column [ spacing 15 ]
            [ Inp.username []
                { onChange =
                    if mode == "Login" then
                        \new -> UpdateLoginInfo <| updateUsername new m.loginInfo
                    else
                        \new -> UpdateRegisterInfo <| updateUsername new m.registerInfo
                , text =
                    if mode == "Login" then
                        m.loginInfo.username
                    else
                        m.registerInfo.username
                , placeholder = Just (Inp.placeholder [] (text "username"))
                , label = Inp.labelAbove [] (text "Username")
                }
            , Inp.currentPassword []
                { onChange =
                    if mode == "Login" then
                        \new -> UpdateLoginInfo <| updatePassword new m.loginInfo
                    else
                        \new -> UpdateRegisterInfo <| updatePassword new m.registerInfo
                , text =
                    if mode == "Login" then
                        m.loginInfo.password
                    else
                        m.registerInfo.password
                , placeholder = Just (Inp.placeholder [] (text "password"))
                , label = Inp.labelAbove [] (text "Password")
                , show = False
                }
            , (if mode /= "Login" then
                (Inp.checkbox [ alignLeft ]
                    { onChange =
                        if mode == "Login" then
                            \new -> UpdateLoginInfo <| updateGuideline new m.loginInfo
                        else
                            \new -> UpdateRegisterInfo <| updateGuideline new m.registerInfo
                    , icon = Inp.defaultCheckbox
                    , checked =
                        if mode == "Login" then
                            m.loginInfo.guideline
                        else
                            m.registerInfo.guideline
                    , label = Inp.labelRight [] (text "I agree to the following...")
                    }
                )
               else
                none
              )
            ]
        , column []
            [ Inp.button
                [ Border.width 0
                , Border.rounded 2
                , Border.glow col.obj_background 1
                , width <| px 100
                , height <| px 30
                ]
                { onPress =
                    Just
                        (if mode == "Login" then
                            LoginSend
                         else
                            RegisterSend
                        )
                , label = el [ centerY, centerX ] (text mode)
                }
            ]
        ]


login : LoginForm -> Cmd Msg
login loginInfo =
    Http.send LoginResv <|
        Http.request
            { method = "POST"
            , headers =
                [ Http.header "Upgrade-Insecure-Requests" "1"
                , Http.header "Accept" "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8<Paste>"
                ]
            , url = "/loginsend/"
            , body = Http.stringBody "application/x-www-form-urlencoded" ("username=" ++ loginInfo.username ++ "&password=" ++ loginInfo.password)
            , expect = Http.expectStringResponse (\n -> Ok ())
            , timeout = Nothing
            , withCredentials = False
            }


{-| I NEED TO ADD CAPTCHA
-}
register : LoginForm -> Cmd Msg
register registerInfo =
    Http.send RegisterResv <|
        Http.request
            { method = "POST"
            , headers =
                [ Http.header "Upgrade-Insecure-Requests" "1"
                , Http.header "Accept" "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8<Paste>"
                ]
            , url = "/register/"
            , body = Http.stringBody "application/x-www-form-urlencoded" ("username=" ++ registerInfo.username ++ "&password=" ++ registerInfo.password)
            , expect = Http.expectStringResponse (\n -> Ok ())
            , timeout = Nothing
            , withCredentials = False
            }
