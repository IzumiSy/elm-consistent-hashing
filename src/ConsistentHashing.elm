module ConsistentHashing exposing
    ( ConsistentHashing
    , new, add, remove
    , getNode
    )

{-| A pure Elm Consistent hashing module

@docs ConsistentHashing

@docs new, add, remove

@docs getNode

-}

import ConsistentHashing.Key as Key
import ConsistentHashing.Keys as Keys
import ConsistentHashing.Node as Node
import ConsistentHashing.Replica as Replica
import Dict


{-| A data structure for consistent hashing
-}
type ConsistentHashing
    = ConsistentHashing
        { replica : Replica.Replica
        , nodes : Dict.Dict String Node.Node
        , head : Node.Node
        , keys : Keys.Keys
        }


{-| Creates a new ConsistentHashing data

`new` function only takes one initial node at first. This interface is like non-empty list which aims to ensure one node always available at least for distribution.

If you want, you can add some more nodes one by one using `add` function.

-}
new : Replica.Replica -> Node.Node -> ConsistentHashing
new replica initialNode =
    ConsistentHashing
        { replica = replica
        , nodes = Dict.insert (Node.toString initialNode) initialNode Dict.empty
        , head = initialNode
        , keys =
            Keys.append
                (replica
                    |> Replica.toSuffixedKeyList initialNode
                    |> List.map (\key -> ( initialNode, key ))
                )
                Keys.empty
        }


{-| Adds a node
-}
add : Node.Node -> ConsistentHashing -> ConsistentHashing
add node ((ConsistentHashing { replica, nodes, keys, head }) as ch) =
    if Dict.member (Node.toString node) nodes then
        ch

    else
        let
            nextKeys =
                Keys.append
                    (replica
                        |> Replica.toSuffixedKeyList node
                        |> List.map (\key -> ( node, key ))
                    )
                    keys
        in
        ConsistentHashing
            { replica = replica
            , nodes = Dict.insert (Node.toString node) node nodes
            , keys = nextKeys
            , head =
                nextKeys
                    |> Keys.head
                    |> Maybe.withDefault head
            }


{-| Removes a node

This function actually does not remove all nodes. The node added with `new` function is irremovable.

-}
remove : Node.Node -> ConsistentHashing -> ConsistentHashing
remove node (ConsistentHashing { replica, nodes, keys, head }) =
    let
        nextKeys =
            Keys.remove node keys
    in
    ConsistentHashing
        { replica = replica
        , nodes = Dict.remove (Node.toString node) nodes
        , keys = nextKeys
        , head =
            nextKeys
                |> Keys.head
                |> Maybe.withDefault head
        }


{-| Gets one node by key
-}
getNode : Key.Key -> ConsistentHashing -> Node.Node
getNode newKey (ConsistentHashing { nodes, keys, head }) =
    keys
        |> Keys.find newKey
        |> Maybe.andThen (\node -> Dict.get (Node.toString node) nodes)
        |> Maybe.withDefault head
