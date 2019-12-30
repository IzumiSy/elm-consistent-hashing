module ConsistentHashing exposing
    ( ConsistentHashing
    , add
    , delete
    , new
    )

import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Dict
import MD5


type alias NodeId =
    String


type ConsistentHashing
    = ConsistentHashing
        { replicas : Replicas.Replicas
        , nodes : Dict.Dict NodeId Node.Node
        , keys : Dict.Dict NodeId String
        }


new : Replicas.Replicas -> List Node.Node -> ConsistentHashing
new replicas =
    List.foldl
        add
        (ConsistentHashing
            { replicas = replicas
            , nodes = Dict.empty
            , keys = Dict.empty
            }
        )


add : Node.Node -> ConsistentHashing -> ConsistentHashing
add node ((ConsistentHashing { replicas, nodes, keys }) as ch) =
    if Dict.member (Node.toString node) nodes then
        ch

    else
        let
            nodeId =
                MD5.hex <| Node.toString node

            nodeKeys =
                replicas
                    |> Replicas.toSuffixedList node
                    |> List.map (\rep -> ( nodeId, MD5.hex rep ))
                    |> Dict.fromList
        in
        ConsistentHashing
            { replicas = replicas
            , nodes = Dict.insert nodeId node nodes
            , keys = Dict.union nodeKeys keys
            }


delete : Node.Node -> ConsistentHashing -> ConsistentHashing
delete node ch =
    ch
