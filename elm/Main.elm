import Html exposing (Html, div, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src, style)
import List
import Css exposing (position, absolute, relative, margin, auto, marginTop, px,
  top, left, width, height, border3, solid)
import Css.Colors exposing (blue, purple)
import Time exposing (Time, millisecond)
import Debug exposing (log)

main = Html.program {
    init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
  }

type alias Board = { width: Int, height: Int }
type alias Pos = { col: Int, row: Int }
type alias Tour = { turn: Int, steps: List Pos }
type alias Model = { board: Board, tour: Maybe Tour }

init: (Model, Cmd Msg)
init = { board = { width = 8, height = 8 }, tour = Nothing } ! []

type Msg =
  FieldClicked Pos |
  Tick Time

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FieldClicked coords ->
      case model.tour of
        Nothing -> { model | tour = Just { turn = 0, steps = solve model.board coords }} ! []
        Just _ -> model ! []
    Tick time ->
      case model.tour of
        Nothing -> model ! []
        Just { turn, steps } ->
          let
            newTurn =
              if turn < (List.length steps) - 1 then turn + 1
              else turn
          in
            { model | tour = Just { turn = newTurn, steps = steps }} ! []

solve: Board -> Pos -> List Pos
solve board coords = get (solve2 board coords []) "No solution found!"

solve2: Board -> Pos -> List Pos -> Maybe (List Pos)
solve2 board coords steps =
  let newSteps = List.append steps [coords]
  in
    if (isFinal board newSteps) then Just newSteps
    else
      moves board coords steps
      |> List.sortWith (compareNumOfNextMoves board newSteps)
      |> first (\move -> solve2 board move newSteps)

first: (a -> Maybe b) -> List a -> Maybe b
first f list =
  case list of
    [] -> Nothing
    x::xs ->
      case (f x) of
        Just y -> Just y
        Nothing -> first f xs

compareNumOfNextMoves: Board -> List Pos -> Pos -> Pos -> Order
compareNumOfNextMoves board steps first second =
  let
    numFirstMoves = List.length (moves board first steps)
    numSecondMoves = List.length (moves board second steps)
  in
    compare numFirstMoves numSecondMoves

isFinal: Board -> List Pos -> Bool
isFinal board steps =
  (List.length steps) == size board

size: Board -> Int
size { width, height} = width * height

moves: Board -> Pos -> List Pos -> List Pos
moves board coords steps =
  List.filter (\move -> not (List.member move steps)) (validMoves board coords)

validMoves: Board -> Pos -> List (Pos)
validMoves board coords =
  let
    offsets = [
      { col = -2, row = -1},
      { col = -1, row = -2},
      { col =  1, row = -2},
      { col =  2, row = -1},
      { col =  2, row =  1},
      { col =  1, row =  2},
      { col = -1, row =  2},
      { col = -2, row =  1}
    ]
  in
    List.map (applyOffset coords) offsets
    |> List.filter (isValidPos board)

isValidPos: Board -> Pos -> Bool
isValidPos { width, height } { col, row } =
  col >= 0 && col < width && row >= 0 && row < height

applyOffset: Pos -> Pos -> Pos
applyOffset pos offset = { col = pos.col + offset.col, row = pos.row + offset.row }

subscriptions: Model -> Sub Msg
subscriptions model =
  case model.tour of
    Nothing -> Sub.none
    Just _ -> Time.every (500 * millisecond) Tick

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
fieldPosCss { col, row } = [
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
      viewFields model.board,
      maybeToFlatList (Maybe.map viewTour model.tour)
    ]

viewCanvas: List (Html Msg) -> Html Msg
viewCanvas contents =
  div [style (Css.asPairs (canvasCss))] contents

viewFields: Board -> List (Html Msg)
viewFields board =
  let rows = List.range 0 (board.height - 1)
      cols = List.range 0 (board.width - 1)
  in
    List.map viewField <| List.map toPos <| cart cols rows

toPos: (Int, Int) -> Pos
toPos (col, row) = { col = col, row = row }

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
fieldColor { col, row } =
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
