module ConsistentHashing exposing
    ( ConsistentHashing
    , new, add
    , getNode
    , remove
    )

{-| Consistent hashing module for Elm

@docs ConsistentHashing

@docs new, add, remote

@docs getNode

-}

import ConsistentHashing.Key as Key
import ConsistentHashing.Keys as Keys
import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Dict


type ConsistentHashing
    = ConsistentHashing
        { replicas : Replicas.Replicas
        , nodes : Dict.Dict String Node.Node
        , keys : Keys.Keys
        }


{-| Creates a new ConsistentHashing data
-}
new : Replicas.Replicas -> List Node.Node -> ConsistentHashing
new replicas =
    List.foldl
        add
        (ConsistentHashing
            { replicas = replicas
            , nodes = Dict.empty
            , keys = Keys.empty
            }
        )


{-| Adds a node
-}
add : Node.Node -> ConsistentHashing -> ConsistentHashing
add node ((ConsistentHashing { replicas, nodes, keys }) as ch) =
    if Dict.member (Node.toRawString node) nodes then
        ch

    else
        ConsistentHashing
            { replicas = replicas
            , nodes = Dict.insert (Node.toRawString node) node nodes
            , keys =
                Keys.append
                    (replicas
                        |> Replicas.toSuffixedKeyList node
                        |> List.map (\key -> ( node, key ))
                    )
                    keys
            }


{-| Removes a node
-}
remove : Node.Node -> ConsistentHashing -> ConsistentHashing
remove node (ConsistentHashing { replicas, nodes, keys }) =
    ConsistentHashing
        { replicas = replicas
        , nodes = Dict.remove (Node.toRawString node) nodes
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
                case Dict.get (Node.toRawString node) nodes of
                    Just foundNode ->
                        Just foundNode

                    Nothing ->
                        keys
                            |> Keys.default
                            |> Maybe.andThen (\headingNode -> Dict.get (Node.toRawString headingNode) nodes)
            )
