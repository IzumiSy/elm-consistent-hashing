module ConsistentHashing exposing
    ( ConsistentHashing
    , new
    )

import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Dict
import Set


type ConsistentHashing
    = ConsistentHashing
        { nodes : Dict.Dict String Node.Node
        , replicas : Replicas.Replicas
        }


new : Replicas -> List Node.Node -> ConsistentHashing
new replicas nodes =
    let
        nodeSet =
            nodes
                |> List.map Node.toString
                |> Set.fromList nodes
                |> Set.toList
    in
    ConsistentHashing
        { nodes = Dict.empty
        , replicas = replicas
        }
