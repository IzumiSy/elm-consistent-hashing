module Tests.ConsistentHashing exposing (suite)

import ConsistentHashing as ConsistentHashing
import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node
import ConsistentHashing.Replica as Replica
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    let
        sourceAndResults =
            [ ( "A", "node1" )
            , ( "B", "node1" )
            , ( "C", "node3" )
            , ( "D", "node4" )
            , ( "E", "node1" )
            , ( "F", "node4" )
            ]
    in
    describe "ConsistentHashing"
        [ test "add" <|
            \_ ->
                let
                    ch =
                        ConsistentHashing.new Replica.default (Node.new "node1")
                            |> ConsistentHashing.add (Node.new "node2")
                            |> ConsistentHashing.add (Node.new "node3")
                            |> ConsistentHashing.add (Node.new "node4")
                in
                sourceAndResults
                    |> List.map Tuple.first
                    |> List.map
                        (\value ->
                            ch
                                |> ConsistentHashing.getNode (Key.new value)
                                |> Node.toString
                        )
                    |> Expect.equalLists
                        (List.map Tuple.second sourceAndResults)
        ]
