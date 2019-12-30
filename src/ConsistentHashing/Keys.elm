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
    = Keys (List ( Node.Node, Key.Key ))


empty : Keys
empty =
    Keys []


append : List ( Node.Node, Key.Key ) -> Keys -> Keys
append keys (Keys currentKeys) =
    keys
        |> (++) currentKeys
        |> List.sortBy (Key.toString << Tuple.second)
        |> Keys


remove : Node.Node -> Keys -> Keys
remove targetNode (Keys keys) =
    Keys <| List.filter (\( node, _ ) -> not (Node.isEqual node targetNode)) keys


find : Key.Key -> Keys -> Maybe Node.Node
find targetKey (Keys keys) =
    keys
        |> ExList.find (\( _, key ) -> Key.isAssignable key targetKey)
        |> Maybe.map Tuple.first


default : Keys -> Maybe Node.Node
default (Keys keys) =
    keys
        |> List.head
        |> Maybe.map Tuple.first
