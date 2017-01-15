-module(echo_test).

-import(echo, [hear/1, tell/1, list/0]).
-export([echo_hear/1, echo_tell/1, echo_list/0]).

echo_hear(Msg) ->
	echo:hear(Msg).

echo_tell(N) ->
	echo:tell(N).

echo_list() ->
	echo:list().

