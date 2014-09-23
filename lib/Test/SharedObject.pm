package Test::SharedObject;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Storable qw/store_fd fd_retrieve/;
use File::Temp qw/tempfile/;
use Test::SharedObject::Lock;

my $identity = sub { $_[0] };

sub new {
    my ($class, $data) = @_;

    my ($fh, $file) = tempfile(EXLOCK => 0);
    my $self = bless {
        file => $file,
        ppid => $$,
    } => $class;

    seek $fh, 0, 0;
    truncate $fh, 0;
    store_fd \$data, $fh;
    close $fh;

    return $self;
}

sub txn {
    my ($self, $code) = @_;
    my $lock = Test::SharedObject::Lock->new($self);

    my $fh   = $lock->fh;
    my $ref  = fd_retrieve $fh;
    my $data = $code->($$ref);

    seek $fh, 0, 0;
    truncate $fh, 0;
    store_fd \$data, $fh;

    return $data; ## unlock
}

sub store {
    my ($self, $data) = @_;
    return $self->txn(sub { $data });
}

sub fetch {
    my $self = shift;
    return $self->txn($identity);
}

sub DESTROY {
    my $self = shift;
    unlink $self->{file} if $$ == $self->{ppid};
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::SharedObject - Data sharing in multi process.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Test::SharedObject provides data sharing in multi process.

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut
