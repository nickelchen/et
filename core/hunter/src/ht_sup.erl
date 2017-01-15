-module(ht_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Priority) ->
	io:format("in ht_sup:start_child, Priority: ~p~n", [Priority]),
	supervisor:start_child(?SERVER, [Priority]).

init([]) ->
	Server = {hunt_server, {hunt_server, start_link, []},
			  permanent, 2000, worker, [hunt_server]},
	Children = [Server],
	RestartStrategy = {simple_one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.
