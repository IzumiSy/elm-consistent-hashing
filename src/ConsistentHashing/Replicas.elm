module ConsistentHashing.Replicas exposing
    ( Replicas
    , default
    , new
    )


type Replicas
    = Replicas Int


new : Int -> Replicas
new =
    Replicas


default : Replicas
default =
    Replicas 100
