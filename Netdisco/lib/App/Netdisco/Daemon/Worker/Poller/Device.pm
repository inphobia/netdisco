package App::Netdisco::Daemon::Worker::Poller::Device;

use Dancer qw/:moose :syntax :script/;
use Dancer::Plugin::DBIC 'schema';

use App::Netdisco::Util::SNMP 'snmp_connect';
use App::Netdisco::Util::Device 'get_device';
use App::Netdisco::Util::DiscoverAndStore ':all';
use App::Netdisco::Daemon::Util ':all';

use NetAddr::IP::Lite ':lower';

use Role::Tiny;
use namespace::clean;

# queue a discover job for all devices known to Netdisco
sub refresh {
  my ($self, $job) = @_;

  my $devices = schema('netdisco')->resultset('Device')->get_column('ip');

  schema('netdisco')->resultset('Admin')->populate([
    map {{
        device => $_,
        action => 'discover',
        status => 'queued',
    }} ($devices->all)
  ]);

  return job_done("Queued discover job for all devices");
}

sub discover {
  my ($self, $job) = @_;

  my $host = NetAddr::IP::Lite->new($job->device);
  my $device = get_device($host->addr);

  if ($device->in_storage
      and $device->vendor and $device->vendor eq 'netdisco') {
      return job_done("Skipped discover for pseudo-device $host");
  }

  my $snmp = snmp_connect($device);
  if (!defined $snmp) {
      return job_error("discover failed: could not SNMP connect to $host");
  }

  store_device($device, $snmp);
  store_interfaces($device, $snmp);
  store_wireless($device, $snmp);
  store_vlans($device, $snmp);
  store_power($device, $snmp);
  store_modules($device, $snmp);

  return job_done("Ended discover for $host");
}

# run find_neighbors on all known devices, and run discover on any
# newly found devices.
sub discovernew {
  my ($self, $job) = @_;

  my $devices = schema('netdisco')->resultset('Device')->get_column('ip');

  schema('netdisco')->resultset('Admin')->populate([
    map {{
        device => $_,
        action => 'discover_neighbors',
        status => 'queued',
    }} ($devices->all)
  ]);

  return job_done("Queued discover_neighbors job for all devices");
}

sub discover_neighbors {
  my ($self, $job) = @_;

  my $host = NetAddr::IP::Lite->new($job->device);
  my $device = get_device($host->addr);

  if ($device->in_storage
      and $device->vendor and $device->vendor eq 'netdisco') {
      return job_done("Skipped discover for pseudo-device $host");
  }

  my $snmp = snmp_connect($device);
  if (!defined $snmp) {
      return job_error("discover_neighbors failed: could not SNMP connect to $host");
  }

  find_neighbors($device, $snmp);

  return job_done("Ended find_neighbors for $host");
}

1;
