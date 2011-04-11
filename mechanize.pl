#!/usr/bin/perl


# Do football tips on website footytips.com.au

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

foreach (@tmp_content) {
    if (/\?ff=Tips/i) {
        /href=\"(.+)\" title=\"Edit tips\" class=\"ft_icon16EditTips\"/i;
        $m->get("http://www.footytips.com.au" . $1);
        last if $m->success;
    }
}

@tmp_content = split "\n", $m->content;
my $margin = 22;
my $margin_textfield_name = "Margin";

my @arr = ('collingwood', 'western bulldogs', 'fremantle', 'hawthorn', 'west coast eagles', 'melbourne', 'geelong', 'essendon');
my $teams = join "|", @arr; 
my @id_for_tips;
my $tmp;

#$mech->set_fields('one_of_two_options'=>'option_b')
#<input id="Margin" class="ftform" type="text" size="3" value="22" name="Margin">
#insert margin into this text field
#<input id="match18Home" type="radio" checked="" value="19" name="MATCH18">
#(extract value and name from above)
#$m->set_fields(MATCH21 => 27);
foreach (@tmp_content) {
    if (/for=\"(.*)\">($teams)<\/label>/i) {
        $tmp = $1;
        foreach my $c (@tmp_content) {
            if ($c =~ /id=\"$tmp\"/) {
                $c =~ /name=\"(.+)\" value=\"(.+)\"/i;
                push @id_for_tips, {name => $1, value => $2};
            }
        }
    }
}

$m->set_fields($margin_textfield_name => $margin);
foreach (@id_for_tips) {
    $m->set_fields($_->{name} => $_->{value});
}

$m->click_button(name => 'saveTips');
