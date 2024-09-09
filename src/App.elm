port module App exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Char exposing (fromCode)
import Round as R exposing (round)



-- CUSTOM FUNCTIONS


unicodeToString : Int -> String
unicodeToString codePoint =
    codePoint
        |> fromCode
        |> String.fromChar


-- PORTS
port reset : (String -> msg) -> Sub msg

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    reset Reset


-- MODEL


type alias Model =
    { enteredWeight : String
    , cannedTaurine : Float
    , dryTaurine : Float
    , message : String
    }


init : () -> ( Model, Cmd Msg )
init () =
    ({ enteredWeight = ""
    , cannedTaurine = 0.0
    , dryTaurine = 0.0
    , message = ""
    }, Cmd.none)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "flex flex-col justify-start gap-6" ]
        [ div [ class "flex flex-col justify-start gap-1" ]
            [ label [ class "font-semibold text-sm" ] [ text "Cat's weight" ]
            , div [class "flex flex-row flex-nowrap justify-start gap-2"] [input
                [ type_ "text"
                , placeholder "Insert weight"
                , onInput UpdateWeight
                , value model.enteredWeight
                , class
                    (if model.message /= "" then
                        "bg-red-100 border-red-500 hover:border-red-600 focus:ring-red-300/50 focus:border-red-600"

                     else
                        ""
                    )
                ]
                [], p [ class "h-fit my-auto"] [text " kg"]
            ]
            , span [ class "font-xs text-red-600 mt-1" ] [ text model.message ]
            ]
        , div [ class "flex flex-col justify-start gap-2" ]
            [ button [ class "group physical primary", onClick Calculate ] [ span [ class "physical" ] [ text "Calculate" ] ]
            , span [ class "text-xs text-orange-700" ] [ b [] [ text "Note:" ], text " Please use a “.” for decimals instead of a “,”." ]
            ]
        , div [ class "flex flex-col justify-start" ]
            [ h2 [ class "font-semibold" ] [ text "Minimum intake for a canned diet:" ]
            , p [ class "mb-2" ] [ em [] [ text (R.round 2 model.cannedTaurine) ], text " mg of taurine per day" ]
            , h2 [ class "font-semibold" ] [ text "Minimum intake for a dry diet:" ]
            , p [] [ em [] [ text (R.round 2 model.dryTaurine) ], text " mg of taurine per day" ]
            ]
        ]



-- UPDATE


type Msg
    = UpdateWeight String
    | Calculate
    | Reset String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWeight weight ->
            ({ model | enteredWeight = weight }, Cmd.none)

        Calculate ->
            let
                maybeFloat =
                    String.toFloat model.enteredWeight
            in
            case maybeFloat of
                Just f ->
                    ({ model
                        | cannedTaurine = f * 39.0
                        , dryTaurine = f * 19.0
                        , message = ""
                    }, Cmd.none)

                Nothing ->
                    ({ model | message = unicodeToString 0x26A0 ++ " The entered value is not a number" }, Cmd.none)

        Reset _ ->
           init ()
