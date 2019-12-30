module ConsistentHashing.Replicas exposing
    ( Replicas
    , default
    , new
    )


type Replicas
    = Replicas Int


new : Int -> Replicas
new value =
    Replicas


default : Replicas
default =
    100
