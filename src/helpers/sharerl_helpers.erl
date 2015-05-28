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
  R1 = uuid:uuid_to_string(uuid:get_v4()),
  R2 = remove_dash(R1),
  erlang:list_to_binary(R2).

%% internal
remove_dash(String) ->
  re:replace(String, "\-", "", [global,{return,list}]).
