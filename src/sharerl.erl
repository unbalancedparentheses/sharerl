-module(sharerl).
-export([start/0, start/2, stop/0, stop/1]).

%% application
%% @doc Starts the application
start() ->
    {ok, _Started} = application:ensure_all_started(sharerl).

%% @doc Stops the application
stop() ->
    application:stop(sharerl).

%% behaviour
%% @private
start(_StartType, _StartArgs) ->
    {ok, Pid} = sharerl_sup:start_link(),
    start_listeners(),

    ets:new(storage, [named_table, public]),

    {ok, Pid}.

%% @private
stop(_State) ->
    cowboy:stop_listener(sharerl_http),
    ok.

start_listeners() ->
    {ok, Port} = application:get_env(sharerl, http_port),
    {ok, ListenerCount} = application:get_env(sharerl, http_listener_count),

    Dispatch =
        cowboy_router:compile(
          [{'_',
            [
             {<<"/">>, sharerl_root_handler, []},
             {<<"/users">>, sharerl_users_handler, []},
             {<<"/favorites/[:uuid]">>, sharerl_favorites_handler, []}
            ]
           }
          ]),

    RanchOptions =
        [
         {port, Port}
        ],
    CowboyOptions =
        [
         {env,
          [
           {dispatch, Dispatch}
          ]},
         {compress, true},
         {timeout, 12000}
        ],

    cowboy:start_http(sharerl_http, ListenerCount, RanchOptions, CowboyOptions).
