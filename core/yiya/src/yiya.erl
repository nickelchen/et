-module(yiya).

-export([start/0]).

start() ->
    application:start(ranch),
    application:start(yiya).
