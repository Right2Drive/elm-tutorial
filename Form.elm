import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Regex

main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , color: String
    , status: String
    }

model : Model
model =
    Model "" "" "" "" ""

-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Submit

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }
        
        Submit ->
            let
                (color, status) = modelValidationDiv model
            in
                { model | color = color, status = status }


modelValidationDiv : Model -> ( String, String )
modelValidationDiv model =
    if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
    else if not (passwordValidationDiv model) then
        ("red", "Password must be at least 8 characters and contain at least one uppercase letter, one number and one special character")
    else
        ("green", "OK")

passwordValidationDiv : Model -> Bool
passwordValidationDiv model =
    passwordMatch model.password

passwordMatch : String -> Bool
passwordMatch password =
    let
        list =
            Regex.find (Regex.AtMost 1) passwordRegex password
    in
        ( List.length list == 1
        && regexMatch (List.head list) password 
        )

regexMatch : Maybe { b | match : a } -> a -> Bool
regexMatch regexMatch check =
    case regexMatch of
        Nothing ->
            False
        Just regexMatch ->
            regexMatch.match == check


passwordRegex : Regex.Regex
passwordRegex =
    Regex.regex "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Submit ] [ text "Submit" ]
    , validationDiv model
    ]

validationDiv : Model -> Html Msg
validationDiv model =
    if not (String.isEmpty model.status) then
        div [ style [("color", model.color)] ] [ text model.status ]        
    else
        Html.text ""
