-module(hunt_server).
-behavior(gen_server).

-export([create/1, hunt/2, show/2, list/1]).
-export([start_link/0,
		 start_link/1,
		 start/1,
		 init/1,
		 handle_call/3,
		 handle_cast/2]).

-define(SERVER, ?MODULE).
-record(user, {name, intro, updated}).

start_link() ->
	start_link(default_tag).

start_link(Tag) ->
	gen_server:start_link(?MODULE, [Tag], []).

start(Tag) ->
	gen_server:start({local, ?SERVER}, ?MODULE, [Tag], []).

init_state(Tag) ->
	{Tag, []}.

init([Tag]) ->
	{ok, init_state(Tag)}.

create(Tag) ->
	ht_sup:start_child(Tag).

hunt(Pid, Name) ->
	gen_server:cast(Pid, {hunt, Name}).

show(Pid, N) ->
	gen_server:call(Pid, {show, N}).

list(Pid) ->
	gen_server:call(Pid, list).

current() ->
	calendar:now_to_local_time(erlang:timestamp()).

format_users(L) -> format_users(L, []).

format_users([H | Tail], Acc) ->
	#user{name=Name, updated=Updated} = H,
	format_users(Tail, [{Name, Updated} | Acc]);
format_users([], Acc) ->
	Acc.

handle_cast({hunt, Name}, State1) ->
	{Tag, Users1} = State1,
	CurrentTime = current(),
	Users2 = case lists:keyfind(Name, #user.name, Users1) of
		#user{} ->
			% found
			User = #user{name=Name, intro=none, updated=CurrentTime},
			lists:keyreplace(Name, #user.name, Users1, User);
		false ->
			User = #user{name=Name, intro=none, updated=CurrentTime},
			[User | Users1]
	end,
	State2 = {Tag, Users2},
	io:format("State is: ~p~n", [State2]),
	{noreply, State2}.

%% first in first out.
handle_call({show, Name}, _From, State) ->
	{_, Users} = State,
	io:format("users: ~p, name: ~p ~n", [Users, Name]),
	Info = case lists:keyfind(Name, #user.name, Users) of
		#user{intro=Intro, updated=Updated} ->
			{Intro, Updated};
		false ->
			not_found
	end,
	{reply, Info, State};

handle_call(list, _From, State) ->
	{_Privacy, Users} = State,
	Formatted = format_users(Users),
	{reply, Formatted, State}.
