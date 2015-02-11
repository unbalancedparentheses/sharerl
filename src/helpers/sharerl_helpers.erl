-module(sharerl_helpers).
-export([
         now/0,
         now_micro/0,
         uuid/0
        ]).

now() ->
  round(now_micro() / 1000000).

now_micro() ->
  {Mega, Sec, Micro} = os:timestamp(),
  Mega * 1000000 * 1000000 + Sec * 1000000 + Micro.

uuid() ->
  erlang:list_to_binary(uuid:uuid_to_string(uuid:get_v4())).
