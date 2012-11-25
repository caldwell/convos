package Mojo::IRC;

=head1 NAME

Mojo::IRC - IRC Client for the Mojo IOLoop

=head1 SYNOPSIS

  my $irc = Mojo::IRC->new(
              nick => 'test123',
              user => 'my name',
              server => 'irc.perl.org:6667',
            );

  $irc->on(irc_join => sub {
    my($self, $message) = @_;
    warn "yay! i joined $message->{params}[0]";
  });

  $irc->on(irc_privmsg => sub {
    my($self, $message) = @_;
    say $message->{prefix}, " said: ", $message->{params}[1];
  });

  $irc->connect(sub {
    my($irc, $err) = @_;
    return warn $err if $err;
    $irc->write(join => '#mojo');
  });

  Mojo::IOLoop->start;

=head1 DESCRIPTION

This class inherit from L<Mojo::EventEmitter>.

TODO:

  * Authentication with password
  * SSL
  * use IRC::Utils qw/ decode_irc /;

=head1 EVENTS

=head2 irc_close

  $self->$callback;

Called when the client has closed the connection.

=head2 irc_error

This event is used by IRC errors

=head2 error

Internal errors with the mojo ioloop

=head2 irc_err_nicknameinuse

=head2 irc_join

  $self->$callback({
    params => ['#html'],
    raw_line => ':somenick!~someuser@1.2.3.4 JOIN #html',
    command => 'JOIN',
    prefix => 'somenick!~someuser@1.2.3.4'
  });

=head2 irc_nick

  $self->$callback({
    params => ['newnick'],
    raw_line => ':oldnick!~someuser@hostname.com MODE somenick :+i',
    command => 'NICK',
    prefix => 'somenick!~someuser@hostname.com'
  });

=head2 irc_mode

  $self->$callback({
    params => ['somenick', '+i'],
    raw_line => ':somenick!~someuser@hostname.com MODE somenick :+i',
    command => 'MODE',
    prefix => 'somenick!~someuser@hostname.com'
  });

=head2 irc_notice

  $self->$callback({
    params => ['somenick', 'on 1 ca 1(4) ft 10(10)'],
    raw_line => ':Zurich.CH.EU.Undernet.Org NOTICE somenick :on 1 ca 1(4) ft 10(10)',
    command => 'NOTICE',
    prefix => 'Zurich.CH.EU.Undernet.Org',
  });

=head2 irc_ping

  $self->$callback({
    params => [2687237629],
    raw_line => 'PING :2687237629',
    command => 'PING',
  })

=head2 irc_privmsg

=head2 irc_rpl_created

  $self->$callback({
    params => ['somenick', 'This server was created Thu Jun 21 2012 at 01:26:15 UTC'],
    raw_line => ':Tampa.FL.US.Undernet.org 003 somenick :This server was created Thu Jun 21 2012 at 01:26:15 UTC',
    command => '003',
    prefix => 'Tampa.FL.US.Undernet.org'

  });

=head2 irc_rpl_endofmotd

=head2 irc_rpl_endofnames

  $self->$callback({
    params => ['somenick', '#channel', 'End of /NAMES list.'],
    raw_line => ':Budapest.Hu.Eu.Undernet.org 366 somenick #channel :End of /NAMES list.',
    command => '366',
    prefix => 'Budapest.Hu.Eu.Undernet.org'
  });

=head2 irc_rpl_isupport

  $self->$callback({
    params => ['somenick', 'WHOX', 'WALLCHOPS', 'WALLVOICES', 'USERIP', 'CPRIVMSG', 'CNOTICE', 'SILENCE=25', 'MODES=6', 'MAXCHANNELS=20', 'MAXBANS=50', 'NICKLEN=12', 'are supported by this server'],
    raw_line => ':Tampa.FL.US.Undernet.org 005 somenick WHOX WALLCHOPS WALLVOICES USERIP CPRIVMSG CNOTICE SILENCE=25 MODES=6 MAXCHANNELS=20 MAXBANS=50 NICKLEN=12 :are supported by this server',
    command => '005',
    prefix => 'Tampa.FL.US.Undernet.org'
  })

=head2 irc_rpl_luserchannels

  $self->$callback({
    params => ['somenick', '13700', 'channels formed'],
    raw_line => ':Tampa.FL.US.Undernet.org 254 somenick 13700 :channels formed',
    command => '254',
    prefix => 'Tampa.FL.US.Undernet.org'
  })

=head2 irc_rpl_luserclient

  $self->$callback({
    params => ['somenick', 'There are 3400 users and 46913 invisible on 18 servers'],
    raw_line => ':Tampa.FL.US.Undernet.org 251 somenick :There are 3400 users and 46913 invisible on 18 servers',
    command => '251',
    prefix => 'Tampa.FL.US.Undernet.org'
  });

=head2 irc_rpl_luserme

  $self->$callback({
    params => ['somenick', 'I have 12000 clients and 1 servers'],
    raw_line => ':Tampa.FL.US.Undernet.org 255 somenick :I have 12000 clients and 1 servers',
    command => '255',
    prefix => 'Tampa.FL.US.Undernet.org'
  });

=head2 irc_rpl_luserop

  $self->$callback({
    params => ['somenick', '19', 'operator(s) online'],
    raw_line => ':Tampa.FL.US.Undernet.org 252 somenick 19 :operator(s) online',
    command => '252',
    prefix => 'Tampa.FL.US.Undernet.org'
  });

=head2 irc_rpl_luserunknown

  $self->$callback({
    params => ['somenick', '305', 'unknown connection(s)'],
    raw_line => ':Tampa.FL.US.Undernet.org 253 somenick 305 :unknown connection(s)',
    command => '253',
    prefix => 'Tampa.FL.US.Undernet.org'
  })

=head2 irc_rpl_motd

=head2 irc_rpl_motdstart

=head2 irc_rpl_myinfo

  $self->$callback({
    params => ['somenick', 'Tampa.FL.US.Undernet.org', 'u2.10.12.14', 'dioswkgx', 'biklmnopstvrDR', 'bklov'],
    raw_line => ':Tampa.FL.US.Undernet.org 004 somenick Tampa.FL.US.Undernet.org u2.10.12.14 dioswkgx biklmnopstvrDR bklov',
    command => '004',
    prefix => 'Tampa.FL.US.Undernet.org',
  })

=head2 irc_rpl_namreply

  $self->$callback({
    params => ['somenick', '=', '#html', 'somenick Indig0 Wildblue @HTML @CSS @Luch1an @Steaua_ Indig0_ Pilum @fade'],
    raw_line => ':Budapest.Hu.Eu.Undernet.org 353 somenick = #html :somenick Indig0 Wildblue @HTML @CSS @Luch1an @Steaua_ Indig0_ Pilum @fade',
    command => '353',
    prefix => 'Budapest.Hu.Eu.Undernet.org'
  })

=head2 irc_rpl_welcome

  $self->$callback({
    params => ['somenick', 'Welcome to the UnderNet IRC Network, somenick'],
    raw_line => ':Zurich.CH.EU.Undernet.Org 001 somenick :Welcome to the UnderNet IRC Network, somenick',
    command => '001',
    prefix => 'Zurich.CH.EU.Undernet.Org'
  })

=head2 irc_rpl_yourhost

  $self->$callback({
    params => ['somenick', 'Your host is Tampa.FL.US.Undernet.org, running version u2.10.12.14'],
    raw_line => ':Tampa.FL.US.Undernet.org 002 somenick :Your host is Tampa.FL.US.Undernet.org, running version u2.10.12.14',
    command => '002',
    prefix => 'Tampa.FL.US.Undernet.org'
  });

=cut

use Mojo::Base 'Mojo::EventEmitter';
use Mojo::IOLoop;
use IRC::Utils;
use Parse::IRC ();
use Scalar::Util 'weaken';
use constant DEBUG => $ENV{MOJO_IRC_DEBUG} ? 1 : 0;

my $TIMEOUT = 60;
my @DEFAULT_EVENTS = qw/ irc_ping irc_nick irc_notice irc_rpl_welcome irc_err_nicknameinuse/;

=head1 ATTRIBUTES

=head2 ioloop

Holds an instance of L<Mojo::IOLoop>.

=cut

has ioloop => sub { Mojo::IOLoop->singleton };

=head2 nick

IRC server nickname. Will also change the nick in the server if this attribute
is changed and we are connected to the IRC server.

=cut

sub nick {
  my ($self,$nick) = @_;
  my $old = $self->{nick} // '';

  return $old unless defined $nick;
  return $self if $old && $old eq $nick;
  $self->{nick} = $nick;
  $self->write(NICK => $nick) if $self->{stream};
  $self;
}

=head2 real_host

Will be set by L</irc_rpl_welcome>. Holds the actual hostname of the IRC
server that we are connected to.

=cut

has real_host => '';

=head2 user

IRC username.

=cut

has user => '';

=head2 server

Server name and optionally a port to connect to. Changing this while connected
to the IRC server will issue a reconnect.

=cut

sub server {
  my ($self,$server) = @_;
  my $old = $self->{server} || '';

  return $old unless defined $server;
  return $self if $old && $old eq $server;
  $self->{server} = $server;
  $self->disconnect(sub { $self->connect(sub {}) });
  $self;
}

=head2 name

The name of this IRC client. Defaults to "Mojo IRC".

=cut

has name => 'Mojo IRC';

=head2 pass

Password for authentication

=cut

has 'pass';

=head1 METHODS

=head2 connect

  $self->connect(\&callback);

Will login to the IRC L</server> and call C<&callback> once connected. The
L</error> event will be called if connect fail in any way.

=cut

sub connect {
  my ($self, $callback) = @_;
  my ($host, $port) = split /:/, $self->server;

  if ($self->{stream_id}) {
    return $self->$callback;
  }

  $self->register_default_event_handlers;

  weaken $self;
  $self->{stream_id} = $self->ioloop->client(
    address => $host,
    port    => $port || 6667,
    sub {
      my ($loop, $err, $stream) = @_;
      my ($method, $message);
      my $buffer = '';

      $err and return $self->emit(error => $err);

      $stream->timeout($TIMEOUT);
      $stream->on(
        close => sub {
          warn "[@{[$self->server]}] : close\n" if DEBUG;
          $self or return;
          $self->emit('close');
          delete $self->{stream};
          delete $self->{stream_id};
        }
      );
      $stream->on(
        error => sub {
          $self or return;
          $self->ioloop->remove(delete $self->{stream_id});
          $self->emit(error => $_[1]);
          delete $self->{stream};
          $self->ioloop
        }
      );
      $stream->on(
        read => sub {
          $buffer .= $_[1];

          while ($buffer =~ s/^([^\r\n]+)\r\n//m) {
            warn "[@{[$self->server]}] >>> $1\n" if DEBUG;
            $message = Parse::IRC::parse_irc($1);
            $method = $message->{command} || '';

            if ($method =~ /^\d+$/) {
              $method = IRC::Utils::numeric_to_name($method);
            }

            $self->emit_safe(lc 'irc_'.$method => $message);
          }
        }
      );

      $self->{stream} = $stream;
      $self->write(NICK => $self->nick);
      $self->write(USER => $self->user, 8, '*', ':'.$self->name);
      $self->write(PASS=> $self->pass) if $self->pass;
      $self->$callback;
    }
  );
}

=head2 disconnect

  $self->disconnect($callback);

Will disconnect form the server and run the callback once it is done.

=cut

sub disconnect {
  my($self, $cb) = @_;

  if(my $tid = delete $self->{ping_tid}) {
    $self->ioloop->remove($tid);
  }
  if(!$self->{stream}) {
    return $self->$cb;
  }

  $self->{stream}->write("QUIT\r\n", sub {
    $self->{stream}->close;
    $self->$cb;
  });
}

=head2 register_default_event_handlers

  $self->register_default_event_handlers;

This method sets up the default L</DEFAULT EVENT HANDLERS> unless someone has
already subscribed to the event.

=cut

sub register_default_event_handlers {
  my $self = shift;

  weaken $self;
  for my $event (@DEFAULT_EVENTS) {
    next if $self->has_subscribers($event);
    $self->on($event => $self->can($event));
  }
}

=head2 write

  $self->write(@str);

This method writes a message to the IRC server. C<@str> will be concatenated
with " " and "\r\n" will be appended.

=cut

sub write {
  my $self = shift;
  my $buf = join ' ', @_;
  warn "[@{[$self->server]}] <<< $buf\n" if DEBUG;
  $self->{stream}->write("$buf\r\n");
}

=head1 DEFAULT EVENT HANDLERS

=head2 irc_nick

Used to update the L</nick> attribute when the nick has changed.

=cut

sub irc_nick {
  my ($self, $message) = @_;
  my $old_nick = ($message->{prefix} =~ /^(.*?)!/)[0] || '';

  if($old_nick eq $self->nick) {
    $self->nick($message->{params}[0]);
  }
}

=head2 irc_notice

Responds to the server with "QUOTE PASS ..." if the notice contains "Ident
broken...QUOTE PASS...".

=cut

sub irc_notice {
  my ($self, $message) = @_;

  # NOTICE AUTH :*** Ident broken or disabled, to continue to connect you must type /QUOTE PASS 21105
  if ($message->{params}[0] =~ m!/Ident broken.*QUOTE PASS (\S+)!) {
    $self->write(QUOTE => PASS => $1);
  }
}

=head2 irc_ping

Responds to the server with "PONG ...".

=cut

sub irc_ping {
  my ($self, $message) = @_;
  $self->write(PONG => $message->{params}[0]);
}

=head2 irc_rpl_welcome

Used to get the hostname of the server. Will also set up automatic PING
requests to prevent timeout.

=cut

sub irc_rpl_welcome {
  my ($self, $message) = @_;

  Scalar::Util::weaken($self);
  $self->real_host($message->{prefix});
  $self->{ping_tid} = $self->ioloop->timer($TIMEOUT - 10, sub {
    $self->write(PING => $self->real_host);
  });
}

=head2 irc_err_nicknameinuse

Tries to register with the same nick as L</nick>, only with an extra underscore
added. The new nick will be stored in L</nick>.

=cut

sub irc_err_nicknameinuse {
  my ($self, $message) = @_;

  $self->nick($self->nick . '_');
  $self->write(NICK => $self->nick);
}

sub DESTROY {
  my $self = shift;
  my $ioloop = $self->ioloop or return;
  my $tid = $self->{ping_tid};
  my $sid = $self->{stream_id};

  $ioloop->remove($sid) if $sid;
  $ioloop->remove($tid) if $tid;
}

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 AUTHOR

Marcus Ramberg - C<mramberg@cpan.org>

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut

1;
