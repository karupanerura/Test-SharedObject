use strict;
use warnings;

use Test::More tests => 19;
use Test::SharedFork;
use Test::SharedObject::Variableish;

my $counter = Test::SharedObject::Variableish->new(0);
ok     !$counter;
cmp_ok  $counter, '==',   0;
cmp_ok  $counter, 'eq', '0';

is ++$counter, 1;
is --$counter, 0;

$counter += 13;
is $counter, 13;
$counter -= 12;
is $counter, 1;
$counter *= 50;
is $counter, 50;
$counter /= 5;
is $counter, 10;
$counter %= 3;
is $counter, 1;
$counter **= 100;
is $counter, 1;
$counter x= 3;
is $counter, 111;
$counter .= '222';
is $counter, 111222;
$counter -= 111221;
is $counter, 1;
$counter <<= 3;
is $counter, 8;
$counter >>= 1;
is $counter, 4;
$counter |= 3;
is $counter, 7;
$counter &= 1;
is $counter, 1;
$counter ^= 1;
is $counter, 0;
