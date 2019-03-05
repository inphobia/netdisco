package App::Netdisco::Worker::Plugin::Discover::VRFs;

use Dancer ':syntax';
use App::Netdisco::Worker::Plugin;
use App::Netdisco::Transport::SNMP ();
use aliased 'App::Netdisco::Worker::Status';
use Dancer::Plugin::DBIC 'schema';
use Encode;

register_worker({ phase => 'main', driver => 'snmp' }, sub {
  my ($job, $workerconf) = @_;

  my $device = $job->device;
  return unless $device->in_storage and $device->has_layer(3);
  my $snmp = App::Netdisco::Transport::SNMP->reader_for($device)
    or return Status->defer("discover failed: could not SNMP connect to $device");

  my $vrf_index = $snmp->cisco_vrf_index || {};

  return Status->info("device $device has no VRF instances")
    unless (scalar values %$vrf_index);

  my $vrf_name = $snmp->cisco_vrf_name;
  my $vrf_up   = $snmp->cisco_vrf_up;

  # build device modules list for DBIC
  my (@vrfs, %seen_idx);

  foreach my $entry (keys %$vrf_index) {
    next if $seen_idx{ $vrf_index->{$entry} }++;
    push @vrfs, {
      vrf           => $vrf_index->{$entry},
      description   => Encode::decode('UTF-8', $vrf_name->{$entry}),
      up            => $vrf_up->{$entry},
      last_discover => \'now()',
      };
  }

  schema('netdisco')->txn_do(sub {
    my $gone = $device->vrfs->delete;
    debug sprintf ' [%s] vrfs - removed %d vrfs',
      $device->ip, $gone;
    $device->vrfs->populate(\@vrfs);

    return Status->info(sprintf ' [%s] vrfs - added %d new vrfs',
      $device->ip, scalar @vrfs);
  });

  foreach my $vrf (values %$vrf_name) {
    debug sprintf ' vrf found %s', $vrf;
  }

  return Status->info(" [$device] vrfs discovered");
});

true;
