-module(reves_server).
-behaviour(gen_server).

-export([start_link/0, init/1]).
-export([handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {count}).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->
    {ok, #state{count=0}}.

handle_info({socket_controlled, Socket}, State) ->
    inet:setopts(Socket, [{active, once}]),
    {noreply, State};

handle_info({tcp, Socket, Data}, #state{count=Count0}) ->
    inet:setopts(Socket, [{active, once}]),
    Count = Count0 + 1,
    Reversed = reverse(Data),
    gen_tcp:send(Socket, Reversed),
    {noreply, #state{count=Count}, 5000};

handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};

handle_info({tcp_error, _Socket, Reason}, State) ->
    {stop, Reason, State};

handle_info(timeout, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {stop, normal, State}.

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_Oldvsn, State, _Extra) ->
    {ok, State}.

reverse(Data) ->
    Reversed = list_to_binary(lists:reverse(binary_to_list(Data))),
    Reversed.

% reverse_binary(B) when is_binary(B) ->
% 	[list_to_binary(lists:reverse(binary_to_list(
% 		binary:part(B, {0, byte_size(B)-2})
% 	))), "\r\n"].
