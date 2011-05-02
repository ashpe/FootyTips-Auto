#!/usr/bin/perl

use Footy::Config;
use Modern::Perl;
use Data::Dumper;
use Date::Manip;
use Time::Format qw(%time);
use YAML::Syck;

my $conf = Footy::Config->load();

my $url = $conf->{get_fixture}{url};
my $year         = $time{'yyyy'};
my $current_date = $time{'yyyymmddhhmmss'};

my $website = "${url}${year}.html";

my @contents = `curl $website`;
my %fixture;

my $teams = join '|',
  qw(Collingwood Geelong Carlton Fremantle Essendon Hawthorn West\sCoast Melbourne Sydney Richmond Western\sBulldogs Adelaide St\sKilda North\sMelbourne Port\sAdelaide Gold\sCoast Brisbane\sLions Bye);

my $venue_regex = join(
    '|', qw(
      Cazaly's\sStadium Docklands\sStadium Football\sPark Gabba
      Gold\sCoast\sStadium Kardinia\sPark Manuka\sOval Marrara\sOval MCG SCG
      Stadium\sAustralia Subiaco\sOval York\sPark
      )
);

my $last;
my $last_round;
my $cur_round;
my $venue;
my $date;
my $match_number; 
foreach (@contents) {

    if (/Round (\d+)/i) {
        $last_round = $1;
        $match_number = 0;
    }
    elsif (/\<b\>(.* Final)\<\/td\>/i) {
        $last_round = $1;
        say "\n$1";
    }

    if (/\<td width\=16\%\>.*>($teams)<\/a>/i) {
        my $match = $1;

        if (/($venue_regex)/i) {
            $venue = $1;
        }

        if (/Bye/i) {
            $last = undef;
            next;
        }
        else {
            if ( !$last ) {
                $last = $match . ' vs ';
            }
            else {
                $fixture{$last_round}[$match_number]{teams} = $last . $match;
                $fixture{$last_round}[$match_number]{date} = $date;
                $fixture{$last_round}[$match_number]{venue} = $venue;
                $last                        = undef;
                $match_number++;
            }
        }
    }

    if (/(\w{3} \d{2}-\w{3}-\d{4})/) {
        $date = ParseDate($1);
        $date =~ s/\://g;

        if ( $date > $current_date && !$cur_round ) {
            $cur_round = $last_round;
        }
    }
}

my $argv = $ARGV[0];

if ($argv =~ /\d+/) {
    DumpFile("fixture_round_${argv}.yaml", \@{$fixture{$argv}});
} elsif ($argv eq 'current') {
    DumpFile("fixture_current_round.yaml", \@{$fixture{$cur_round}});
} else {
    DumpFile("fixture_${year}.yaml", \%fixture);
}

