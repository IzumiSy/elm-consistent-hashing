module ConsistentHashing.Key exposing
    ( Key
    , isAssignable
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


isAssignable : Key -> Key -> Bool
isAssignable (Key a) (Key b) =
    a >= b
