module ConsistentHashing.Key exposing
    ( Key
    , new
    , toString
    )

import MD5


type Key
    = Key String


new : String -> Key
new =
    Key << MD5.hex


toString : Key -> String
toString (Key value) =
    value
