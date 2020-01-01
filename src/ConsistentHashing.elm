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
        , keys : Keys.Keys
        }


{-| Creates a new ConsistentHashing data

`new` function only takes one initial node at first. This interface is like non-empty list which aims to ensure one node always available at least for distribution.

If you want, you can add some more nodes one by one using `add` function.

-}
new : Replica.Replica -> Node.Node -> ConsistentHashing
new replica initialNode =
    add
        initialNode
        (ConsistentHashing
            { replica = replica
            , nodes = Dict.empty
            , keys = Keys.empty
            }
        )


{-| Adds a node
-}
add : Node.Node -> ConsistentHashing -> ConsistentHashing
add node ((ConsistentHashing { replica, nodes, keys }) as ch) =
    if Dict.member (Node.toString node) nodes then
        ch

    else
        ConsistentHashing
            { replica = replica
            , nodes = Dict.insert (Node.toString node) node nodes
            , keys =
                Keys.append
                    (replica
                        |> Replica.toSuffixedKeyList node
                        |> List.map (\key -> ( node, key ))
                    )
                    keys
            }


{-| Removes a node
-}
remove : Node.Node -> ConsistentHashing -> ConsistentHashing
remove node (ConsistentHashing { replica, nodes, keys }) =
    ConsistentHashing
        { replica = replica
        , nodes = Dict.remove (Node.toString node) nodes
        , keys = Keys.remove node keys
        }


{-| Gets one node by key
-}
getNode : Key.Key -> ConsistentHashing -> Maybe Node.Node
getNode newKey (ConsistentHashing { nodes, keys }) =
    keys
        |> Keys.find newKey
        |> Maybe.andThen
            (\node ->
                case Dict.get (Node.toString node) nodes of
                    Just foundNode ->
                        Just foundNode

                    Nothing ->
                        keys
                            |> Keys.default
                            |> Maybe.andThen (\headingNode -> Dict.get (Node.toString headingNode) nodes)
            )
