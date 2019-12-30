module Tests.ConsistentHashing exposing (suite)

import ConsistentHashing as ConsistentHashing
import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "ConsistentHashing"
        [ test "new" <|
            \_ ->
                []
                    |> ConsistentHashing.new Replicas.default
                    |> ConsistentHashing.getNode (Key.new "A")
                    |> Expect.equal Nothing
        , test "add" <|
            \_ ->
                let
                    ch =
                        ConsistentHashing.new
                            Replicas.default
                            [ Node.new "node1"
                            , Node.new "node2"
                            , Node.new "node3"
                            , Node.new "node4"
                            ]
                in
                [ "A"
                , "B"
                , "C"
                , "D"
                , "E"
                , "F"
                , "G"
                , "H"
                , "I"
                , "J"
                , "K"
                , "L"
                , "O"
                , "P"
                , "Q"
                , "R"
                , "S"
                , "T"
                , "U"
                , "V"
                ]
                    |> List.map
                        (\value ->
                            ch
                                |> ConsistentHashing.getNode (Key.new value)
                                |> Maybe.map Node.toRawString
                        )
                    |> Expect.equalLists
                        (List.reverse
                            [ Just "node2"
                            , Just "node1"
                            , Just "node2"
                            , Just "node2"
                            , Just "node4"
                            , Just "node4"
                            , Just "node2"
                            , Just "node4"
                            , Just "node3"
                            , Just "node2"
                            , Just "node4"
                            , Just "node2"
                            , Just "node1"
                            , Just "node3"
                            , Just "node4"
                            , Just "node1"
                            , Just "node4"
                            , Just "node3"
                            , Just "node1"
                            , Just "node1"
                            ]
                        )
        ]
