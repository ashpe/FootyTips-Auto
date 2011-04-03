package footytips;
use Dancer ':syntax';
use Template;
use Dancer::Plugin::Database;
use Time::Format qw(%time);

our $VERSION = '0.1';

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
  open my $fh, '<', 'public/2011fixture.txt';
  my $date = $time{'Weekday, Month d'};
  my $round;
  foreach (<$fh>) {
    if (/round/i) {
      $round = $_;
      print "$round\n";
    }

    if (/$date/) {
      print "$_\n";
    } 
  }
  
  print "$date\n";
  my $all_tips;
  my $cur_round;
  template 'tips', {'date' => $date, 'cur_tips' => $all_tips, 'cur_round' => $cur_round};

};

post '/login' => sub {
 my $db = connect_db();
 $db->begin_work();

 my $sql = 'select * from users where username=? AND password=?';
 my $sth = $db->prepare($sql);

 $sth->execute(params->{'username'}, params->{'password'});

 my $user = $sth->fetch;
 $db->commit();

 if (!$user) {
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
  
  my $db = connect_db();
  $db->begin_work();

  my $sql = 'insert into users values(?, ?, ?, ?)';
  my $sth = $db->prepare($sql);

  $sth->execute(params->{'username'}, params->{'password'}, params->{'email'}, '0');

  $db->commit();

  template 'create_account', {'msg' => "Email sent. Confirm your account" };

};

get '/create_account' => sub {
  template 'create_account'; 
};

get '/' => sub {
    template 'index';
};

true;
