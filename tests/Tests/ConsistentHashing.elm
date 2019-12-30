module Tests.ConsistentHashing exposing (suite)

import ConsistentHashing as ConsistentHashing
import ConsistentHashing.Key as Key
import ConsistentHashing.Node as Node
import ConsistentHashing.Replicas as Replicas
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
            , ( "G", "node3" )
            , ( "H", "node1" )
            , ( "I", "node2" )
            , ( "J", "node4" )
            , ( "K", "node2" )
            , ( "L", "node3" )
            , ( "O", "node4" )
            , ( "P", "node2" )
            , ( "Q", "node4" )
            , ( "R", "node4" )
            , ( "S", "node2" )
            , ( "T", "node2" )
            , ( "U", "node1" )
            , ( "V", "node2" )
            ]
    in
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
                sourceAndResults
                    |> List.map Tuple.first
                    |> List.map
                        (\value ->
                            ch
                                |> ConsistentHashing.getNode (Key.new value)
                                |> Maybe.map Node.toRawString
                        )
                    |> Expect.equalLists
                        (List.map (Just << Tuple.second) sourceAndResults)
        ]
