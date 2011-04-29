package footytips;

use Dancer ':syntax';
use Footy::WebService;
use Template;
use Time::Format qw(%time);
use Data::Dumper;

our $VERSION = '0.1';
my $service = Footy::WebService->new();
$service->new_service();

post '/tipping_accounts' => sub {

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

    my $groups = $service->__get_groups( session('username') );
    template 'tips', { 'groups' => $groups };

};

get '/test_design' => sub {

    template 'dev/test.html';

};

post '/tips' => sub {
    my $groups = $service->__get_groups( session('username') );
    my $login = $service->__autotip(
        params->{'group'},  session('username'),
        params->{'margin'}, params->{'tips'}
    );
	
    my $msg;
    if ($login) {
   	$msg = "Successfully tipped!";
    }
    else {
	$msg = "Tipping failed, try again..";
    }

    template 'tips', { 'groups' => $groups, 'msg' => $msg };
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
