module ConsistentHashing exposing
    ( ConsistentHashing
    , add
    , delete
    , getNode
    , new
    )

import ConsistentHashing.Key as Key
import ConsistentHashing.Keys as Keys
import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Dict


type ConsistentHashing
    = ConsistentHashing
        { replicas : Replicas.Replicas
        , nodes : Dict.Dict Node.RawId Node.Node
        , keys : Keys.Keys
        }


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


add : Node.Node -> ConsistentHashing -> ConsistentHashing
add node ((ConsistentHashing { replicas, nodes, keys }) as ch) =
    if Dict.member (Node.toRawString node) nodes then
        ch

    else
        let
            nodeKeys =
                replicas
                    |> Replicas.toSuffixedList node
                    |> List.map (\rep -> ( node, Key.new rep ))
        in
        ConsistentHashing
            { replicas = replicas
            , nodes = Dict.insert (Node.toRawString node) node nodes
            , keys = Keys.append nodeKeys keys
            }


delete : Node.Node -> ConsistentHashing -> ConsistentHashing
delete node ch =
    ch


getNode : Key.Key -> ConsistentHashing -> Maybe Node.Node
getNode newKey (ConsistentHashing { nodes, keys }) =
    keys
        |> Keys.find newKey
        |> Maybe.andThen
            (\nodeId ->
                case Dict.get nodeId nodes of
                    Just node ->
                        Just node

                    Nothing ->
                        keys
                            |> Keys.default
                            |> Maybe.andThen (\headingNodeId -> Dict.get headingNodeId nodes)
            )
