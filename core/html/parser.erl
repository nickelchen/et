-module(parser).

-include_lib("xmerl/include/xmerl.hrl").

-define(rec_info(T,R),lists:zip(record_info(fields,T),tl(tuple_to_list(R)))).
-export([read/2]).

read(File, Tag) ->
	{ParsResult, _Misc} = xmerl_scan:file(File),
	% ?rec_info(xmlElement, ParsResult).
	% io:format("result: ~p~n, Misc: ~p~n", [ParsResult, Misc]).
	io:format("tag is: ~p~n", [Tag]),
	Texts1 = case Tag of
		"p" ->
			tag_p(ParsResult);
		"div" ->
			tag_div(ParsResult)
	end,
	Texts2 = lists:flatten(Texts1),
	io:format("paras : ~p~n", [Texts2]).


tag_p(Data) -> tag_p(Data, []).
tag_div(Data) -> tag_div(Data, []).

tag_p(#xmlElement{name=Name, content=Content}, Acc) ->
	TagName = list_to_atom("p"),
	case Name of
		TagName ->
			TextValues = inner_text(Content),
			[TextValues | Acc];
		_ ->
			lists:foldl(fun(Ele, A) -> tag_p(Ele, A) end, Acc, Content)
	end;

tag_p(_, Acc) -> Acc.

tag_div(#xmlElement{name=Name, content=Content}, Acc) ->
	TagName = list_to_atom("div"),
	case Name of
		TagName ->
			TextValues = inner_text(Content),
			[TextValues | Acc];
		_ ->
			lists:foldl(fun(Ele, A) -> tag_div(Ele, A) end, Acc, Content)
	end;

tag_div(_, Acc) -> Acc.

inner_text(Content) ->
	TextEles = lists:filter(fun(E) -> is_record(E, xmlText) end, Content),
	TextValues = lists:map(fun(TextEle) -> trimre(TextEle#xmlText.value) end,
						   TextEles),
	TextValues.

trimre(S) ->
	re:replace(S, "^\\s+|\\s+$", "", [{return, binary}, global]).
