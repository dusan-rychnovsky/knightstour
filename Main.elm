import Html exposing (Html, div, img, text)
import Html.Attributes exposing (src, style)

main: Html msg
main =
  div [style [("position", "relative"), ("margin", "50px 0px 0px 50px")]] [
    img [src "empty-board.png"] [],
    div [style [("border", "2px blue solid"), ("width", "49px"), ("height", "49px"), ("position", "absolute"), ("left", "106px"), ("top", "106px")]] [],
    img [src "knight.png", style [("position", "absolute"), ("left", "106px"), ("top", "106px")]] [],
    div [style [("border", "2px purple solid"), ("width", "49px"), ("height", "49px"), ("position", "absolute"), ("left", "265px"), ("top", "212px")]] [],
    div [style [("text-align", "center"), ("font-size", "46px"), ("width", "53px"), ("height", "53px"), ("position", "absolute"), ("left", "265px"), ("top", "212px")]] [text "1"],
    div [style [("border", "2px purple solid"), ("width", "49px"), ("height", "49px"), ("position", "absolute"), ("left", "318px"), ("top", "318px")]] [],
    div [style [("text-align", "center"), ("font-size", "46px"), ("width", "53px"), ("height", "53px"), ("position", "absolute"), ("left", "318px"), ("top", "318px")]] [text "2"]
  ]
