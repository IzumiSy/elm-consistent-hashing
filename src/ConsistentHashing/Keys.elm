module ConsistentHashing.Keys exposing
    ( Keys
    , append
    , empty
    , find
    , head
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
    Keys <| ExList.filterNot (\( node, _ ) -> Node.toString node == Node.toString targetNode) keys


find : Key.Key -> Keys -> Maybe Node.Node
find targetKey (Keys keys) =
    keys
        |> ExList.find (\( _, key ) -> isAssignable key targetKey)
        |> Maybe.map Tuple.first


head : Keys -> Maybe Node.Node
head (Keys keys) =
    keys
        |> List.head
        |> Maybe.map Tuple.first


isAssignable : Key.Key -> Key.Key -> Bool
isAssignable a b =
    Key.toString a >= Key.toString b
