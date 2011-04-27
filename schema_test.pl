#!/usr/bin/perl

use Footy::Schema;


my $schema = Footy::Schema->connect('dbi:mysql:test_one', 'root', 'brodie123');

my $user_tipping_account = $schema->resultset('UserTippingAccount')->find(1);

my $website = $user_tipping_account->website;

print $website->website_name, "\n";
