package App::Netdisco::DB::ResultSet::DeviceVrf;
use base 'App::Netdisco::DB::ResultSet';

use strict;
use warnings;

__PACKAGE__->load_components(
    qw/
        +App::Netdisco::DB::ExplicitLocking
        /
);

=head1 ADDITIONAL METHODS

=head2 get_vrfs

Returns a sorted list of VRFs with the following columns only:

=over 4

=item vrf

=item description

=item count

=back

Where C<count> is the number of instances of the VRF in the Netdisco
database.

=cut

sub get_vrfs {
    my $rs = shift;

    return $rs->search(
        {},
        {   select => [ 'vrf', 'description', { count => 'vrf' } ],
            as       => [qw/ vrf description count /],
            group_by => [qw/ vrf description /],
            order_by => { -desc => [qw/count/] },
        }
        )

}

1;
