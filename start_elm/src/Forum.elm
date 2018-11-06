module Forum exposing (..)

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


page : Model -> Element Msg
page m =
    text "This is description of forum"
