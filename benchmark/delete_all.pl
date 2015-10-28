#!/usr/bin/env perl
use strict;
use warnings;
use Benchmarks sub {
    use Cache::Memory::Simple;
    use Cache::Memory::Simple::ID;

    my $hash  = Cache::Memory::Simple->new;
    my $array = Cache::Memory::Simple::ID->new;

    return +{
        hash => sub {
            $hash->set($_ => $_, time + 9999) for (1..10);
            $hash->delete_all();
        },
        array => sub {
            $array->set($_ => $_, time + 9999) for (1..10);
            $array->delete_all();
        },
    };
};

