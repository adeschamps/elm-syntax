module Elm.Parser.Infix exposing (infixDefinition)

import Combine exposing ((*>), (<$), (<*>), Parser, choice, or, string, succeed)
import Combine.Num exposing (int)
import Elm.Parser.State exposing (State)
import Elm.Parser.Tokens exposing (prefixOperatorToken)
import Elm.Parser.Util exposing (moreThanIndentWhitespace)
import Elm.Syntax.Infix exposing (Infix, InfixDirection(Left, Right))


infixDefinition : Parser State Infix
infixDefinition =
    succeed Infix
        <*> infixDirection
        <*> (moreThanIndentWhitespace *> int)
        <*> (moreThanIndentWhitespace *> prefixOperatorToken)


infixDirection : Parser State InfixDirection
infixDirection =
    choice
        [ Right <$ string "infixr"
        , Left <$ or (string "infixl") (string "infix")
        ]
