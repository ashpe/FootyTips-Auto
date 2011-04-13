package footytips;

use Dancer ':syntax';
use Footy::WebService;
use Template;
use Dancer::Plugin::Database;
use Time::Format qw(%time);
use Data::Dumper;

our $VERSION = '0.1';
my $service = Footy::WebService->new();
$service->new_service();

sub connect_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=footydata", {AutoCommit => 0});
    return $dbh;
}

post '/tipping_accounts' => sub {

  open my $fh, '<', 'public/supported_sites.txt';
  my $sites = <$fh>;
  my @split_sites = split ':', $sites;
  
  my $db = connect_db();
  $db->begin_work();
  my $sql = "select * from users_accounts where username=?";
  my $sth = $db->prepare($sql);

  $sth->execute(session('username'));
  my $user = $sth->fetch;

  $db->commit();
  
  my $login_info = params->{'comp'} . ':' . params->{'login_info'} . ":" . params->{'password'};
 
  if (!$user) {
    $db = connect_db();
    $db->begin_work();
    $sql = "insert into users_accounts values(?, ?, ?)";
    $sth = $db->prepare($sql);
   
    $sth->execute(session('username'), 1, $login_info);
    $db->commit();
    template 'tipping_accounts', { 'options' => \@split_sites, 'current_accounts' => "blah" };
  } else {
    $db = connect_db();
    $db->begin_work();
    $sql = "update users_accounts SET account_info=? WHERE username=?";

    $sth = $db->prepare($sql);
    my $new_login_info = $login_info . ':' . $user->[2];

    $sth->execute($new_login_info, session('username'));
    $db->commit();
    redirect '/tipping_accounts';
  }
};

get '/tipping_accounts' => sub {
  open my $fh, '<', 'public/supported_sites.txt';
  my $sites = <$fh>;
  my @split_sites = split ':', $sites;
  
  my $db = connect_db();
  $db->begin_work();
  my $sql = "select * from users_accounts where username=?";
  my $sth = $db->prepare($sql);

  $sth->execute(session('username'));
  my $user = $sth->fetch;

  $db->commit();
  
  template 'tipping_accounts', { 'options' => \@split_sites, 'current_accounts' => $user };
};

get '/tips' => sub {
  template 'tips';
};
get '/test_design' => sub {
   template 'dev/test.html';
};
post '/tips' => sub {
    my $login = $service->__autotip('footytips.com.au:ashpe:brodie123');

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
