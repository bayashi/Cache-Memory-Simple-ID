#!/usr/bin/env perl
use strict;
use warnings;
use Benchmarks sub {
    use Cache::Memory::Simple;
    use Cache::Memory::Simple::ID;

    my $hash  = Cache::Memory::Simple->new;
    my $array = Cache::Memory::Simple::ID->new;

    $hash->set($_ => $_, time + 9999) for (1..100);
    $array->set($_ => $_, time + 9999) for (1..100);

    return +{
        hash => sub {
            $hash->get($_) for (1..100);
        },
        array => sub {
            $array->get($_) for (1..100);
        },
    };
};

