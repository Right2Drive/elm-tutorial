module RadioButtons exposing (Model, Msg, update, view, subscriptions, init)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
    { fontSize : FontSize
    , content : String
    }

type FontSize = Small | Medium | Large

-- INIT

init : (Model, Cmd Msg)
init = 
    (Model Medium intro, Cmd.none)

intro : String
intro = """

# Anna Karenina

## Chapter 1

Happy families are all alike; every unhappy family is unhappy in its own way.

Everything was in confusion in the Oblonskys’ house. The wife had discovered
that the husband was carrying on an intrigue with a French girl, who had been
a governess in their family, and she had announced to her husband that she
could not go on living in the same house with him...

"""


-- UPDATE

type Msg
    = SwitchTo FontSize

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SwitchTo fontSize ->
            ({ model | fontSize = fontSize }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ fieldset []
            [ radio Small
            , radio Medium
            , radio Large
            ]
        , Markdown.toHtml [ sizeToStyle model.fontSize ] model.content
        ]

radio : FontSize -> Html Msg
radio fontType =
    label
        [ style [("padding", "20px")]
        ]
        [ input [ type_ "radio", name "font-size", onClick (SwitchTo fontType) ] []
        , text (radioText fontType)
        ]

radioText : FontSize -> String
radioText fontType =
    case fontType of
        Small ->
            "Small"
        
        Medium ->
            "Medium"

        Large ->
            "Large"

sizeToStyle : FontSize -> Attribute msg
sizeToStyle fontSize =
    let
        size =
            case fontSize of
                Small ->
                    "0.8em"

                Medium ->
                    "1em"
                
                Large ->
                    "1.2em"
    in
        style [("font-size", size)]
