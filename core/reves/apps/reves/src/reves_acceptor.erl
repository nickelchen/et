-module(reves_acceptor).

-export([start_link/1, accept/1]).

start_link(LSocket) ->
    Pid = spawn_link(?MODULE, accept, [LSocket]),
    {ok, Pid}.

accept(LSocket) ->
    CSocket = case gen_tcp:accept(LSocket) of
        {ok, Socket} -> Socket;
        {error, Reason} -> exit({error_accept, Reason})
    end,

    ServerPid = reves_conns_sup:start_child(),
    % make server pid the owner of the connection socket.
    gen_tcp:controlling_process(CSocket, ServerPid),
    ServerPid ! {socket_controlled, CSocket},

    accept(LSocket).

