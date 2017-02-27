%%%-------------------------------------------------------------------
%% @doc testspvr top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(testspvr_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    io:format("test spvr sup~n", []),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Procs = [{my_server, {my_server, start_link, []},
			permanent, 5000, worker, [my_server]}],
    % Procs = [],

    io:format("test spvr sup init ~n", []),

    {ok, {{one_for_one, 1, 5}, Procs}}.

%%====================================================================
%% Internal functions
%%====================================================================
