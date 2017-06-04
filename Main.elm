import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src, style)
import List exposing (map, concatMap, range)
import Css exposing (position, absolute, relative, margin, auto, marginTop, px,
  top, left, width, height)

main: Html msg
main = view

-- ----------------------------------------------------------------------------
-- View
-- ----------------------------------------------------------------------------

boardCss: List Css.Mixin
boardCss = [
    position relative,
    margin auto,
    marginTop (px 50),
    width (px 424),
    height (px 424)
  ]

fieldCss: (Int, Int) -> List Css.Mixin
fieldCss (row, col) = [
    position absolute,
    top (px <| toFloat (row * 53)),
    left (px <| toFloat (col * 53))
  ]

view: Html msg
view =
  div [style (Css.asPairs boardCss)] viewFields

viewFields: List (Html msg)
viewFields =
  let rows = range 0 7
      cols = range 0 7
  in
    map viewField <| cart rows cols

viewField: (Int,  Int) -> Html msg
viewField (row, col) =
  img [
      style (Css.asPairs (fieldCss (row, col))), src (fieldImg (row, col))] []

fieldImg: (Int, Int) -> String
fieldImg coords =
  (fieldColor coords) ++ "-field.png"

fieldColor: (Int, Int) -> String
fieldColor (row, col) =
  if (row + col) % 2 == 0 then
    "black"
  else
    "white"

-- ----------------------------------------------------------------------------
-- Utils
-- ----------------------------------------------------------------------------

cart: List a -> List b -> List (a, b)
cart xs ys =
  concatMap (\x -> map (\y -> (x, y)) ys) xs
