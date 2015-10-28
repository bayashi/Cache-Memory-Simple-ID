use strict;
use warnings;
use utf8;
use Test::More;
use Test::Time time => 1;
use Cache::Memory::Simple::ID;
use Time::HiRes qw//;

{
    # CORE::GLOBAL::time() is overrided by Test::Time and use it
    no warnings;
    *Time::HiRes::time = sub { time() };
}

subtest 'get/set' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    is($cache->get(12), undef);
    $cache->set(12 => 'abc');
    is($cache->get(12), 'abc');
    sleep 10;
    is($cache->get(12), 'abc');
};

subtest 'get/set expiration' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    is($cache->get(12), undef);
    $cache->set(12 => 'abc', 3);
    is($cache->get(12), 'abc');
    sleep 10;
    is($cache->get(12), undef);
    is($cache->get(12), undef, 'run twice');
};

subtest 'delete expiration' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    is($cache->get(12), undef);
    $cache->set(12 => 'abc', 3);
    is($cache->get(12), 'abc');
    $cache->delete(12);
    is($cache->get(12), undef, 'removed');
};

subtest 'purge expired data' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    is($cache->get(12), undef);
    $cache->set(34  => 'live',  3);
    $cache->set(56   => 'life', 60);
    $cache->set(78  => 'ending story');
    is($cache->count, 3, 'only three data');
    sleep 10;
    $cache->purge();
    is($cache->count, 2, 'removed short lived');
    is($cache->get(34), undef);
    is($cache->get(56),  'life');
    is($cache->get(78), 'ending story');
    $cache->remove(56);
    is($cache->get(56), undef, 'removed');
};

subtest 'delete_all' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    $cache->set(0 => 'y');
    $cache->set(1 => 'o');
    $cache->delete_all();
    is($cache->get(0), undef);
    is($cache->get(1), undef);
};

done_testing;

