%%%-------------------------------------------------------------------
%% @doc testspvr public API
%% @end
%%%-------------------------------------------------------------------

-module(testspvr_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, add/0]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	sync:go(),
    io:format("aaaaaa~n", []),
    testspvr_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

add() ->
    io:format("in add~n", []),
    Child = {echo_server_3, {echo_server, start_link, []},
			permanent, 5000, worker, [echo_server]},
    supervisor:start_child(testspvr_sup, Child).

%%====================================================================
%% Internal functions
%%====================================================================
