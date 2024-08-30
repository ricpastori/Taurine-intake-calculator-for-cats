module App exposing (..)

import Browser
import Char exposing (Char)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Round as R exposing (round)



-- CUSTOM FUNCTIONS


unicodeToString : Int -> String
unicodeToString codePoint =
    codePoint
        |> Char.fromCode
        |> String.fromChar



-- MODEL


type alias Model =
    { enteredWeight : String
    , cannedTaurine : Float
    , dryTaurine : Float
    , message : String
    }


initModel : Model
initModel =
    { enteredWeight = ""
    , cannedTaurine = 0.0
    , dryTaurine = 0.0
    , message = ""
    }



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "flex flex-col justify-start gap-6" ]
        [ h1 [ class "text-2xl font-bold" ] [ text "Taurine intake calculator" ]
        , p [] [ text "This calculator is designed for healthy adult cats and provides an approximate estimate of their daily taurine requirement." ]
        , div [ class "flex flex-col justify-start gap-1" ]
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
        , p [ class "text-sm"] [b [] [text "Source: "],a [ href "https://www.cambridge.org/core/services/aop-cambridge-core/content/view/BA66B9E895186245E2B050CC8F3ED14C/S0007114591000843a.pdf/effect_of_dietary_taurine_content_on_the_plasma_taurine_concentration_of_the_cat.pdf",target "_blank", rel "noopener", class "underline text-orange-500 hover:text-orange-600"] [ text "Earle, K. E., & Smith, P. M. (1991). The effect of dietary taurine content on the plasma taurine concentration of the cat. British Journal of Nutrition, 66(2), 227-235." ]]
        , p [] [ b [] [ text "N.B." ], text "These results are only for guidance. It's always a good idea to check with a trusted veterinarian to make sure your cat is happy and healthy." ]
        , button [ class "group physical secondary", onClick Reset ] [ span [ class "physical" ] [ text "Reset" ] ]
        ]



-- UPDATE


type Msg
    = UpdateWeight String
    | Calculate
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateWeight weight ->
            { model | enteredWeight = weight }

        Calculate ->
            let
                maybeFloat =
                    String.toFloat model.enteredWeight
            in
            case maybeFloat of
                Just f ->
                    { model
                        | cannedTaurine = f * 39.0
                        , dryTaurine = f * 19.0
                        , message = ""
                    }

                Nothing ->
                    { model | message = unicodeToString 0x26A0 ++ " The entered value is not a number" }

        Reset ->
            initModel
