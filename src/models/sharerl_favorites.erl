-module(sharerl_favorites).

-export(
   [
    create/1,
    save/1
   ]).

create(Url) ->
  {ok, P} = python:start([{python_path, "./python/"},
                          {python, "python3"}]),
  {Title, Authors, Text} = python:call(P, url_info, info, [Url]),
  #{
     title => Title,
     authors => Authors,
     text => Text
   }.

save(_Favorite) ->
  ok.
