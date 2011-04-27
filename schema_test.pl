#!/usr/bin/perl

use Footy::Mechanize;
use Footy::Schema;
use Data::Dumper;

my $database = 'test';
my $hostname = 'localhost';
my $user = 'root';
my $password = 'brodie123';

sub get_schema {

  my $schema = Footy::Schema->connect("DBI:mysql:database=$database;host=$hostname", $user, $password);
  return $schema;

}

my $schema = get_schema();

my $usr = 'ashpe';
my $group_name = 'default';
my $margin = '123';
my @tips = ['collingwood'];



my $rs = $schema->resultset('UserLogin')->search({username => $usr});
my $user = $rs->first;

$rs = $schema->resultset('TippingGroup')->search({
        user_id => $user->user_id,
        group_name => $group_name,
    });

my $group = $rs->first;

$rs = $schema->resultset('UserTippingAccount')->search({
        user_id => $user->user_id,
        group_id => $group->group_id,
    });

while (my $account = $rs->next) {
      
       print $account->tipping_password, "\n";
       print $margin, "\n";
       print Dumper(@tips);
       Footy::Mechanize->footytips($account->tipping_username,
                                   $account->tipping_password,
                                   $margin,
                                   @tips,
                           );
}

__END__

my $schema = get_schema();
my $group_name = 'default';
my $usr = 'ashpe';
my $group_name = 'default';

my $rs = $schema->resultset('UserLogin')->search({
        username => $usr,
    });

my $user = $rs->first;
    

print "USERID: " . $user->user_id;
my $rs = $schema->resultset('TippingGroup')->search({
        group_name => $group_name,
        user_id => $user->user_id,
    });

my $group = $rs->first;

print "\nGROUPID: " . $group->group_id;

__END__
my $group_id = $schema->resultset('TippingGroup')->search({group_name => $group_name})->group_id;

print $group_id;

__END__

my $rs = $schema->resultset('TippingWebsite')->all;

print Dumper($rs);


__END__
my $usr = 'test';
my $pwd = 'onetwothree';
my $email = 'abc';


my $rs = $schema->resultset('UserLogin')->search({username => $usr});

my $user = $rs->first;

if (!$user) {

my $new_user = $schema->resultset('UserLogin')->create({
                                        username => $usr,
                                        password => $pwd,
                                        email    => $email,
                                        status   => 'inactive',
                                 });
} else {
     print $user->username;
}

__END__

my $schema = Footy::Schema->connect('dbi:mysql:test', 'root', 'brodie123');

my $user_tipping_account = $schema->resultset('UserTippingAccount')->find(1);

my $website = $user_tipping_account->website;

print $website->website_name, "\n";
