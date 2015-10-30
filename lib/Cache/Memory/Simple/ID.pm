package Cache::Memory::Simple::ID;
use strict;
use warnings;
use Time::HiRes;

our $VERSION = '0.01';

sub new {
    my ($class) = @_;

    bless +[], $class;
}

sub get {
    my $val = $_[0]->[$_[1]];
    if ($val && defined $val->[0]) {
        if ($val->[0] > Time::HiRes::time() ) {
            return $val->[1];
        } else {
            $_[0]->[$_[1]] = undef; # remove expired data
            return undef; ## no critic
        }
    } else {
        return $val->[1];
    }
}

sub get_or_set {
    my ($self, $id, $code, $expiration) = @_;

    if (my $val = $self->get($id)) {
        return $val;
    } else {
        my $val = $code->();
        $self->set($id, $val, $expiration);
        return $val;
    }
}

sub set {
    my ($self, $id, $val, $expiration) = @_;

    $self->[$id] = [defined($expiration) 
                         ? $expiration + Time::HiRes::time()
                         : undef,
                     $val];
    return $val;
}

sub delete :method {
    my ($self, $id) = @_;
    $self->[$id] = undef;
}
sub remove { shift->delete(@_) } # alias

sub delete_all {
    @{$_[0]} = ();
    return;
}

sub purge {
    my $self = shift;

    my $id;
    for ($id = 0; $id < $#{$self}; $id++) {
        if (defined($self->[$id]) && $self->[$id][0] < Time::HiRes::time() ) {
            $self->delete($id);
        }
    }
}

sub count {
    my $self = shift;

    my $count = 0;
    for my $id (@{$self}) {
        $count++ if ref($id) eq 'ARRAY';
    }

    return $count;
}

1;

__END__

=encoding UTF-8

=head1 NAME

Cache::Memory::Simple::ID - Yet another on memory cache for ID key


=head1 SYNOPSIS

    use Cache::Memory::Simple::ID;
    use feature qw/state/;

    sub get_user_info {
        my ($class, $user_id) = @_;

        state $user_cache = Cache::Memory::Simple::ID->new();
        $user_cache->get_or_set(
            $user_id, sub {
                Storage->get($user_id) # slow operation
            }, 10 # cache in 10 seconds
        );
    }


=head1 DESCRIPTION

Cache::Memory::Simple::ID was optimised an ID(integer) key for caching.
It is bit faster than L<Cache::Memory::Simple> which uses HASH for caching.
And Cache::Memory::Simple::ID is friendly with memory.

To check more detail: C<benchmark/*> of this distribution

=head2 CAVEAT

You can use ONLY numeral key as cache key.

Probably, you are going to get an error 'Out of memory' even if you use an integer key as cache key like below.

    my $cache  = Cache::Memory::Simple::ID->new;
    $cache->set(2**31-1 => 1); # kaboom!


=head1 METHODS

=over 4

=item C<< my $obj = Cache::Memory::Simple::ID->new() >>

Create a new instance.

=item C<< my $stuff = $obj->get($id); >>

Get a stuff from cache storage by C<< $id >>

=item C<< $obj->set($id, $val, $expiration) >>

Set a stuff for cache.

=item C<< $obj->get_or_set($id, $code, $expiration) >>

Get a cache value for I<$id> if it's already cached. If it's not cached then, run I<$code> and cache I<$expiration> seconds
and return the value.

=item C<< $obj->delete($id) >>

Delete key from cache.

=item C<< $obj->remove($id) >>

Alias for 'delete' method.

=item C<< $obj->purge() >>

Purge expired data.

This module does not purge expired data automatically. You need to call this method if you need.

=item C<< $obj->delete_all() >>

Remove all data from cache.

=item C<< $obj->count() >>

Get a count of cache element.

=back


=head1 REPOSITORY

=begin html

<a href="http://travis-ci.org/bayashi/Cache-Memory-Simple-ID"><img src="https://secure.travis-ci.org/bayashi/Cache-Memory-Simple-ID.png"/></a> <a href="https://coveralls.io/r/bayashi/Cache-Memory-Simple-ID"><img src="https://coveralls.io/repos/bayashi/Cache-Memory-Simple-ID/badge.png?branch=master"/></a>

=end html

Cache::Memory::Simple::ID is hosted on github: L<http://github.com/bayashi/Cache-Memory-Simple-ID>

I appreciate any feedback :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<Cache::Memory::Simple>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
