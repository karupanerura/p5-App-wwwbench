requires 'Coro';
requires 'Furl';
requires 'List::Util';
requires 'Time::HiRes';
requires 'opts';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
    requires 'Test::More';
};
