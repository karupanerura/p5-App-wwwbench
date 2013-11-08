use inc::Module::Install;
name 'App-wwwbench';

requires 'opts';
requires 'Coro';
requires 'Furl';
requires 'Time::HiRes';
requires 'List::Util';

tests 't/*.t';
author_tests 'xt';

install_script 'script/wwwbench';
build_requires 'Test::More';

all_from 'lib/App/wwwbench.pm';

WriteAll;
