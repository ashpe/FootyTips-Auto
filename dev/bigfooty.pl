#!/usr/bin/perl

use Modern::Perl;
use WWW::Mechanize;
use Storable;
use Data::Dumper;

my $url = 'http://www.bigfooty.com/tips/';
my $m = WWW::Mechanize->new();
$m->get($url);

my $content = $m->content;

my $login_field = "passname";
my $pass_field = "passin";

$m->set_fields($login_field => 'username');
$m->set_fields($pass_field => 'password');
$m->click_button(name => 'login');

die unless $m->success;

my @tmp_content = $m->content;

my @arr = ('collingwood', 'adelaide', 'fremantle', 'hawthorn',  'melbourne', 'geelong', 'essendon');
my $margin = 50;
my $teams = join "|", @arr;
my @id_for_tips;
my $margin_id;


foreach (@tmp_content) {
    while (/name="(.+)" value="(.+)"> ($teams) /ig) {
        push @id_for_tips, {name => $1, value => $2};
    }
    if (/input type="text" name="breaker_(.+)" value/i) {
        $margin_id = "breaker_" . $1;
    }
}

$m->set_fields($margin_id, $margin);

foreach (@id_for_tips) {
    $m->set_fields($_->{name} => $_->{value});
}

$m->click_button(name => 'Action');

