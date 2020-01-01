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
        , test "remove" <|
            \_ ->
                let
                    node1 =
                        Node.new "node1"

                    node2 =
                        Node.new "node2"

                    node3 =
                        Node.new "node3"

                    node4 =
                        Node.new "node4"

                    ch =
                        ConsistentHashing.new Replica.default node1
                            |> ConsistentHashing.add node2
                            |> ConsistentHashing.add node3
                            |> ConsistentHashing.add node4
                            |> ConsistentHashing.remove node1
                            |> ConsistentHashing.remove node3
                            |> ConsistentHashing.remove node2
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
                        [ "node4"
                        , "node4"
                        , "node4"
                        , "node4"
                        , "node4"
                        , "node4"
                        ]
        ]
