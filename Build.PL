use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    name                => 'Cache-Memory-Simple-ID',
    module_name         => 'Cache::Memory::Simple::ID',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/Cache/Memory/Simple/ID.pm',
    configure_requires  => {
        'Module::Build' => 0.38,
    },
    build_requires      => {
        'Test::More' => 0.90,
        'Test::Time' => 0,
    },
    requires => {
        'perl' => '5.008001',
        'strict' => 0,
        'warnings' => 0,
        'Time::HiRes' => 0,
    },
    add_to_cleanup      => [ 'Cache-Memory-Simple-ID-*' ],
    meta_merge     => {
      resources => {
        repository  => 'http://github.com/bayashi/Cache-Memory-Simple-ID',
        bugtracker  => 'http://github.com/bayashi/Cache-Memory-Simple-ID/issues',
        x_IRC       => {
            url => 'irc://chat.freenode.org/#bayadev',
            web => 'http://webchat.freenode.net/?channels=%23bayadev',
        },
      }
    },
    recursive_test_files => 1,
    test_files => (-d '.git' || $ENV{RELEASE_TESTING}) ? ['t/', 'xt/'] : ['t/'],
);

$builder->create_build_script();
