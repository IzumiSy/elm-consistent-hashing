# elm-consistent-hashing
[![CircleCI](https://circleci.com/gh/IzumiSy/elm-consistent-hashing.svg?style=svg)](https://circleci.com/gh/IzumiSy/elm-consistent-hashing)
> A pure Elm consistent hashing module

## What is Consistent Hashing?
> Consistent Hashing is a distributed hashing scheme that operates independently of the number of servers or objects in a distributed hash table by assigning them a position on an abstract circle, or hash ring. This allows servers and objects to scale without affecting the overall system.

https://www.toptal.com/big-data/consistent-hashing

## Example
```elm
import ConsistentHashing as ConsistentHashing
import ConsistentHashing.Node as Node
import ConsistentHashing.Replica as Replica



-- model


type alias Model =
    { ch : ConsistentHashing.ConsistentHashing }


-- init


init : Model
init =
    { ch =
        ConsistentHashing.new Replica.default (Node.new "node1")
            |> ConsistentHashing.add (Node.new "node2")
            |> ConsistentHashing.add (Node.new "node3")
            |> ConsistentHashing.add (Node.new "node4")
    }
```

## License
MIT

## Contribution
PRs accepted
