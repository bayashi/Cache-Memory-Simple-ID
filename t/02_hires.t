use strict;
use warnings;
use utf8;
use Test::More;
use Cache::Memory::Simple::ID;
use Time::HiRes qw//;
 
subtest 'available' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    $cache->set(12, 'bar', 0.5);
    Time::HiRes::sleep 0.2;
    is $cache->get(12), 'bar';
};
 
subtest 'expires' => sub {
    my $cache = Cache::Memory::Simple::ID->new();
    $cache->set(12, 'bar', 0.1);
    Time::HiRes::sleep 0.2;
    is $cache->get(12), undef;
};
 
done_testing;
