package footytips;

use Dancer ':syntax';
use Footy::WebService;
use Template;
use Time::Format qw(%time);
use Data::Dumper;
use YAML::XS qw(LoadFile);

our $VERSION = '0.1';
my $service = Footy::WebService->new();
$service->new_service();

post '/tipping_accounts' => sub {
    
    if (params->{'group_name'}) {
	my $group = $service->__add_group( session('username'), params->{'group_name'} );
    }
    my $add_accounts = $service->__add_tipping_account(
        session('username'),    params->{'comp'},
        params->{'login_info'}, params->{'password'},
        params->{'group'}
    );
    
    redirect '/tipping_accounts';

};

get '/tipping_accounts' => sub {

    my $sites = $service->__get_websites();
    my $groups= $service->__get_groups( session('username') );

    my @get_accounts = $service->__user_tipping_accounts( session('username') );

    template 'tipping_accounts',
      {
        'websites'         => $sites,
        'groups'           => $groups,
        'current_accounts' => @get_accounts
      };
};

get '/tips' => sub {

    my $current_round = LoadFile('public/fixture_current_round.yaml'); 
    my $groups = $service->__get_groups( session('username') );
    template 'tips', { 'groups' => $groups, 'current_round' => $current_round };

};

get '/test_design' => sub {

    template 'dev/test.html';

};

post '/add_group' => sub {

    my $add_group = $service->__add_group( session('username'), params->{'group_name'} );
    redirect '/tipping_accounts';

};

post '/tips' => sub {

    my $groups = $service->__get_groups( session('username') );
    my @tips;

    for my $x (0 .. 7) {
	if (params->{'match' . $x}) {
		push @tips, params->{'match' . $x};	
	}
    }
	
    my $tips_string = join "|", @tips;    
    $tips_string =~ s/sydney/sydney swans/i;

    $service->__autotip(
        params->{'group'},  session('username'),
        params->{'margin'}, $tips_string
    );
    my $msg = "Tipped successfully."; 
    my $current_round = LoadFile('public/fixture_current_round.yaml'); 
    template 'tips', { 'groups' => $groups, 'msg' => $msg, 'current_round' => $current_round };
};

post '/login' => sub {

    my $login = $service->__login( params->{'username'}, params->{'password'} );

    if ( !$login ) {
        template 'login',
          { 'msg' => "Login failed for " . params->{'username'} . " .. " };
    }
    else {
        session logged_in => 1;
        session username  => params->{'username'};
        redirect '/';
    }

};

get '/login' => sub {
    template 'login';
};

post '/create_account' => sub {

    my $msg =
      $service->__create_account( params->{'username'}, params->{'password'},
        params->{'email'} );

    template 'create_account', { 'msg' => $msg };
};

get '/create_account' => sub {
    template 'create_account';
};

get '/' => sub {
    template 'index';
};

true;
