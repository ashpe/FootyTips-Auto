package Footy::Schema::Result::TippingWebsite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Footy::Schema::Result::TippingWebsite

=cut

__PACKAGE__->table("tipping_websites");

=head1 ACCESSORS

=head2 website_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 website_name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "website_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "website_name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("website_id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-04-27 02:43:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MeeD4IkO17c0erlZasoY4A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
