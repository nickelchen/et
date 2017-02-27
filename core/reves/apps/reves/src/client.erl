-module(client).

-export([c/2, c/1, c/0]).

c() ->
    c(8080).

c(Port) ->
    c(Port, << "helloworld" >>).

c(Port, Request) ->
    {ok, CSocket} = gen_tcp:connect("localhost", Port,
                                    [binary, {active, false}, {packet, 1}]),

    gen_tcp:send(CSocket, pack(Request)),
    Response = gen_tcp:recv(CSocket, 0),
    io:format("send: ~p, received: ~p ~n", [pack(Request), Response]),

    Request1 = <<$1, Request/binary>>,
    gen_tcp:send(CSocket, pack(Request1)),
    Response1 = gen_tcp:recv(CSocket, 0),
    io:format("send: ~p, received: ~p ~n", [pack(Request1), Response1]),

    Request2 = <<$2, Request/binary>>,
    gen_tcp:send(CSocket, pack(Request2)),
    Response2 = gen_tcp:recv(CSocket, 0),
    io:format("send: ~p, received: ~p ~n", [pack(Request2), Response2]),

    gen_tcp:close(CSocket).

pack(Message) ->
    Len = byte_size(Message),
    io:format("byte size is ~p, ~p~n", [Len, <<Len>>]),

    % gen_tcp:send will generate header, if {packet, N} is set.
    % so need not add header by ourself.
    % <<Len, Message/binary>>.

    <<Message/binary>>.
