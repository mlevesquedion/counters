{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
   buttons. Use this as a starting point for using elm-mdl components in your own
   app.
-}


module Main exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (href, class, style, autofocus)
import Material
import Material.Scheme
import Material.Card as Card
import Material.Color as Color
import Material.Button as Button
import Material.Layout as Layout
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.Options as Options exposing (css)


-- MODEL


type alias Tab =
    { count : Int
    , label : String
    }


type alias Model =
    { currentTab : Int
    , tabs : List Tab
    , newLabel : String
    , mdl :
        Material.Model

    -- Boilerplate: model store for any and all Mdl components you use.
    }


model : Model
model =
    { currentTab = 0
    , tabs = []
    , newLabel = ""
    , mdl =
        Material.model

    -- Boilerplate: Always use this initial Mdl model store.
    }



-- ACTION, UPDATE


type Msg
    = Increment Int
    | Decrement Int
    | Reset Int
    | Delete Int
    | SelectTab Int
    | Mdl (Material.Msg Msg)
    | UpdateLabel String
    | NewTab



-- Boilerplate: Msg clause for internal Mdl messages.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment tabIndex ->
            ( { model | tabs = updateTabs model.tabs tabIndex ((+) 1) }
            , Cmd.none
            )

        Decrement tabIndex ->
            ( { model | tabs = updateTabs model.tabs tabIndex (max 0 << flip (-) 1) }
            , Cmd.none
            )

        Reset tabIndex ->
            ( { model | tabs = updateTabs model.tabs tabIndex (always 0) }
            , Cmd.none
            )

        Delete tabIndex ->
            ( { model
                | tabs =
                    let
                        tabsBefore =
                            List.take tabIndex model.tabs

                        tabsAfter =
                            List.drop tabIndex model.tabs
                    in
                        tabsBefore ++ List.drop 1 tabsAfter
              }
            , Cmd.none
            )

        SelectTab tabIndex ->
            ( { model | currentTab = tabIndex }, Cmd.none )

        NewTab ->
            ( { model | tabs = model.tabs ++ [ Tab 0 model.newLabel ], newLabel = "" }, Cmd.none )

        UpdateLabel newLabel ->
            ( { model | newLabel = newLabel }, Cmd.none )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model


updateTabs : List Tab -> Int -> (Int -> Int) -> List Tab
updateTabs tabs tabIndex func =
    List.indexedMap
        (\index tab ->
            if index == tabIndex then
                { tab | count = func tab.count }
            else
                tab
        )
        tabs



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        , Layout.fixedTabs
        , Layout.onSelectTab SelectTab
        , Layout.selectedTab model.currentTab
        ]
        { header = [ h1 [ style [ ( "padding", "2rem" ) ] ] [ text "Counters" ] ]
        , drawer = []
        , tabs =
            ( (List.map (.label >> text) model.tabs) ++ [ text "New counter" ]
            , [ Color.background (Color.color Color.Teal Color.S400) ]
            )
        , main = [ viewBody model ]
        }


viewBody : Model -> Html Msg
viewBody model =
    let
        tab =
            Array.fromList model.tabs |> Array.get model.currentTab
    in
        let
            rendering =
                case tab of
                    Just tab ->
                        Card.view []
                            [ Card.title [] [ Card.head [] [ text (tab.label ++ " : " ++ toString tab.count) ] ]
                            , Card.actions
                                []
                                [ Button.render Mdl
                                    [ 0, model.currentTab ]
                                    model.mdl
                                    [ Button.icon
                                    , Button.colored
                                    , Button.ripple
                                    , Options.onClick (Increment model.currentTab)
                                    ]
                                    [ Icon.i "add" ]
                                , Button.render Mdl
                                    [ 2, model.currentTab ]
                                    model.mdl
                                    [ Button.icon
                                    , Button.colored
                                    , Button.ripple
                                    , Options.onClick (Decrement model.currentTab)
                                    ]
                                    [ Icon.i "remove" ]
                                , Button.render Mdl
                                    [ 3, model.currentTab ]
                                    model.mdl
                                    [ Button.icon
                                    , Button.colored
                                    , Button.ripple
                                    , Options.onClick (Reset model.currentTab)
                                    ]
                                    [ Icon.i "exposure_zero" ]
                                , Button.render Mdl
                                    [ 4, model.currentTab ]
                                    model.mdl
                                    [ Button.icon
                                    , Button.colored
                                    , Options.onClick (Delete model.currentTab)
                                    ]
                                    [ Icon.i "delete" ]
                                ]
                            ]

                    Nothing ->
                        Card.view []
                            [ Card.title [] [ Card.head [] [ text "What do you want to count?" ] ]
                            , Card.actions
                                []
                                [ Textfield.render Mdl
                                    [ 2 ]
                                    model.mdl
                                    [ Textfield.floatingLabel
                                    , Textfield.label "I want to count..."
                                    , Textfield.value model.newLabel
                                    , Options.onInput
                                        UpdateLabel
                                    , Options.attribute (autofocus True)
                                    ]
                                    []
                                , Button.render Mdl
                                    [ 3 ]
                                    model.mdl
                                    [ Button.icon
                                    , Button.colored
                                    , Options.onClick NewTab
                                    ]
                                    [ Icon.i "add_circle" ]
                                ]
                            ]
        in
            rendering
                |> Material.Scheme.topWithScheme Color.Teal Color.LightGreen


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
