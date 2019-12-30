module ConsistentHashing.Key exposing
    ( Key
    , new, toString
    )

{-|

@docs Key

@docs new, toString

-}

import MD5


{-| A string formed, hashed key to identify distributable nodes
-}
type Key
    = Key String


{-| Creates a new Key
-}
new : String -> Key
new =
    Key << MD5.hex


{-| Unwraps Key to String
-}
toString : Key -> String
toString (Key value) =
    value
