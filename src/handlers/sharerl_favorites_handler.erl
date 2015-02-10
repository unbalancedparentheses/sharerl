-module(sharerl_favorites_handler).
-include_lib("mixer/include/mixer.hrl").
-mixin([
        {sharerl_default,
         [
          init/3,
          rest_init/2,
          content_types_accepted/2,
          content_types_provided/2,
          resource_exists/2
         ]}
       ]).

-export(
   [
    allowed_methods/2,
    handle_get/2,
    handle_post/2
   ]).

allowed_methods(Req, State) ->
  {[<<"GET">>, <<"POST">>], Req, State}.

handle_get(Req, State) ->
  lager:info("GET"),
  Body = <<"Got a request\n">>,
  {Body, Req, State}.

handle_post(Req, State) ->
  {ok, Body, Req1} = cowboy_req:body(Req),
  #{<<"url">> := Url} = jiffy:decode(Body, [return_maps]),

  UrlInfo = sharerl_favorites:create(Url),

  Answer = jiffy:encode(UrlInfo, [uescape]),
  Req2 = cowboy_req:set_resp_body(Answer, Req1),
  {true, Req2, State}.
