module ConsistentHashing exposing
    ( ConsistentHashing
    , new
    )

import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Dict


type ConsistentHashing
    = ConsistentHashing
        { replicas : Replicas.Replicas
        , nodes : Dict.Dict String Node.Node
        }


new : Replicas.Replicas -> List Node.Node -> ConsistentHashing
new replicas nodes =
    ConsistentHashing
        { replicas = replicas
        , nodes =
            nodes
                |> List.map (\node -> ( Node.toString node, node ))
                |> Dict.fromList
        }
