-module(ki33).
-export([start/0, greeting/2]).

greeting(What, 0) ->
	ok;
greeting(What, Times) ->
	io:format("~p~n", [What]),
	greeting(What, Times - 1).

start() ->
	spawn(ki33, greeting, [hello, 3]),
	spawn(ki33, greeting, [bye, 3]).

