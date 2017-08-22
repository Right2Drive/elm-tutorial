import Html exposing (..)
import Random
import Html.Events exposing (onClick)

numberOfDie : number
numberOfDie = 2

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
    { dieFaces: List Int
    }



-- UPDATE

type Msg
    = Roll
    | NewFace (List Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            (model, rollDie)

        NewFace newFace ->
            (Model newFace, Cmd.none)

rollDie : Cmd Msg
rollDie =
    Random.generate NewFace (Random.list numberOfDie faceGenerator)

faceGenerator : Random.Generator Int
faceGenerator =
    Random.int 1 6



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- INIT

init : ( Model, Cmd msg )
init =
    (Model (List.repeat numberOfDie 1), Cmd.none)



-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ ul [] (generateDieFaces model)
        , button [ onClick Roll ] [ text "Roll" ]
        ]

generateDieFaces : Model -> List (Html Msg)
generateDieFaces model =
    List.map generateDieFace model.dieFaces

generateDieFace : a -> Html msg
generateDieFace value =
    h1 []  [ text (toString value) ]
