use strict;
use warnings;

use Test::More tests => 5;
use Test::SharedFork;
use Test::SharedObject;

my $shared = Test::SharedObject->new(0);
is $shared->fetch, 0, 'should success to set 0.';
$shared->txn(sub { ++$_[0] });
is $shared->fetch, 1, 'should get changed value.';
$shared->store(2);
is $shared->fetch, 2, 'should get stored value.';

my $pid = fork;
die $! unless defined $pid;
if ($pid == 0) {# child
    $shared->txn(sub { ++$_[0] });
    is $shared->fetch, 3, 'should get changed value in child process.';
    exit;
}
wait;

is $shared->fetch, 3,  'should get changed value in parent process.';
