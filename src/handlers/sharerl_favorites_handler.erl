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
    handle_post/2,
    delete_resource/2
   ]).

allowed_methods(Req, State) ->
  {[<<"OPTIONS">>, <<"GET">>, <<"POST">>, <<"DELETE">>], Req, State}.

handle_get(Req, State) ->
  {Uuid, Req1} = cowboy_req:binding(uuid, Req),
  Body = case Uuid of
           undefined ->
             Favorites = sharerl_favorites:get_all(),
             sharerl_favorites:to_json(Favorites);
           Uuid ->
             Favorite = sharerl_favorites:get(Uuid),
             sharerl_favorites:to_json(Favorite)
         end,
  {Body, Req1, State}.

handle_post(Req, State) ->
  {ok, Url, Req1} = get_url(Req),

  Favorite = sharerl_favorites:create(Url),
  #{uuid := Uuid} = Favorite,

  {LocationUrl, Req2} = cowboy_req:url(Req1),
  Location = [LocationUrl, "/", Uuid],
  {{true, Location}, Req2, State}.

delete_resource(Req, State) ->
  {Uuid, Req1} = cowboy_req:binding(uuid, Req),

  case Uuid of
    undefined ->
      cowboy_req:reply(404, Req1);
    Uuid ->
      sharerl_favorites:destroy(Uuid)
  end,

  {true, Req1, State}.

get_url(Req) ->
  %%TODO: Answer with 404 if Url not present
  {ok, Body, Req1} = cowboy_req:body(Req),
  #{<<"url">> := Url} = jiffy:decode(Body, [return_maps]),
  {ok, Url, Req1}.
