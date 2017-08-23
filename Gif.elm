module Name exposing (Model, Msg, update, view, subscriptions, init)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode


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
    { topic : String
    , gifUrl : String
    }


-- UPDATE

type Msg
    = MorePls
    | NewGif (Result Http.Error String)
    | Topic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePls ->
            (model, getRandomGif model.topic)

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl }, Cmd.none)

        NewGif (Err _) ->
            (model, Cmd.none)
        
        Topic topic ->
            ( { model | topic = topic }, Cmd.none)

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
        
        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at ["data", "image_url"] Decode.string

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h2 [] [text model.topic]
        , img [src model.gifUrl] []
        , button [ onClick MorePls ] [ text "More Plsss!" ]
        , input [ type_ "text", placeholder "Topic", onInput Topic ] []
        ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- INIT

init : (Model, Cmd Msg)
init = 
    (Model "cats" "waiting.gif", Cmd.none)
