use 5.006;
use Test::Roo;
use MooX::Types::MooseLike::Base qw/:all/;

require IO::Iron::IronMQ::Client;
require IO::Iron::IronMQ::Queue;
require IO::Iron::IronMQ::Message;

has client => (
    is => 'lazy',
    isa => InstanceOf['IO::Iron::IronMQ::Client'],
);

has queue_name => (
    is => 'ro',
    isa => Str,
    default => sub { 'test_dancer_plugin_queue_ironmq' },
);

sub _build_client {
    return IO::Iron::IronMQ::Client->new();
}

sub _build_options {
    my ($self) = @_;
    return { };
}

sub BUILD {
    my ($self) = @_;
    eval { $self->client }
        or plan skip_all => "No connection to IronMQ maybe!!!";
}

before setup => sub {
    my $self = shift;
};

after teardown => sub {
    my $self = shift;
};

with 'Dancer2::Plugin::Queue::Role::Test';

run_me({ backend => 'IronMQ' });

done_testing;

