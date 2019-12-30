# elm-consistent-hashing
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-consistent-hashing.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-consistent-hashing)
> A pure Elm consistent hashing module

## Example
```elm
import ConsistentHashing as (ConsistentHashing)
import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas



-- model


type alias Model =
    { ch : ConsistentHashing }


-- init


init : Model
init =
    { ch =
        ConsistentHashing.new
            Replicas.default
            [ Node.new "node1"
            , Node.new "node2"
            , Node.new "node3"
            , Node.new "node4"
            ]
    }
```

## License
MIT

## Contribution
PRs accepted