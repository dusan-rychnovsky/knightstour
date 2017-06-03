import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src, style)
import List exposing (map, repeat, range)

main: Html msg
main =
  div [style [("position", "relative"), ("margin", "0px auto"), ("margin-top", "50px"), ("width", "424px"), ("height", "424px")]] viewFields

viewFields: List (Html msg)
viewFields =
  let rows = List.range 0 7
      cols = List.range 0 7
  in
    List.map viewField <| cart rows cols

viewField: (Int,  Int) -> Html msg
viewField (row, col) =
  img [style [("position", "absolute"), ("top", toString (row * 53) ++ "px"), ("left", toString (col * 53) ++ "px")], src (fieldImg (row, col))] []

fieldImg: (Int, Int) -> String
fieldImg (row, col) =
  if (row + col) % 2 == 0 then
    "black-field.png"
  else
    "white-field.png"

cart: List a -> List b -> List (a, b)
cart xs ys =
  List.concatMap (\x -> List.map (\y -> (x, y)) ys) xs
