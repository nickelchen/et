-module(ppg).
-export([ping/2, pong/0, start/0]).

ping(0, Pong_PID) ->
	Pong_PID ! finish,
	io:format("Ping finish~n", []);

ping(N, Pong_PID) ->
	Pong_PID ! {ping, self()},
	receive
		pong ->
			io:format("Ping recieved pong~n", [])
	end,
	ping(N - 1, Pong_PID).

pong() ->
	receive
		finish ->
			io:format("Pong finish~n", []);
		{ping, Ping_PID} ->
			io:format("Pong received ping~n", []),
			Ping_PID ! pong,
			pong()
	end.

start() ->
	Pong_PID = spawn(ppg, pong, []),
	spawn(ppg, ping, [3, Pong_PID]).

