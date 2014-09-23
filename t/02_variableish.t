use strict;
use warnings;

use Test::More tests => 4;
use Test::SharedFork;
use Test::SharedObject::Variableish;

my $counter = Test::SharedObject::Variableish->new(0);
is $counter,   0, 'should success to set 0.';
is ++$counter, 1, 'should get changed value.';

my $pid = fork;
die $! unless defined $pid;
if ($pid == 0) {# child
    is ++$counter, 2, 'should get changed value in child process.';
    exit;
}
wait;

is $counter, 2, 'should get changed value in parent process.';
