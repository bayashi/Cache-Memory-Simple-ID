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
            $hash->get_or_set($_ => sub { 123 }, time + 100) for (1..5);
        },
        array => sub {
            $array->get_or_set($_ => sub { 123 }, time + 100) for (1..5);
        },
    };
};

