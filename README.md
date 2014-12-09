[![Build Status](https://travis-ci.org/karupanerura/Test-SharedObject.svg?branch=master)](https://travis-ci.org/karupanerura/Test-SharedObject) [![Coverage Status](https://img.shields.io/coveralls/karupanerura/Test-SharedObject/master.svg)](https://coveralls.io/r/karupanerura/Test-SharedObject?branch=master)
# NAME

Test::SharedObject - Data sharing in multi process.

# SYNOPSIS

    use strict;
    use warnings;

    use Test::More tests => 2;
    use Test::SharedFork;
    use Test::SharedObject;

    my $shared = Test::SharedObject->new(0);
    is $shared->fetch, 0;

    my $pid = fork;
    die $! unless defined $pid;
    if ($pid == 0) {# child
        $shared->txn(sub {
            my $counter = shift;
            $counter++;
            return $counter;
        });
        exit;
    }
    wait;

    is $shared->fetch, 1;

# DESCRIPTION

Test::SharedObject provides data sharing in multi process.

# LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

karupanerura <karupa@cpan.org>
