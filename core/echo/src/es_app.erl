-module(es_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _StartArgs) ->
	reloader:start(),
	es_store:init(),
	case es_sup:start_link() of
		{ok, Pid} ->
			{ok, Pid};
		Other ->
			{error, Other}
	end.

stop(_State) ->
	ok.
