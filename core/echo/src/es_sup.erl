-module(es_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Privacy) ->
	io:format("in es_sup:start_child, Privacy: ~p~n", [Privacy]),
	supervisor:start_child(?SERVER, [Privacy]).

init([]) ->
	Server = {echo_server, {echo_server, start_link, []},
			  permanent, 2000, worker, [echo_server]},
	Children = [Server],
	RestartStrategy = {simple_one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.
