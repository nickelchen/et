%%%-------------------------------------------------------------------
%% @doc reves top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(reves_sup).

-behaviour(supervisor).

%% API
-export([start_link/2]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link(Port, NumAcceptors) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [Port, NumAcceptors]).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([Port, NumAcceptors]) ->
    LSocket = case gen_tcp:listen(Port, [binary, {active, false}, {packet, 1}]) of
        {ok, Socket} -> Socket;
        {error, Reason} -> exit({listen_error, Reason})
    end,

    Acceptors = [{
        {reves_acceptor, self(), N}, {reves_acceptor, start_link, [LSocket]},
        permanent, brutal_kill, worker, [reves_acceptor]
     } || N <- lists:seq(1, NumAcceptors)],

    ConnSup = {
      reves_conns_sup, {reves_conns_sup, start_link, []},
      permanent, infinity, supervisor, [reves_conns_sup]
    },

    {ok, {{one_for_one, 1, 5}, [ConnSup|Acceptors]}}.

%%====================================================================
%% Internal functions
%%====================================================================
