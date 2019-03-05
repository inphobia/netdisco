use utf8;
package App::Netdisco::DB::Result::DeviceVrf;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("device_vrf");
__PACKAGE__->add_columns(
  "ip",
  { data_type => "inet", is_nullable => 0 },
  "vrf",
  { data_type => "integer", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "up",
  { data_type => "text", is_nullable => 1 },
  "creation",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "last_discover",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("ip", "vrf");


=head1 RELATIONSHIPS

=head2 device

Returns the entry from the C<device> table on which this VRF entry was discovered.

=cut

__PACKAGE__->belongs_to( device => 'App::Netdisco::DB::Result::Device', 'ip' );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
