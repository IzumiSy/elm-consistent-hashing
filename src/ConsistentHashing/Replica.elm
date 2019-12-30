module ConsistentHashing.Replica exposing
    ( Replica
    , new, default
    , toInt, toSuffixedKeyList
    )

{-|

@docs Replica

@docs new, default

@docs toInt, toSuffixedKeyList

-}

import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node


{-| Replica size
-}
type Replica
    = Replica Int


{-| Creates a new replica size
-}
new : Int -> Replica
new =
    Replica


{-| A default replica size
-}
default : Replica
default =
    Replica 100


{-| Unwraps Replica to Int
-}
toInt : Replica -> Int
toInt (Replica value) =
    value


{-| Builds Key list with range of Replica size, serially suffxied
-}
toSuffixedKeyList : Node.Node -> Replica -> List Key.Key
toSuffixedKeyList node (Replica value) =
    value
        |> List.range 0
        |> List.map String.fromInt
        |> List.map (\repNum -> Key.new <| String.concat [ Node.toString node, "_", repNum ])
