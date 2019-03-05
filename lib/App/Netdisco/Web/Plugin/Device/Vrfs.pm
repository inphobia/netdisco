package App::Netdisco::Web::Plugin::Device::Vrfs;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Auth::Extensible;

use App::Netdisco::Web::Plugin;

register_device_tab( { tag => 'vrfs', label => 'Vrfs', provides_csv => 0 } );

# device interface addresses
get '/ajax/content/device/vrfs' => require_login sub {
    my $q = param('q');

    my $device
        = schema('netdisco')->resultset('Device')->search_for_device($q)
        or send_error( 'Bad device', 400 );

    my @results = $device->vrfs->search( {}, { order_by => 'vrf' } )->hri->all;

    return unless scalar @results;

    if (request->is_ajax) {
        my $json = to_json( \@results );
        template 'ajax/device/vrfs.tt', { results => $json },
            { layout => undef };
    }
};

1;
