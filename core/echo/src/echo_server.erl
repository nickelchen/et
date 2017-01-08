-module(echo_server).
-behavior(gen_server).

-export([hear/2, tell/1, list/0]).
-export([start_link/0, start/0, init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).
-record(pword, {privacy, word, updated}).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

start() ->
	gen_server:start({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
	{ok, []}.

hear(Privacy, Word) ->
	% io:format("in hear, Word: ~p~n", Word),
	gen_server:cast(?SERVER, {hear, {Privacy, Word}}).

tell(N) ->
	gen_server:call(?SERVER, {tell, N}).

list() ->
	gen_server:call(?SERVER, list).

current() ->
	ok.

format_pwords([H | Tail], Acc) ->
	#pword{privacy=Privacy, word=Word} = H,
	format_pwords(Tail, [{Privacy, Word} | Acc]);
format_pwords([], Acc) ->
	Acc.

fetch_pwords([H | Tail], N, {Acc, [H | Tail]}) when N > 0 ->
	fetch_pwords(Tail, N - 1, {[H | Acc], Tail});
fetch_pwords([], _N, Acc) ->
	Acc;
fetch_pwords(_L, 0, Acc) ->
	Acc.

handle_cast({hear, {Privacy, Word}}, State1) ->
	CurrentTime = current(),
	case lists:keyfind(Word, 3, State1) ->
		{value, Pword} ->
			% found
			State2 = lists:keyreplace(Word, 3, State1, NewPword);
		false ->
			Pword = #pword{privacy=Privacy, word=Word, updated=CurrentTime},
			State2 = [Pword | State1]
	end,

	State2 = [#pword{privacy=Privacy, word=Word, updated=CurrentTime} | State1],
	{noreply, State2}.

handle_call({tell, N}, _From, State) ->
	#state{last_updated=_LastUpdated, pwords=Pwords} = State,
	CurrentTime = current(),
	{Fetched, Tail} = fetch_pwords(Pwords, N, {[], Pwords}),
	Formatted = format_pwords(Fetched, []),
	State2 = #state{last_updated=CurrentTime, pwords=Tail},
	{reply, Formatted, State2};

handle_call(list, _From, State) ->
	#state{last_updated=_LastUpdated, pwords=Pwords} = State,
	Formatted = format_pwords(Pwords, []),
	{reply, Formatted, State}.
