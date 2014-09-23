package Test::SharedObject::Variableish;
use 5.008001;
use strict;
use warnings;

use parent qw/Test::SharedObject/;

my $increment = sub { ++$_[0] };
my $decrement = sub { --$_[0] };

use overload
    '+=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] + $right });
    },
    '-=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] - $right });
    },
    '*=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] * $right });
    },
    '/=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] / $right });
    },
    '%=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] % $right });
    },
    '**=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] ** $right });
    },
    '<<=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] << $right });
    },
    '>>=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] >> $right });
    },
    'x=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] x $right });
    },
    '.=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] . $right });
    },
    '&=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] & $right });
    },
    '|=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] | $right });
    },
    '^=' => sub {
        my ($self, $right) = @_;
        return $self->txn(sub { $_[0] ^ $right });
    },
    '++' => sub {
        my $self = shift;
        return $self->txn($increment);
    },
    '--' => sub {
        my $self = shift;
        return $self->txn($decrement);
    },
    '0+' => sub { 0+ shift->fetch },
    '""' => sub { ''.shift->fetch },
    bool => sub { !! shift->fetch },
    qr   => sub {    shift->fetch },
    fallback => 1;

sub new {
    my ($class, $value) = @_;
    if (defined $value and ref $value) {
        die "cannot store reference if using Test::SharedObject::Variableish. You need to use Test::SharedObject.";
    }
    return $class->SUPER::new($value);
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::SharedObject::Variableish - Data sharing in multi process as variable-ish.

=head1 SYNOPSIS

    use strict;
    use warnings;

    use Test::More tests => 2;
    use Test::SharedFork;
    use Test::SharedObject::Variableish;

    my $counter = Test::SharedObject::Variableish->new(0);
    is $counter, 0;

    my $pid = fork;
    die $! unless defined $pid;
    if ($pid == 0) {# child
        $counter++;
        exit;
    }
    wait;

    is $counter, 1;

=head1 DESCRIPTION

Test::SharedObject::Variableish provides data sharing in multi process as variable-ish.

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut
