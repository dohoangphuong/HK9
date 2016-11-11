# Functions for managing firewalld

BEGIN { push(@INC, ".."); };
use strict;
use warnings;
use WebminCore;
&init_config();
do 'md5-lib.pl';
our ($module_root_directory, %text, %config, %gconfig);
our %access = &get_module_acl();

# check_firewalld()
# Returns an error message if firewalld is not installed, undef if all is OK
sub check_firewalld
{
&has_command($config{'firewall_cmd'}) ||
	return &text('check_ecmd', "<tt>".$config{'firewall_cmd'}."</tt>");
return undef;
}

# is_firewalld_running()
# Returns 1 if the server is running, 0 if not
sub is_firewalld_running
{
my $ex = system("$config{'firewall_cmd'} --state >/dev/null 2>&1 </dev/null");
return $ex ? 0 : 1;
}

# list_firewalld_zones([active-only])
# Returns an array of firewalld zones, each of which is a hash ref with fields
# like services and ports
sub list_firewalld_zones
{
my ($active) = @_;
my @rv;
my $out = &backquote_command("$config{'firewall_cmd'} --list-all-zones ".
			     ($active ? "" : "--permanent ")."</dev/null 2>&1");
if ($?) {
	&error("Failed to list zones : $out");
	}
my $zone;
foreach my $l (split(/\r?\n/, $out)) {
	if ($l =~ /^(\S+)(\s+\(.*\))?/) {
		# New zone
		$zone = { 'name' => $1,
			  'default' => $2 ? 1 : 0 };
		push(@rv, $zone);
		}
	elsif ($l =~ /^\s+(\S+):\s*(.*)/ && $zone) {
		# Option in some zone
		$zone->{$1} = [ split(/\s+/, $2) ];
		}
	}
return @rv;
}

# list_firewalld_services()
# Returns an array of known service names
sub list_firewalld_services
{
my $out = &backquote_command("$config{'firewall_cmd'} --get-services </dev/null 2>&1");
if ($?) {
	&error("Failed to list services : $out");
	}
$out =~ s/\r|\n//g;
return split(/\s+/, $out);
}

# create_firewalld_port(&zone, port|range, proto)
# Adds a new allowed port to a zone. Returns undef on success or an error
# message on failure
sub create_firewalld_port
{
my ($zone, $port, $proto) = @_;
my $out = &backquote_logged("$config{'firewall_cmd'} ".
			    "--zone ".quotemeta($zone->{'name'})." ".
			    "--permanent --add-port ".
			    quotemeta($port)."/".quotemeta($proto)." 2>&1");
return $? ? $out : undef;
}

# delete_firewalld_port(&zone, port|range, proto)
# Delete one existing port from a zone. Returns undef on success or an error
# message on failure
sub delete_firewalld_port
{
my ($zone, $port, $proto) = @_;
my $out = &backquote_logged("$config{'firewall_cmd'} ".
			    "--zone ".quotemeta($zone->{'name'})." ".
			    "--permanent --remove-port ".
			    quotemeta($port)."/".quotemeta($proto)." 2>&1");
return $? ? $out : undef;
}

# create_firewalld_service(&zone, service)
# Adds a new allowed service to a zone. Returns undef on success or an error
# message on failure
sub create_firewalld_service
{
my ($zone, $service) = @_;
my $out = &backquote_logged("$config{'firewall_cmd'} ".
			    "--zone ".quotemeta($zone->{'name'})." ".
			    "--permanent --add-service ".
			    quotemeta($service)." 2>&1");
return $? ? $out : undef;
}

# delete_firewalld_service(&zone, service)
# Delete one existing service from a zone. Returns undef on success or an error
# message on failure
sub delete_firewalld_service
{
my ($zone, $service) = @_;
my $out = &backquote_logged("$config{'firewall_cmd'} ".
			    "--zone ".quotemeta($zone->{'name'})." ".
			    "--permanent --remove-service ".
			    quotemeta($service)." 2>&1");
return $? ? $out : undef;
}

# apply_firewalld()
# Make the current saved config active
sub apply_firewalld
{
my $out = &backquote_logged("$config{'firewall_cmd'} --reload 2>&1");
return $? ? $out : undef;
}

# stop_firewalld()
# Shut down the firewalld service
sub stop_firewalld
{
&foreign_require("init");
my ($ok, $err) = &init::stop_action($config{'init_name'});
return $ok ? undef : $err;
}

# start_firewalld()
# Shut down the firewalld service
sub start_firewalld
{
&foreign_require("init");
my ($ok, $err) = &init::start_action($config{'init_name'});
return $ok ? undef : $err;
}

# list_system_interfaces()
# Returns the list of all interfaces on the system
sub list_system_interfaces
{
&foreign_require("net");
my @rv = map { $_->{'name'} } &net::active_interfaces();
push(@rv, map { $_->{'name'} } &net::boot_interfaces());
return &unique(@rv);
}

# update_zone_interfaces(&zone, &interface-list)
# Update the interfaces a zone applies to
sub update_zone_interfaces
{
my ($zone, $newifaces) = @_;
my $oldifaces = $zone->{'interfaces'};
foreach my $i (&list_system_interfaces()) {
	my $inold = &indexof($i, @$oldifaces) >= 0;
	my $innew = &indexof($i, @$newifaces) >= 0;
	my $args;
	if ($inold && !$innew) {
		# Remove from this zone
		$args = "--remove-interface ".quotemeta($i);
		}
	elsif (!$inold && $innew) {
		# Add to from this zone
		$args = "--add-interface ".quotemeta($i);
		}
	else {
		next;
		}
	my $cmd = "$config{'firewall_cmd'} ".
		  "--zone ".quotemeta($zone->{'name'})." ".
		  "--permanent ".$args;
	my $out = &backquote_logged($cmd." 2>&1 </dev/null");
	return $out if ($?);
	}
return undef;
}

# create_firewalld_zone(name)
# Add a new zone with the given name
sub create_firewalld_zone
{
my ($name) = @_;
my $cmd = "$config{'firewall_cmd'} --permanent --new-zone ".quotemeta($name);
my $out = &backquote_logged($cmd." 2>&1 </dev/null");
return $? ? $out : undef;
}

# delete_firewalld_zone(&zone)
# Removes the specified zone
sub delete_firewalld_zone
{
my ($zone) = @_;
my $cmd = "$config{'firewall_cmd'} --permanent --delete-zone ".
	  quotemeta($zone->{'name'});
my $out = &backquote_logged($cmd." 2>&1 </dev/null");
return $? ? $out : undef;
}

# default_firewalld_zone(&zone)
# Makes the specified zone the default
sub default_firewalld_zone
{
my ($zone) = @_;
my $cmd = "$config{'firewall_cmd'} --set-default-zone ".
	  quotemeta($zone->{'name'});
my $out = &backquote_logged($cmd." 2>&1 </dev/null");
return $? ? $out : undef;
}

1;

