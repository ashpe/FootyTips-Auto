package Footy::Schema::Result::UserTippingAccount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Footy::Schema::Result::UserTippingAccount

=cut

__PACKAGE__->table("user_tipping_accounts");

=head1 ACCESSORS

=head2 tipping_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 group_id

  data_type: 'integer'
  is_nullable: 0

=head2 website_id

  data_type: 'integer'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 tipping_username

  data_type: 'text'
  is_nullable: 0

=head2 tipping_password

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tipping_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "group_id",
  { data_type => "integer", is_nullable => 0 },
  "website_id",
  { data_type => "integer", is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_nullable => 0 },
  "tipping_username",
  { data_type => "text", is_nullable => 0 },
  "tipping_password",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("tipping_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-27 02:43:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RnTUvnAu/lw/TI/Nvcyy/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
