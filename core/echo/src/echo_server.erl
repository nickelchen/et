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
	gen_server:cast(?SERVER, {hear, {Privacy, Word}}).

tell(N) ->
	gen_server:call(?SERVER, {tell, N}).

list() ->
	gen_server:call(?SERVER, list).

current() ->
	ok.

format_pwords(L) -> format_pwords(L, []).
format_pwords([H | Tail], Acc) ->
	#pword{privacy=Privacy, word=Word, updated=Updated} = H,
	format_pwords(Tail, [{Privacy, Word, Updated} | Acc]);
format_pwords([], Acc) ->
	Acc.

handle_cast({hear, {Privacy, Word}}, State1) ->
	CurrentTime = current(),
	State2 = case lists:keyfind(Word, #pword.word, State1) of
		#pword{} ->
			% found
			Pword2 = #pword{privacy=Privacy, word=Word, updated=CurrentTime},
			lists:keyreplace(Word, #pword.word, State1, Pword2);
		false ->
			Pword2 = #pword{privacy=Privacy, word=Word, updated=CurrentTime},
			[Pword2 | State1]
	end,
	{noreply, State2}.

%% first in first out.
handle_call({tell, N}, _From, State) ->
	Index = case length(State) >= N of
		true -> length(State) - N;
		false -> 0
	end,

	Fetched = lists:nthtail(Index, State),
	Formatted = format_pwords(Fetched),
	State2 = lists:sublist(State, Index),
	{reply, Formatted, State2};

handle_call(list, _From, State) ->
	Formatted = format_pwords(State),
	{reply, Formatted, State}.
