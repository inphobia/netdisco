use utf8;
package App::Netdisco::DB::Result::MaskDevice;

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("mask_device");
__PACKAGE__->add_columns(
  "ip",
  { data_type => "inet", is_nullable => 0 },
  "creation",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "dns",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "uptime",
  { data_type => "bigint", is_nullable => 1 },
  "contact",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "layers",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "ports",
  { data_type => "integer", is_nullable => 1 },
  "mac",
  { data_type => "macaddr", is_nullable => 1 },
  "serial",
  { data_type => "text", is_nullable => 1 },
  "model",
  { data_type => "text", is_nullable => 1 },
  "slots",
  { data_type => "integer", is_nullable => 1 },
  "vendor",
  { data_type => "text", is_nullable => 1 },
  "os",
  { data_type => "text", is_nullable => 1 },
  "os_ver",
  { data_type => "text", is_nullable => 1 },
  "log",
  { data_type => "text", is_nullable => 1 },
  "snmp_ver",
  { data_type => "integer", is_nullable => 1 },
  "snmp_comm",
  { data_type => "text", is_nullable => 1 },
  "snmp_class",
  { data_type => "text", is_nullable => 1 },
  "vtp_domain",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("ip");

=head1 NAME

App::Netdisco::DB::Result::MaskDevice - overwrite discovered data with manual input.

=head1 SYNOPSIS

#TODO
TODO

=head1 DESCRIPTION

This L<DBIx::Class> component provides an way to overwrite discovered device data
with whatever you think it should be. Netdisco will still save the discovered
data in the device table but will give precedence to whatever is contained in
this table instead.

Only users with the C<mask_control> option will be able to do this.

=cut

1;
