package footytips;

use Dancer ':syntax';
use Footy::WebService;
use Template;
use Dancer::Plugin::Database;
use Time::Format qw(%time);
use Data::Dumper;
use Footy::Schema;

our $VERSION = '0.1';
my $service = Footy::WebService->new();
$service->new_service();

sub get_schema {

  my $database = 'test';
  my $hostname = 'localhost';
  my $user = 'root';
  my $password = 'brodie123';
  my $schema = Footy::Schema->connect("DBI:mysql:database=$database;host=$hostname", $user, $password);
  return $schema;
}

post '/tipping_accounts' => sub {
    
    my $add_accounts = $service->__add_tipping_account(session('username'), params->{'comp'}, params->{'login_info'}, params->{'password'}, params->{'group'});
    
    redirect '/tipping_accounts';
  
};

get '/tipping_accounts' => sub {
  my $schema = get_schema();  
  my @sites = $schema->resultset('TippingWebsite')->all;

  my $rs = $schema->resultset('UserLogin')->search({username => session('username')});
  my $user = $rs->first;
  
  my $rs = $schema->resultset('TippingGroup')->search({user_id => $user->user_id});
  my %groups;

  while (my $group = $rs->next) {
      if (!exists($groups{$group->group_name})) {
          $groups{$group->group_name} = $group->group_name;
      }
  }

  my @get_accounts = $service->__user_tipping_accounts(session('username'));
  
  template 'tipping_accounts', { 'websites' => \@sites, 'groups' => \%groups, 'current_accounts' => @get_accounts };
};

get '/tips' => sub {
  template 'tips';
};
get '/test_design' => sub {
   template 'dev/test.html';
};
post '/tips' => sub {
    my $login = $service->__autotip('default', session('username'), params->{'margin'}, params->{'tips'});
    
    if ($login) {
        template 'tips', {'msg' => "Successfully tipped!"};
    } else {
        template 'tips', {'msg' => "Error tipping. try again"};
    }
};

post '/login' => sub {

 my $login = $service->__login(params->{'username'}, params->{'password'}); 
 
 if (!$login) {
   template 'login', {'msg' => "Login failed for " . params->{'username'} . " .. " };
 } else {
   session logged_in => 1;
   session username => params->{'username'};
   redirect '/';
 }

};

get '/login' => sub {
  template 'login'; 
};

post '/create_account' => sub {
  
  my $msg = $service->__create_account(params->{'username'}, params->{'password'}, params->{'email'});
  
  template 'create_account', {'msg' => $msg };
};

get '/create_account' => sub {
  template 'create_account'; 
};

get '/' => sub {
    template 'index';
};

true;
