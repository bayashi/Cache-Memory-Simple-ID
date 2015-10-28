#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
use Cache::Memory::Simple;
use Cache::Memory::Simple::ID;
use Devel::Size qw/total_size/;

my $element = 1000000;

my $hash  = Cache::Memory::Simple->new;
$hash->set($_ => [], time + 100) for (1..$element);

my $array  = Cache::Memory::Simple::ID->new;
$array->set($_ => [], time + 100) for (1..$element);
say 'hash : '.total_size($hash);
say 'array: '.total_size($array);
say total_size($array) / total_size($hash);

