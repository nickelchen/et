-module(echo_server).
-behavior(gen_server).

-export([create/1, hunt/2, tell/2, list/1]).
-export([start_link/0,
		 start_link/1,
		 start/1,
		 init/1,
		 handle_call/3,
		 handle_cast/2]).

-define(SERVER, ?MODULE).
-record(pword, {word, updated}).

start_link() ->
	start_link(default_privacy).

start_link(Privacy) ->
	gen_server:start_link(?MODULE, [Privacy], []).

start(Privacy) ->
	gen_server:start({local, ?SERVER}, ?MODULE, [Privacy], []).

init_state(Privacy) ->
	{Privacy, []}.

init([Privacy]) ->
	{ok, init_state(Privacy)}.

create(Privacy) ->
	es_sup:start_child(Privacy).

hunt(Pid, Word) ->
	gen_server:cast(Pid, {hunt, Word}).

tell(Pid, N) ->
	gen_server:call(Pid, {tell, N}).

list(Pid) ->
	gen_server:call(Pid, list).

current() ->
	calendar:now_to_local_time(erlang:timestamp()).

format_pwords(L) -> format_pwords(L, []).

format_pwords([H | Tail], Acc) ->
	#pword{word=Word, updated=Updated} = H,
	format_pwords(Tail, [{Word, Updated} | Acc]);
format_pwords([], Acc) ->
	Acc.

handle_cast({hunt, Word}, State1) ->
	{Privacy, Pwords1} = State1,
	CurrentTime = current(),
	Pwords2 = case lists:keyfind(Word, #pword.word, Pwords1) of
		#pword{} ->
			% found
			Pword = #pword{word=Word, updated=CurrentTime},
			lists:keyreplace(Word, #pword.word, Pwords1, Pword);
		false ->
			Pword = #pword{word=Word, updated=CurrentTime},
			[Pword | Pwords1]
	end,
	State2 = {Privacy, Pwords2},
	io:format("State is: ~p~n", [State2]),
	{noreply, State2}.

%% first in first out.
handle_call({tell, N}, _From, State) ->
	{Privacy, Pwords} = State,
	Index = case length(Pwords) - N of
		Value when Value >=0 -> Value;
		_Value 				 -> 0
	end,

	Fetched = lists:nthtail(Index, Pwords),
	Pwords2 = lists:sublist(Pwords, Index),

	Formatted = format_pwords(Fetched),
	State2 = {Privacy, Pwords2},
	{reply, Formatted, State2};

handle_call(list, _From, State) ->
	{_Privacy, Pwords} = State,
	Formatted = format_pwords(Pwords),
	{reply, Formatted, State}.
