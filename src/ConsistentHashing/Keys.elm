module ConsistentHashing.Keys exposing
    ( Keys
    , append
    , empty
    , find
    , head
    , remove
    )

import Array
import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node


{-| The reason why Keys has Array as an internal data structure is, `find` method of this module internally uses Binary Search algorithm.
It requires the collection to have performance in accessing by its index, where exactly Array in Elm offers.
-}
type Keys
    = Keys (Array.Array ( Node.Node, Key.Key ))


empty : Keys
empty =
    Keys Array.empty


{-| Internal data structure of Keys is Array, but as an interface, List might be more generic, handy to use.
Plus, `append` is less likely to be called by users, so here probably won't be any performance issue.
-}
append : List ( Node.Node, Key.Key ) -> Keys -> Keys
append keys (Keys currentKeys) =
    keys
        |> (++) (Array.toList currentKeys)
        |> List.sortBy (Key.toString << Tuple.second)
        |> Array.fromList
        |> Keys


remove : Node.Node -> Keys -> Keys
remove targetNode (Keys keys) =
    Keys <| Array.filter (\( node, _ ) -> not (Node.toString node == Node.toString targetNode)) keys


{-| Looks up all node keys by Binary Search
-}
find : Key.Key -> Keys -> Maybe Node.Node
find targetKey ((Keys keys_) as keys) =
    findInternal 0 (Array.length keys_) Nothing targetKey keys


head : Keys -> Maybe Node.Node
head (Keys keys) =
    keys
        |> Array.get 0
        |> Maybe.map Tuple.first


{-| Looks up the nearest key by recursive Binary Search
This is way better in performance using linear search with List in case of many keys.
-}
findInternal : Int -> Int -> Maybe Node.Node -> Key.Key -> Keys -> Maybe Node.Node
findInternal beginIndex endIndex currentNode key (Keys keys) =
    if beginIndex > endIndex then
        currentNode

    else
        let
            median =
                beginIndex + (endIndex - beginIndex) // 2
        in
        keys
            |> Array.get median
            |> Maybe.andThen
                (\( medianNode, medianKey ) ->
                    if Key.toString medianKey < Key.toString key then
                        findInternal (median + 1) endIndex (Just medianNode) key (Keys keys)

                    else
                        findInternal beginIndex (median - 1) (Just medianNode) key (Keys keys)
                )
