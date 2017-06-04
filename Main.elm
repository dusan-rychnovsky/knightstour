import Html exposing (Html, div, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, style)
import List
import Css exposing (position, absolute, relative, margin, auto, marginTop, px,
  top, left, width, height)
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
      Just coords

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

view: Model -> Html Msg
view model =
  viewCanvas <|
    List.concat [
      viewFields,
      maybeToList (Maybe.map viewKnight model)
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
viewKnight (row, col) =
  img [
    style (Css.asPairs (fieldPosCss (row, col))),
    src ("knight.png")
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
