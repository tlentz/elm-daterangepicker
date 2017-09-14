module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import AdjustableTable exposing (..)
import DateRangePicker exposing (..)

-- APP
-- main : Program Never Int Msg
-- main =
--   Html.beginnerProgram { model = model, view = view, update = update }
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map AdjustableTableMsg <| AdjustableTable.subscriptions model.adjustableTable
    ]

init : (Model, Cmd Msg)
init =
  let
    tableData =
      [ ["1", "2", "3", "4", "5", "6"]
      , ["7", "8", "9", "10", "11", "12"]
      , ["13", "14", "15", "16", "17" , "18"]
      ]
    adjustableTable 
      = AdjustableTable.init
        |> setSettings { resizeColumns = True, reorderColumns = True }
        |> setTableHeadersFromStrings defaultHeaderSettings ["Red", "Blue", "Yellow", "Green", "Pink", "Purple"]
        |> setTableRows (List.map(\d -> getTableRowFromStrings d) tableData)
      
    datePicker 
      = DateRangePicker.init

    model =
      { adjustableTable = adjustableTable
      , datePicker = datePicker
      }
  in
      (model, Cmd.none)

-- MODEL
type alias Model = 
  { adjustableTable : AdjustableTable
  , datePicker : DateRangePicker
  }

model : number
model = 0


-- UPDATE
type Msg 
  = AdjustableTableMsg AdjustableTable.Msg
  | DateRangePickerMsg DateRangePicker.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AdjustableTableMsg msg ->
            let
                ( updatedModelAdjustableTable, cmd ) =
                    AdjustableTable.update model.adjustableTable msg
            in
                ( { model | adjustableTable = updatedModelAdjustableTable }, Cmd.map AdjustableTableMsg cmd )
        DateRangePickerMsg msg ->
            let
                ( updatedModelDateRangePicker, cmd ) =
                    DateRangePicker.update model.datePicker msg
            in
                ( { model | datePicker = updatedModelDateRangePicker }, Cmd.map DateRangePickerMsg cmd )

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div []
    [ Html.map AdjustableTableMsg <| AdjustableTable.view model.adjustableTable
    ]
