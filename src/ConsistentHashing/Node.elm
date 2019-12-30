module ConsistentHashing.Node exposing
    ( Node
    , isEqual
    , new
    , toRawString
    )


type Node
    = Node String


new : String -> Node
new value =
    Node value


toRawString : Node -> String
toRawString (Node value) =
    value


isEqual : Node -> Node -> Bool
isEqual (Node a) (Node b) =
    a == b
