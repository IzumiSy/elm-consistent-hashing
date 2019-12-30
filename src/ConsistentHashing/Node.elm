module ConsistentHashing.Node exposing
    ( Node
    , RawId
    , new
    , toHashedString
    , toRawString
    )

import ConsistentHashing.Key as Key


type alias RawId =
    String


type Node
    = Node RawId Key.Key


new : String -> Node
new value =
    Node value (Key.new value)


toHashedString : Node -> Key.Key
toHashedString (Node _ value) =
    value


toRawString : Node -> String
toRawString (Node value _) =
    value
