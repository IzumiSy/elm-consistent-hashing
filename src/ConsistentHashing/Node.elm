module ConsistentHashing.Node exposing
    ( Node
    , RawId
    , new
    , toHashedString
    , toRawString
    )

import MD5


type alias HashedId =
    String


type alias RawId =
    String


type Node
    = Node RawId HashedId


new : String -> Node
new value =
    Node value (MD5.hex value)


toHashedString : Node -> String
toHashedString (Node _ value) =
    value


toRawString : Node -> String
toRawString (Node value _) =
    value
