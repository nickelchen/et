-module(reves_conns_sup).

-behaviour(supervisor).

-export([start_link/0, init/1, start_child/0]).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Procs = [],
    {ok, {{one_for_one, 1, 5}, Procs}}.

start_child() ->
    ChildSpec = {
      {reves_server, erlang:timestamp()}, {reves_server, start_link, []},
      permanent, brutal_kill, worker, [reves_server]
    },

    {ok, Pid} = supervisor:start_child(?MODULE, ChildSpec),
    Pid.
