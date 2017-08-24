module Subscriptions exposing (Model, Msg, update, view, subscriptions, init)


import Html exposing (..)
import Mouse
import Keyboard


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
    { counter : Int
    }


-- INIT

init : (Model, Cmd Msg)
init = 
    (Model 0, Cmd.none)


-- UPDATE

type Msg
    = MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MouseMsg pos ->
            ( { model | counter = model.counter + 1 }, Cmd.none)
        
        KeyMsg code ->
            ( { model | counter = model.counter + 2 }, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        , Keyboard.downs KeyMsg
        ]


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ text (toString model.counter)
        ]
