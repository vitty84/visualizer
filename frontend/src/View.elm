module View exposing (..)

import Html exposing (Html, div, h4, h1, a, text, span, i)
import Html.Attributes exposing (id, class, href)
import RemoteData exposing (WebData)

import Models exposing (Model, Dashboard)
import Msgs exposing (Msg)

maybeList : WebData Dashboard -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            text "Loading..."
        RemoteData.Success dashboard ->
            div [ class "row" ]
                [ statusBlock "primary"   "Blacklisted" dashboard.blacklisted
                , statusBlock "secondary" "Marked"      dashboard.marked
                , statusBlock "tertiary"  "Whitelisted" dashboard.whitelisted ]
        RemoteData.Failure error ->
            text (toString error)

statusBlockSection : WebData Dashboard -> Html Msg
statusBlockSection dashboard =
    maybeList dashboard

statusBlock : String -> String -> String -> Html Msg
statusBlock color section count =
    div [ class "col-md-4 col-sm-6" ]
        [ a [ href "#", class ("dashboard-stat " ++ color) ]
          [ div [ class "details" ]
            [ span [ class "content" ] [ text (section ++ " Actors") ]
            ,   span [ class "value" ] [ text count ] ]
          , i [ class "fa fa-play-circle more" ] []
          ]
        ]

view : Model -> Html Msg
view model =
    div []
        [ div [ id "content-header" ]
            [ h1 [] [ text "Dashboard" ] ]
        , div [ id "content-container" ]
            [ div [] [ h4 [] [ text "Summary" ] ]
            , statusBlockSection model.dashboard
            ]
        ]
