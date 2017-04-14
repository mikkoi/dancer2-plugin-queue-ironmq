## no critic (Documentation::RequirePodAtEnd)
## no critic (Documentation::RequirePodSections)
## no critic (ControlStructures::ProhibitPostfixControls)
## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)

package Dancer2::Plugin::Queue::IronMQ;
use strict;
use warnings;
use 5.008001;

# ABSTRACT: Dancer2::Plugin::Queue backend using IronMQ
# VERSION:

=pod

=encoding utf8

=for stopwords UUID_V1 IronMQ JSON config

=cut

=for Pod::Coverage UUID_V1

=cut

# Dependencies
use Moose;
# use MooX::Types::MooseLike::Base qw/Str HashRef/;

use UUID::Tiny qw{ create_uuid_as_string UUID_V1 };
use IO::Iron::IronMQ::Client 0.12;
use IO::Iron::IronMQ::Queue 0.12;
use IO::Iron::IronMQ::Message 0.12;

use Const::Fast;
const my $RANDOM_STRING_LENGTH => 12;

with 'Dancer2::Plugin::Queue::Role::Queue';

=attr config

IronMQ uses a JSON config file to hold the project_id and token,
and other config items if necessary. By default F<iron.json>.
These config items can also be written individually under I<connection_options>.
Must be supplied.

=cut

has config => (
  is      => 'ro',
  isa     => 'Str',
  default => 'iron.json',
);

=attr queue

Name of the queue. Must be supplied.

=cut

has queue => (
  is      => 'ro',
  isa     => 'Str',
  required => 1,
);

=attr timeout

After timeout (in seconds), item will be placed back onto queue.
You must delete the message from the queue to ensure it does not
go back onto the queue. If not set, value from queue is used.
Default is 60 seconds, minimum is 30 seconds,
and maximum is 86,400 seconds (24 hours).

=cut

has timeout => (
  is      => 'ro',
  isa     => 'Str',
  default => '60',
);

=attr wait

Time to long poll for messages, in seconds. Max is 30 seconds. Default 0.

=cut

has wait => (
  is      => 'ro',
  isa     => 'Str',
  default => '0',
);

#The IO::Iron::IronMQ::Queue object that manages the ironmq_queue.  Built on demand from
#other attributes.
has _ironmq_queue => (
  is         => 'ro',
  isa        => 'IO::Iron::IronMQ::Queue',
  lazy_build => 1,
);

sub _build__ironmq_queue {
  my ($self) = @_;
  return $self->_ironmq_client->create_and_get_queue(
    'name' => $self->queue );
}

has _ironmq_client => (
  is         => 'ro',
  isa        => 'IO::Iron::IronMQ::Client',
  lazy_build => 1,
);

sub _build__ironmq_client {
  my ($self) = @_;
  return IO::Iron::IronMQ::Client->new( 'config' => $self->config );
}

sub add_msg {
  my ( $self, $data ) = @_;
  my $msg = IO::Iron::IronMQ::Message->new( 'body' => $data );
  $self->_ironmq_queue->post_messages( 'messages' => [ $msg ] );
  return;
}

sub get_msg {
  my ($self) = @_;
  my %options;
  $options{'timeout'} = $self->timeout if defined $self->timeout;
  $options{'wait'}    = $self->wait    if defined $self->wait;
  my ($msg) = $self->_ironmq_queue->reserve_messages( 'n' => 1, %options );
  return ( $msg, $msg->body() );
}

sub remove_msg {
  my ( $self, $msg ) = @_;
  $self->_ironmq_queue->delete_message( 'message' => $msg );
  return;
}

1;

__END__

=for Pod::Coverage add_msg get_msg remove_msg

=head1 SYNOPSIS

  # in config.yml

  plugins:
    Queue:
      default:
        class: IronMQ
        options:
          config: <iron json cfg file>
          queue: <queue-name>
          timeout: <seconds>
          wait: <seconds>

  # in Dancer2 app

  use Dancer2::Plugin::Queue;

  get '/' => sub {
    queue->add_msg( $data );
  };

=head1 DESCRIPTION

This module implements a L<Dancer2::Plugin::Queue|Dancer2::Plugin::Queue>
using L<IO::Iron::IronMQ::Client|IO::Iron::IronMQ::Client>.

=head1 USAGE

See documentation for L<Dancer2::Plugin::Queue|Dancer2::Plugin::Queue>.

=head1 SEE ALSO

=for :list
* L<Dancer2::Plugin::Queue|Dancer2::Plugin::Queue>
* L<IO::Iron|IO::Iron>
* L<IO::Iron::Applications|IO::Iron::Applications>

=cut

# vim: ts=2 sts=2 sw=2 et:

