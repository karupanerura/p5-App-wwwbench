use inc::Module::Install;
name 'App-wwwbench';
all_from 'lib/App/wwwbench.pm';
readme_from 'lib/App/wwwbench.pm';
readme_pod_from 'lib/App/wwwbench.pm';
githubmeta;

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
