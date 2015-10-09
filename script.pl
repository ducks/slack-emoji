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
  'satisfied' => "\N{SMILING FACE WITH OPEN MOUTH AND TIGHTLY-CLOSED EYES}",
  'innocent' => "\N{SMILING FACE WITH HALO}",
  'smiling_imp' => "\N{SMILING FACE WITH HORNS}",
  'imp'   => "\N{IMP}",
  'wink' => "\N{WINKING FACE}",
  'blush' => "\N{SMILING FACE WITH SMILING EYES}",
  'relaxed' => "\N{WHITE SMILING FACE}",
  'yum' => "\N{FACE SAVOURING DELICIOUS FOOD}",
  'relieved' => "\N{RELIEVED FACE}",
  'heart_eyes' => "\N{SMILING FACE WITH HEART-SHAPED EYES}",
  'sunglasses' => "\N{SMILING FACE WITH SUNGLASSES}",
  'neutral_face' => "\N{NEUTRAL FACE}",
  'smirk' => "\N{SMIRKING FACE}",
  'expressionless' => "\N{U+1F611}",
  'unamused' => "\N{UNAMUSED FACE}",
  'sweat' => "\N{FACE WITH COLD SWEAT}",
  'pensive' => "\N{PENSIVE FACE}",
  'confused' => "\N{U+1F615}",
  'confounded' => "\N{CONFOUNDED FACE}",
  'kissing' => "\N{U+1F617}",
  'kissing_heart' => "\N{FACE THROWING A KISS}",
  'kissing_smiling_eyes' => "\N{U+1F619}",
  'kissing_closed_eyes' => "\N{KISSING FACE WITH CLOSED EYES}",
  'stuck_out_tongue' => "\N{U+1F61B}",
  'stuck_out_tongue_winking_eyes' => "\N{FACE WITH STUCK-OUT TONGUE AND WINKING EYE}",
  'stuck_out_tongue_closed_eyes' => "\N{FACE WITH STUCK-OUT TONGUE AND TIGHTLY-CLOSED EYES}",
  'disappointed' => "\N{DISAPPOINTED FACE}",
  'worried' => "\N{U+1F61F}",
  'angry' => "\N{ANGRY FACE}",
  'rage' => "\N{POUTING FACE}",
  'cry' => "\N{CRYING FACE}",
  'triumph' => "\N{FACE WITH LOOK OF TRIUMPH}",
  'persevere' => "\N{PERSEVERING FACE}",
  'disappointed_relieved' => "\N{DISAPPOINTED BUT RELIEVED FACE}",
  'frowning' => "\N{U+1F626}",
  'anguished' => "\N{U+1F627}",
  'fearful' => "\N{FEARFUL FACE}",
  'weary' => "\N{U+1F629}",

  '+1'    => "\N{THUMBS UP SIGN}",

  '-1'    => "\N{THUMBS DOWN SIGN}",

  'ok'    => "\N{SQUARED OK}",
  'fist'  => "\N{RAISED FIST}",
  'heart' => "\N{BLACK HEART SUIT}\x{FE0F}",
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
