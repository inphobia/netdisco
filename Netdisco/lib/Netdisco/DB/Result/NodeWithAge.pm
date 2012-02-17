use utf8;
package Netdisco::DB::Result::NodeWithAge;

use strict;
use warnings;

use base 'Netdisco::DB::Result::Node';

__PACKAGE__->load_components('Helper::Row::SubClass');
__PACKAGE__->subclass;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table("node_with_age");
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q{
  SELECT *,
    replace(age( date_trunc( 'minute', time_last + interval '30 second' ) ) ::text, 'mon', 'month')
      AS time_last_age
  FROM node
});

__PACKAGE__->add_columns(
  "time_last_age",
  { data_type => "text", is_nullable => 1 },
);

1;
