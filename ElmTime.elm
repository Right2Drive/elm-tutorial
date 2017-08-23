module ElmTime exposing (Model, Msg, update, view, subscriptions, init)


import Html exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time, second)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task exposing (perform)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }

-- CONSTANTS

seconds : number
seconds =
    60

-- MODEL

type alias Model = 
    { time: Time
    , pause: Bool
    , counter: Int
    }


-- UPDATE

type Msg
    = Tick Time
    | SetTime Time
    | Play
    | Pause
    | Toggle


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            if model.pause then
                ( { model | time = newTime }, Cmd.none )
            else
                ( { model | time = newTime, counter = increment model }, Cmd.none)
        
        SetTime newTime ->
            ( { model | time = newTime }, Cmd.none)
        
        Play ->
            ( { model | pause = False }, Cmd.none)

        Pause ->
            ( { model | pause = True }, Cmd.none)

        Toggle ->
            ( { model | pause = not model.pause}, Cmd.none)

increment : Model -> Int
increment model =
    if (model.pause) then
        model.counter
    else
        (model.counter + 1) % seconds


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


-- INIT

init : (Model, Cmd Msg)
init = 
    (Model 0 False 0, perform SetTime Time.now)


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ generateSvg model
        , button [ onClick Toggle ] [ Html.text (toggleLabel model) ]
        ]
    
generateSvg : Model -> Html msg
generateSvg model =
    svg [ viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
        [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
        , model
            |> timeAngle Time.inMinutes
            |> getLine "#626262" 40
        , model
            |> timeAngle Time.inHours
            |> getLine "#ffffff" 35
        , model
            |> counterAngle
            |> getLine "#000000" 40
        ]

getLine : String -> Float -> Float -> Svg msg
getLine lineColor length angle =
    let
        handX =
            toString (50 + length * cos angle)

        handY =
            toString (50 + length * sin angle)
    in
        line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke lineColor ] []


timeAngle : (Time -> Float) -> Model -> Float
timeAngle timeFunc model =
    turns (timeFunc model.time)

counterAngle : Model -> Float
counterAngle model =
    turns ((toFloat model.counter - 15) / seconds)

toggleLabel : Model -> String
toggleLabel model =
    if model.pause then
        "Play"
    else
        "Pause"
