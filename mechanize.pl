#!/usr/bin/perl


use Modern::Perl;
use WWW::Mechanize;
use Storable;
use Data::Dumper;

my $url = 'http://www.footytips.com.au';
my $m = WWW::Mechanize->new();
$m->get($url);

my $content = $m->content;

$m->submit_form(
    form_number => 1,
    fields      => { 'userLogin' => 'ashpe', 'userPassword' => 'brodie123' },
);

die unless $m->success;
$url = 'http://www.footytips.com.au/tipping/afl/';
$m->get($url);

my @tmp_content = split "\n", $m->content;
my @arr = ('collingwood', 'western bulldogs', 'adelaide', 'hawthorn', 'west coast eagles', 'melbourne', 'geelong', 'essendon');

my $teams = join "|", @arr; 
my @id_for_tips;

#$mech->set_fields('one_of_two_options'=>'option_b')
#<input id="Margin" class="ftform" type="text" size="3" value="22" name="Margin">
#insert margin into this text field
#<input id="match18Home" type="radio" checked="" value="19" name="MATCH18">
#(extract value and name from above)
#$m->set_fields(MATCH21 => 27);
foreach (@tmp_content) {
    if (/for=\"(.*)\">($teams)<\/label>/i) {
        push @id_for_tips, $1;
    } elsif (/id=\"$id_for_tips[0]\"/) {
        /name=\"(.*)\"/i;
        print "First: $1\n";
        /value=\"(.*)\"/i;
        print "Second: $1\n";
        #print "$_\n\n";
    }
}

$m->click_button(name => 'saveTips');

print "\n";
print Dumper(@id_for_tips);


