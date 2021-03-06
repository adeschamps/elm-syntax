module Elm.Parser.CommentTest exposing (..)

import Elm.Parser.CombineTestUtil exposing (..)
import Elm.Parser.Comments as Parser
import Elm.Parser.State as State exposing (emptyState)
import Expect
import Test exposing (..)


all : Test
all =
    describe "CommentTests"
        [ test "singleLineComment" <|
            \() ->
                parseStateToMaybe emptyState "--bar" Parser.singleLineComment
                    |> Maybe.map Tuple.first
                    |> Expect.equal (Just ())
        , test "singleLineComment state" <|
            \() ->
                parseStateToMaybe emptyState "--bar" Parser.singleLineComment
                    |> Maybe.map (Tuple.second >> State.getComments)
                    |> Expect.equal (Just [ ( { start = { row = 0, column = 0 }, end = { row = 0, column = 5 } }, "--bar" ) ])
        , test "singleLineComment does not include new line" <|
            \() ->
                parseFullStringWithNullState "--bar\n" Parser.singleLineComment
                    |> Expect.equal Nothing
        , test "multilineComment parse result" <|
            \() ->
                parseStateToMaybe emptyState "{-foo\nbar-}" Parser.multilineComment
                    |> Maybe.map Tuple.first
                    |> Expect.equal (Just ())
        , test "multilineComment range" <|
            \() ->
                parseStateToMaybe emptyState "{-foo\nbar-}" Parser.multilineComment
                    |> Maybe.map (Tuple.second >> State.getComments)
                    |> Expect.equal (Just [ ( { start = { row = 0, column = 0 }, end = { row = 1, column = 5 } }, "{-foo\nbar-}" ) ])
        , test "nested multilineComment only open" <|
            \() ->
                parseFullStringWithNullState "{- {- -}" Parser.multilineComment
                    |> Expect.equal Nothing
        , test "nested multilineComment open and close" <|
            \() ->
                parseFullStringWithNullState "{- {- -} -}" Parser.multilineComment
                    |> Expect.equal (Just ())
        ]
