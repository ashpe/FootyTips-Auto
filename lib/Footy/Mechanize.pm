package Footy::Mechanize;

use Modern::Perl;
use WWW::Mechanize;
use Storable;
use Data::Dumper;


sub footytips {

    my ($self, $username, $password, $margin, @tips) = @_;

    my $margin_textfield_name = "Margin";
    my $url = 'http://www.footytips.com.au';
    my $m = WWW::Mechanize->new();


    $m->get($url);
    my $content = $m->content;

    $m->submit_form(
        form_number => 1,
        fields      => { 'userLogin' => $username, 'userPassword' => $password },
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

    my $teams = join "|", @tips; 
    my @id_for_tips;
    my $tmp;

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
    return 1;
}


1;