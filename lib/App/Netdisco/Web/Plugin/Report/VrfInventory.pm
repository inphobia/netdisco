package App::Netdisco::Web::Plugin::Report::VrfInventory;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Auth::Extensible;

use App::Netdisco::Web::Plugin;

register_report(
    {   category     => 'VRF',
        tag          => 'vrfinventory',
        label        => 'VRF Inventory',
        provides_csv => 0,
    }
);

get '/ajax/content/report/vrfinventory' => require_login sub {
    my @results = schema('netdisco')->resultset('DeviceVrf')->get_vrfs->hri->all;

    return unless scalar @results;

    if ( request->is_ajax ) {
        my $json = to_json (\@results);
        template 'ajax/report/vrfinventory.tt', { results => $json },
            { layout => undef };
    }
};

true;
