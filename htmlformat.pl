#!/usr/bin/perl

use Data::Dumper;

require HTML::TreeBuilder;
$tree = HTML::TreeBuilder->new->parse_file("footy_fixture_2011.html");

require HTML::FormatText;
$formatter = HTML::FormatText->new(leftmargin => 0, rightmargin => 50);
my @tmp = split "\n", $formatter->format($tree);

foreach (@tmp) {
  if ( /round/i || /bye\:/i || /day,/i) {
    print "$_\n";
  }
  elsif ( / vs /i) {
    print "$_ ";
  } elsif (/(MCG|Gabba|AAMI\ Stadium|Patersons\ Stadium|Etihad\ Stadium|Aurora\ Stadium|Skilled\ St    adium|Manuka\ Oval|TIO\ Stadium|Gold\ Coast\ Stadium|Cazaly\'s\ Stadium)/i) {
    print "$_\n";
  }
}
print Dumper($tmp);
