module ForumList exposing (newForum, entry)

-- remember to not use .. here

import Element exposing (..)
import List exposing (map)
import Element.Border as B
import Element.Font as F
import Color exposing (..)


-- Priority takes effect on backend side


type alias Forum =
    -- Do i even need icon? Or can i just use index? ¯\_(ツ)_/¯
    { title : String, subForums : List String, icon : String }


{-| Create new forum from raw data
used for debugging
-}
newForum : String -> List String -> String -> Forum
newForum title subs img =
    { title = title, subForums = subs, icon = img }


entry : Forum -> Element msg
entry f =
    column
        [ width (fill |> maximum 950)
        , padding 10
        , centerX

        --, B.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
        ]
        [ row [ spacing 10 ] [ image [ height <| px 50, moveDown 14 ] { src = "forum-icons/" ++ f.icon, description = "Forum icon" }, forumTitle f.title ]
        , column [] <| List.map subForumTitle f.subForums
        ]


forumTitle : String -> Element msg
forumTitle forumName =
    el [] (text forumName)


subForumTitle : String -> Element msg
subForumTitle subForumName =
    el [ moveRight 120, F.size 12 ] (text subForumName)



{-
   requestSubforum : String -> Cmd Msg
   requestSubforum path =
       -- Do http request and enter subforum properly via Cmd Msg
       -- This should be called at init
-}
