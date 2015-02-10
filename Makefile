PROJECT = sharerl

DEPS = cowboy lager jiffy mixer sync erlport
dep_lager = git https://github.com/basho/lager.git master
dep_jiffy = git https://github.com/davisp/jiffy.git master
dep_mixer = git https://github.com/opscode/mixer.git master
dep_sync = git https://github.com/rustyio/sync.git master
dep_erlport = git git@github.com:hdima/erlport.git master

include erlang.mk

ERLC_OPTS += +'{parse_transform, lager_transform}'
TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'

CT_SUITES = root_handler
CT_OPTS = -erl_args -config rel/sys.config

SHELL_OPTS = +pc unicode -name ${PROJECT}@`hostname` -s ${PROJECT} -config rel/sys.config
