use warnings;
use strict;

use charnames ':full';
use Irssi ();

our $VERSION = '0.001';
our %IRSSI = (
  authors => 'rjbs',
  name    => 'slack-emoji',
);

my %emoji = (
  'grinning' => "\N{U+1F600}",
  'grin' => "\N{GRINNING FACE WITH SMILING EYES}",
  'joy' => "\N{FACE WITH TEARS OF JOY}",
  'smiley' => "\N{SMILING FACE WITH OPEN MOUTH}",
  'smile' => "\N{SMILING FACE WITH OPEN MOUTH AND SMILING EYES}",
  'sweat_smile' => "\N{SMILING FACE WITH OPEN MOUTH AND COLD SWEAT}",

  '+1'    => "\N{THUMBS UP SIGN}",
  '-1'    => "\N{THUMBS DOWN SIGN}",

  'ok'    => "\N{SQUARED OK}",
  'fist'  => "\N{RAISED FIST}",
  'heart' => "\N{BLACK HEART SUIT}\x{FE0F}",
  'imp'   => "\N{IMP}",
  'poop'  => "\N{PILE OF POO}",
  'rage'  => "\N{POUTING FACE}",
  'wave'  => "\N{WAVING HAND SIGN}",

  'pobox' => "[\N{BLUE HEART}\N{INCOMING ENVELOPE}]",

  'facepunch'   => "\N{FISTED HAND SIGN}",
  'ok_hand'     => "\N{OK HAND SIGN}",
  'pouting_cat' => "\N{POUTING CAT FACE}",
  'coffee' => "\N{HOT BEVERAGE}",
  'snowman' => "\N{SNOWMAN}"
);

sub munge_emoji {
  my ($target, $text) = split / :/, $_[0], 2;
  $text =~ s!:([-+a-z0-9_]+):!$emoji{$1} // ":$1:"!ge;
  return "$target :$text";
}

sub expand_emoji {
  my ($server, $data, $nick, $address) = @_;
  return unless index($server->{chatnet}, 'slack') == -1;

  Irssi::signal_stop();
  Irssi::signal_remove('event privmsg', 'expand_emoji');
  Irssi::signal_emit('event privmsg',
    $server,
    munge_emoji($data),
    $nick,
    $address,
  );
  Irssi::signal_add('event privmsg', 'expand_emoji');
}

Irssi::signal_add('event privmsg'  => 'expand_emoji');
