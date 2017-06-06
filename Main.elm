import Html exposing (Html, div, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, style)
import List
import Css exposing (position, absolute, relative, margin, auto, marginTop, px,
  top, left, width, height, border3, solid)
import Css.Colors exposing (blue, purple)
import Debug exposing (log)

main = Html.beginnerProgram { model = model, update = update, view = view }

type alias Pos = (Int, Int)
type alias Model = Maybe Pos

model: Model
model = Nothing

type Msg = FieldClicked Pos

update: Msg -> Model -> Model
update msg model =
  case msg of
    FieldClicked coords ->
      let _= Debug.log "valid moves" (validMoves coords)
      in
      case model of
        Nothing -> Just coords
        Just _ -> model

validMoves: Pos -> List (Pos)
validMoves coords =
  let
    offsets = [
      (-1, -2), (-2, -1), (-2, 1), (-1, 2), (1, 2), (2, 1), (2, -1), (1, -2)
    ]
  in
    List.map (addTuples coords) offsets
    |> List.filter isValidPos

isValidPos: Pos -> Bool
isValidPos (x, y) =
  x >= 0 && x < 8 && y >= 0 && y < 8

addTuples: (Int, Int) -> (Int, Int) -> (Int, Int)
addTuples (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- ----------------------------------------------------------------------------
-- View
-- ----------------------------------------------------------------------------

canvasCss: List Css.Mixin
canvasCss = [
    position relative,
    margin auto,
    marginTop (px 50),
    width (px 424),
    height (px 424)
  ]

fieldPosCss: Pos -> List Css.Mixin
fieldPosCss (row, col) = [
    position absolute,
    top (px <| toFloat (row * 53)),
    left (px <| toFloat (col * 53))
  ]

initFieldMarkCss: List Css.Mixin
initFieldMarkCss = [
    border3 (px 2) solid blue,
    width (px 49),
    height (px 49)
  ]

intermFieldMarkCss: List Css.Mixin
intermFieldMarkCss = [
    border3 (px 2) solid purple,
    width (px 49),
    height (px 49)
  ]

view: Model -> Html Msg
view model =
  viewCanvas <|
    List.concat [
      viewFields,
      maybeToList (Maybe.map viewInitFieldMark model)
    ]

viewCanvas: List (Html Msg) -> Html Msg
viewCanvas contents =
  div [style (Css.asPairs (canvasCss))] contents

viewFields: List (Html Msg)
viewFields =
  let rows = List.range 0 7
      cols = List.range 0 7
  in
    List.map viewField <| cart rows cols

viewField: Pos -> Html Msg
viewField coords =
  img [
    style (Css.asPairs (fieldPosCss coords)),
    src (fieldImgSrc coords),
    onClick (FieldClicked coords)
  ] []

fieldImgSrc: Pos -> String
fieldImgSrc coords =
  (fieldColor coords) ++ "-field.png"

fieldColor: Pos -> String
fieldColor (row, col) =
  if (row + col) % 2 == 0 then
    "black"
  else
    "white"

viewKnight: Pos -> Html Msg
viewKnight coords =
  img [
    style (Css.asPairs (fieldPosCss coords)),
    src ("knight.png")
  ] []

viewInitFieldMark: Pos -> Html Msg
viewInitFieldMark coords =
  div [
    style (Css.asPairs <| List.concat [fieldPosCss coords, initFieldMarkCss])
  ] []

-- ----------------------------------------------------------------------------
-- Utils
-- ----------------------------------------------------------------------------

cart: List a -> List b -> List (a, b)
cart xs ys =
  List.concatMap (\x -> List.map (\y -> (x, y)) ys) xs

maybeToList: Maybe a -> List a
maybeToList m =
  case m of
    Just x -> [x]
    Nothing -> []
