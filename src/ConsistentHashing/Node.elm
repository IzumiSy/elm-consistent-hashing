module ConsistentHashing.Node exposing
    ( Node
    , new, toString
    )

{-|

@docs Node

@docs new, toString

-}


type Node
    = Node String


new : String -> Node
new value =
    Node value


toString : Node -> String
toString (Node value) =
    value
