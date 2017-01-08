-module(es_api).

%% API.
-export([hear/2, tell/2, list/1, list/0]).

find_pid(Privacy) ->
	case es_store:lookup(Privacy) of
		{ok, Pid} -> Pid;
		{error, _} ->
				  {ok, Pid} = echo_server:create(Privacy),
				  es_store:insert(Privacy, Pid),
				  Pid
	end.

hear(Privacy, Word) ->
	Pid = find_pid(Privacy),
	echo_server:hear(Pid, Word).

tell(Privacy, N) ->
	Pid = find_pid(Privacy),
	echo_server:tell(Pid, N).

list() ->
	list(default_privacy).

list(Privacy) ->
	Pid = find_pid(Privacy),
	echo_server:list(Pid).

