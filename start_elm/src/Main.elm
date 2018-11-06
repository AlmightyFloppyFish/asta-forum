module Main exposing (..)

import Browser
import Color exposing (..)
import Mobile as Mobile
import Task exposing (..)
import Html
import Alias exposing (..)
import Desktop exposing (..)
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Inp
import Element.Region as Region
import Browser
import Browser.Navigation exposing (load)
import Login
import Forum


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


{-| So it turns out elm-ui has thingy for detecting device...
TODO
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( { winSize = { width = 1000, height = 1000 }
      , burgerIsActive = False
      , activePage = Login
      , loginInfo = { username = "", password = "", guideline = False }
      , registerInfo = { username = "", password = "", guideline = False }
      , user = "Logged Out"
      }
    , initEvent
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        OnResize w h ->
            ( { m | winSize = { width = w, height = h } }, Cmd.none )

        InitEvent res ->
            ( { m | winSize = { width = truncate res.scene.width, height = truncate res.scene.height } }, Cmd.none )

        ActivateBurger ->
            ( if m.burgerIsActive then
                { m | burgerIsActive = False }
              else
                { m | burgerIsActive = True }
            , Cmd.none
            )

        SetActivePage p ->
            -- This recursively runs update, that's a pretty cool way to do it which i havn't done before
            update ActivateBurger { m | activePage = p }

        UpdateLoginInfo new ->
            ( { m | loginInfo = new }, Cmd.none )

        UpdateRegisterInfo new ->
            ( { m | registerInfo = new }, Cmd.none )

        LoginSend ->
            ( m, Login.login m.loginInfo )

        -- Here i should instead just redirect to the forum site, which is a different elm file
        -- So none of this shit matters pretty much. After I'm done debugging i should remove this
        LoginResv (Ok _) ->
            -- This should redirect to a temp-page (handled by go backend) which tells whether it was successfull or not
            -- and redirects either back to here or forward depending on result
            ( { m | user = "Logged In", loginInfo = { username = "", password = "", guideline = False } }, Cmd.none )

        LoginResv (Err e) ->
            ( m, Cmd.none )

        RegisterSend ->
            ( m, Login.register m.registerInfo )

        RegisterResv (Ok _) ->
            ( { m | user = "Logged In", registerInfo = { username = "", password = "", guideline = False } }, Cmd.none )

        RegisterResv (Err _) ->
            ( { m | user = "Logged In", registerInfo = { username = "", password = "", guideline = False } }, Cmd.none )


redirectToForum =
    load "/forums/"


view : Model -> Html.Html Msg
view m =
    Element.layout [ Background.color col.background ]
        (column [ width fill, spacing 10 ]
            -- TODO Switch to elm-ui api for device detection
            [ (if (Mobile.isMobile m.winSize) then
                column [ width fill ]
                    [ Mobile.bar m
                    , (if m.burgerIsActive then
                        Mobile.menu
                            [ width fill
                            , Background.color col.obj_background
                            , Border.color col.obj_foreground
                            , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 8, color = col.obj_background }
                            ]
                            [ Mobile.menu_option "Info" (SetActivePage Forum)
                            , Mobile.menu_option "Login" (SetActivePage Login)
                            , Mobile.menu_option "Register" (SetActivePage Register)
                            , Mobile.menu_option "Logout" (SetActivePage Logout)
                            ]
                       else
                        none
                      )
                    ]
               else
                -- Desktop bar, probably should have side info as well here.
                Desktop.bar m
              )
            , case m.activePage of
                Forum ->
                    Forum.page m

                Login ->
                    -- Register or login? Add parameter
                    Login.page m "Login"

                Register ->
                    Login.page m "Register"

                Logout ->
                    -- TODO
                    text "todo"

            -- TODO Switch to elm-ui api for device detection
            , (if Mobile.isMobile m.winSize then
                column [ width fill ] [ el [ Background.color col.obj_background, width fill ] (image [ width fill ] { src = "logo.png", description = "Logo" }) ]
               else
                none
              )
            ]
        )
