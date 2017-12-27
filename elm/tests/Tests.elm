module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Main exposing (..)
import Set exposing (fromList)

suite : Test
suite =
  describe "Kniht's Tour"
  [ describe "size of a board"
      [ test "returns number of fields on the given board" <|
          \_ -> Expect.equal 64 (size { width = 8, height = 8 })
        ,
        test "returns number of fields on a given small board" <|
          \_ -> Expect.equal 12 (size { width = 4, height = 3 })
        ]
    ,
    describe "moves valid on a board from a position"
      [ test "there are two valid moves from top-left corner" <|
          \_ ->
            let board = { width = 8, height = 8 }
                pos = { col = 0, row = 0 }
                result = [
                    { col = 2, row = 1 },
                    { col = 1, row = 2 }
                  ]
            in
              Expect.equal result (validMoves board pos)
        ,
        test "there are two valid moves from bottom-right corner" <|
            \_ ->
              let board = { width = 8, height = 8 }
                  pos = { col = 7, row = 7 }
                  result = [
                      { col = 5, row = 6 },
                      { col = 6, row = 5 }
                    ]
              in
                Expect.equal result (validMoves board pos)
        ,
        test "there are eight valid moves from center" <|
            \_ ->
              let board = { width = 8, height = 8 }
                  pos = { col = 2, row = 2 }
                  result = [
                      { col = 0, row = 1 },
                      { col = 1, row = 0 },
                      { col = 3, row = 0 },
                      { col = 4, row = 1 },
                      { col = 4, row = 3 },
                      { col = 3, row = 4 },
                      { col = 1, row = 4 },
                      { col = 0, row = 3 }
                    ]
              in
                Expect.equal result (validMoves board pos)
          ,
          test "there are only four valid moves from center on a small board" <|
              \_ ->
                let board = { width = 4, height = 4 }
                    pos = { col = 2, row = 2 }
                    result = [
                        { col = 0, row = 1 },
                        { col = 1, row = 0 },
                        { col = 3, row = 0 },
                        { col = 0, row = 3 }
                      ]
                in
                  Expect.equal result (validMoves board pos)
        ]
      ,
    describe "moves valid on a board based on a partial tour"
      [ test "repeated moves are not allowed" <|
          \_ ->
            let board = { width = 8, height = 8 }
                tour = [
                  { col = 1, row = 0 },
                  { col = 0, row = 2 },
                  { col = 1, row = 4 }
                ]
                pos = { col = 2, row = 2 }
                result = [
                    { col = 0, row = 1 },
                    { col = 3, row = 0 },
                    { col = 4, row = 1 },
                    { col = 4, row = 3 },
                    { col = 3, row = 4 },
                    { col = 0, row = 3 }
                  ]
            in
              Expect.equal result (moves board pos tour)
          ]
  ]

equal : List comparable -> List comparable -> Expectation
equal first second =
  Expect.equalSets (Set.fromList first) (Set.fromList second)
