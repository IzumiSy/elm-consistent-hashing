module ConsistentHashing.Replicas exposing
    ( Replicas
    , default
    , new
    , toInt
    , toSuffixedKeyList
    )

import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node


type Replicas
    = Replicas Int


new : Int -> Replicas
new =
    Replicas


default : Replicas
default =
    Replicas 100


toInt : Replicas -> Int
toInt (Replicas value) =
    value


toSuffixedKeyList : Node.Node -> Replicas -> List Key.Key
toSuffixedKeyList node (Replicas value) =
    value
        |> List.range 0
        |> List.map String.fromInt
        |> List.map (\repNum -> Key.new <| String.concat [ Node.toRawString node, "_", repNum ])
