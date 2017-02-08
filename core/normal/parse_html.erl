-module(parse_html).

-export([parse/2]).
-export([levelize/1]).

%% Node -> html_node() from mochiweb_html
%% Selector -> string(), like "html>body li.selected > p span"
%%
parse(Node, Selector) ->
	SelectorLevels = levelize(Selector),
	parse_levels(Node, SelectorLevels).

parse_levels(Node, Levels) ->
	parse_levels(Node, Levels, [], []).

parse_levels({_TagName, _Attrs, Children} = Node, Levels, Path, Acc) ->
	% if path match levels, then the node is selected.
	case match_levels(Node, Path, Levels) of
		true -> [Node|Acc];
		false -> parse_levels_2(Children, Levels, [Node|Path], Acc)
	end.

parse_levels_2([], _Levels, _Path, Acc) ->
	Acc;

parse_levels_2([Node|Tail], Levels, Path, Acc1) ->
	Acc2 = parse_levels(Node, Levels, Path, Acc1),
	parse_levels_2(Tail, Levels, Path, Acc2).
	
match_levels(Node, Path1, Levels) ->
	Path2 = [Node|Path1],
	if
		length(Path2) =:= length(Levels) ->
			true;
		true ->
			false
	end.

levelize(S) ->
	Tokens = string:tokens(S, " "),
	levelize_tokens(Tokens).

levelize_tokens(Ts) ->
	levelize_tokens(Ts, []).

levelize_tokens([], Acc) ->
	lists:reverse(Acc);
levelize_tokens([Tok|Tail], Acc) ->
	Direct = case string:rchr(Tok, $>) of
		0 -> false;
		_ -> true
	end,
	levelize_tokens(Tail, [{list_to_binary(Tok), Direct}|Acc]).
