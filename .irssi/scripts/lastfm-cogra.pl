use Irssi;
use vars qw($VERSION %IRSSI);
use LWP::Simple;

use utf8;
use Text::Unidecode;
use Encode;

$VERSION = "1.0.1";
%IRSSI = (
    authors => 'Marcin Rataj',
    name => 'lastfm-cogra',
    description => 'Returns recently played track from last.fm user profile with unicode2ascii transliteration',
    license => 'public domain',
    url => 'https://github.com/lidel/dotfiles/tree/master/.irssi/scripts'
);

# usage:
# cogram lastfm_login

my @WHAT_ME  = 'cogram'; # keyword used when you ask about yourself (no parameter required, your nick is used)
my @WHAT_ONE = 'cogra';  # ...someone else (takes parameter: last.fm login or an alias from ROUTES is used)

my @LASTFM_API_KEY = 'get one from http://www.last.fm/api/account'
my %ROUTES = ( # sometimes people want an alias..
    'alias' => 'lastfm_username',
    'short' => 'longlogin2435',
);

sub event_privmsg {
    my ($server, $data, $nick, $mask, $target) =@_;
    my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;

    if ($text =~ /@WHAT_ME|@WHAT_ONE/i ) {
        if ($text =~ /@WHAT_ME/i) {
            ($ktogra) = $nick
        } else {
            ($ktogra) = $text =~/cogra (.*)$/;
        }
        if (exists( $ROUTES{ $ktogra } )) {
            $ktogra = $ROUTES{ $ktogra };
        }

        $last_fm = get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${ktogra}&api_key=@{LASTFM_API_KEY}&limit=1");
        ($last_band) = $last_fm =~ /<artist.*>(.+)<\/artist>/;
        ($last_track) = $last_fm =~ /<name>(.+)<\/name>/;

        if ($last_band) {
            $last_band = unidecode(decode_utf8($last_band));
            $last_track = unidecode(decode_utf8($last_track));
            ($last_nowplay) = $last_fm =~ /<track nowplaying="(.*)">/; # is it realtime?
            $last_track =~ s/&quot;/\"/g; # unescape
            $last_track =~ s/&amp;/&/g;
            $last_band =~ s/&quot;/\"/g;
            $last_band =~ s/&amp;/&/g;
            $cogra = "${last_band} - ${last_track}";

            if ( $last_fm =~ /<track nowplaying="true">/) {
                $server->command ("msg $target $ktogra is now playing: $cogra"); # feel free to customize this
            } else {
                $server->command ("msg $target $ktogra played: $cogra"); # and this
            }
        } else {
            $server->command ("msg $target plays nothing :<"); # and this
        }
    }
}

Irssi::signal_add('event privmsg', 'event_privmsg');
# vim: ts=4 et sw=4
