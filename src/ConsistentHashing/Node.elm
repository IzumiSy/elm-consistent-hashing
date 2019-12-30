module ConsistentHashing.Node exposing
    ( Node
    , new
    , toString
    )


type Node
    = Node String


new : String -> Node
new =
    Node


toString : Node -> String
toString (Node value) =
    value
