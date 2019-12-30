module ConsistentHashing.Keys exposing
    ( Keys
    , append
    , default
    , empty
    , find
    , remove
    )

import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node
import List.Extra as ExList


type Keys
    = Keys (List ( Node.RawId, Key.Key ))


empty : Keys
empty =
    Keys []


append : List ( Node.Node, Key.Key ) -> Keys -> Keys
append keys (Keys currentKeys) =
    keys
        |> List.map (Tuple.mapFirst Node.toRawString)
        |> (++) currentKeys
        |> List.sortBy (Key.toString << Tuple.second)
        |> Keys


remove : Node.Node -> Keys -> Keys
remove node (Keys keys) =
    Keys <| List.filter (\( nodeId, _ ) -> not (nodeId == Node.toRawString node)) keys


find : Key.Key -> Keys -> Maybe Node.RawId
find targetKey (Keys keys) =
    keys
        |> ExList.find (\( _, key ) -> Key.toString key >= Key.toString targetKey)
        |> Maybe.map Tuple.first


default : Keys -> Maybe Node.RawId
default (Keys keys) =
    keys
        |> List.head
        |> Maybe.map Tuple.first
