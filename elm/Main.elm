import Html exposing (Html, div, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, style)
import List
import Css exposing (position, absolute, relative, margin, auto, marginTop, px,
  top, left, width, height, border3, solid)
import Css.Colors exposing (blue, purple)
import Time exposing (Time, second)
import Debug exposing (log)

main = Html.program {
    init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
  }

type alias Pos = (Int, Int)
type alias Tour = { turn: Int, steps: List Pos }
type alias Model = Maybe Tour

init: (Model, Cmd Msg)
init = Nothing ! []

type Msg =
  FieldClicked Pos |
  Tick Time

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FieldClicked coords ->
      case model of
        Nothing -> Just { turn = 0, steps = solve coords } ! []
        Just _ -> model ! []
    Tick time ->
      case model of
        Nothing -> model ! []
        Just { turn, steps } ->
          let
            newTurn =
              if turn < (List.length steps) - 1 then turn + 1
              else turn
          in
            Just { turn = newTurn, steps = steps } ! []

solve: Pos -> List Pos
solve coords = get (solve2 coords []) "No solution found!"

solve2: Pos -> List Pos -> Maybe (List Pos)
solve2 coords steps =
  if (isFinal steps) then Just steps
  else
    let newSteps = List.append steps [coords]
    in
      moves coords steps
      |> List.sortWith (compareNumOfNextMoves newSteps)
      |> first (\move -> solve2 move newSteps)

first: (a -> Maybe b) -> List a -> Maybe b
first f list =
  case list of
    [] -> Nothing
    x::xs ->
      case (f x) of
        Just y -> Just y
        Nothing -> first f xs

compareNumOfNextMoves: List Pos -> Pos -> Pos -> Order
compareNumOfNextMoves steps first second =
  let
    numFirstMoves = List.length (moves first steps)
    numSecondMoves = List.length (moves second steps)
  in
    compare numFirstMoves numSecondMoves

isFinal: List Pos -> Bool
isFinal steps =
  (List.length steps) == 64

moves: Pos -> List Pos -> List Pos
moves coords steps =
  List.filter (\move -> not (List.member move steps)) (validMoves coords)

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

subscriptions: Model -> Sub Msg
subscriptions model =
  case model of
    Nothing -> Sub.none
    Just _ -> Time.every second Tick

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
      maybeToFlatList (Maybe.map viewTour model)
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

viewTour: Tour -> List (Html Msg)
viewTour tour = viewSteps (List.take (tour.turn + 1) tour.steps)

viewSteps: List Pos -> List (Html Msg)
viewSteps steps =
  maybeToList (Maybe.map viewInitFieldMark (List.head steps)) ++
  viewIntermFieldMarks (List.drop 1 steps) ++
  maybeToList (Maybe.map viewKnight (last steps))

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

viewIntermFieldMarks: List Pos -> List (Html Msg)
viewIntermFieldMarks steps =
  List.map viewIntermFieldMark steps

viewIntermFieldMark: Pos -> Html Msg
viewIntermFieldMark coords =
  div [
    style (Css.asPairs <| List.concat [fieldPosCss coords, intermFieldMarkCss])
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

maybeToFlatList: Maybe (List a) -> List a
maybeToFlatList m =
  case m of
    Just x -> x
    Nothing -> []

last : List a -> Maybe a
last = List.foldl (\x acc -> Just x) Nothing

find: (a -> Bool) -> List a -> Maybe a
find p list =
  case list of
    [] -> Nothing
    x::xs ->
      if p x then Just x
      else find p xs

get: Maybe a -> String -> a
get m err =
  case m of
    Nothing -> Debug.crash err
    Just x -> x
