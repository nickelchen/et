-module(ht_api).

%% API.
-export([show/2, hunt/2, list/1, list/0]).

find_pid(Tag) ->
	case ht_store:lookup(Tag) of
		{ok, Pid} -> Pid;
		{error, _} ->
				  {ok, Pid} = echo_server:create(Tag),
				  ht_store:insert(Tag, Pid),
				  Pid
	end.

show(Tag, Name) ->
	Pid = find_pid(Tag),
	echo_server:show(Pid, Name).

hunt(Tag, N) ->
	Pid = find_pid(Tag),
	echo_server:hunt(Pid, N).

list() ->
	list(default_priority).

list(Tag) ->
	Pid = find_pid(Tag),
	echo_server:list(Pid).

