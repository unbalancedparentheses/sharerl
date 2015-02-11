-module(sharerl_favorites).

-export(
   [
    create/1,
    get/1,
    get_all/0,
    destroy/1,
    save/2,
    to_json/1
   ]).

create(Url) ->
  %%TODO: newspaper call must be made async after the save on the db
  {ok, P} = python:start([{python_path, "./python/"},
                          {python, "python3"}]),
  {Title, Authors, Text} = python:call(P, url_info, info, [Url]),

  Uuid = sharerl_helpers:uuid(),
  Favorite = #{
    uuid => Uuid,
    title => Title,
    authors => Authors,
    text => Text,
    url => Url,
    time => sharerl_helpers:now()
   },
  ets:insert(storage, {Uuid, Favorite}),
  Favorite.

get(Uuid) ->
  [{_Uuid, Favorite}] = ets:lookup(storage, Uuid),
  Favorite.

get_all() ->
  Favorites = ets:tab2list(storage),
  lists:map(fun ({_Uuid, Favorite}) ->
                Favorite
            end
           , Favorites).

destroy(Uuid) ->
  true == ets:delete(storage, Uuid).

save(Uuid, Favorite) ->
  true == ets:insert(storage, {Uuid, Favorite}).

to_json(Favorites) when is_list(Favorites)->
  %%TODO: jiffy call must be encapsulated in a module
  Favorites2 = lists:map(fun (Favorite) ->
                             maps:remove(text, Favorite)
                         end
                        , Favorites),
  Header = #{
    favorites => Favorites2
   },

  jiffy:encode(Header, [uescape]);
to_json(Favorite) ->
  jiffy:encode(Favorite, [uescape]).
