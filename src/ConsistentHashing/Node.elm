module ConsistentHashing.Node exposing
    ( Node
    , new, toString
    )

{-|

@docs Node

@docs new, toString

-}


{-| Distributable node
-}
type Node
    = Node String


{-| Creates a new Node
-}
new : String -> Node
new value =
    Node value


{-| Unwraps Node into String
-}
toString : Node -> String
toString (Node value) =
    value
