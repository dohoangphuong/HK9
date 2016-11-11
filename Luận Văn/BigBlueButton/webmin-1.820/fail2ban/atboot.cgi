#!/usr/local/bin/perl
# Enable the Fail2ban server at boot, or not

use strict;
use warnings;
require './fail2ban-lib.pl';
our (%text, %in, %config, $module_config_directory);
&ReadParse();

&foreign_require("init");
my $starting = &init::action_status($config{'init_script'});
if ($starting != 2 && $in{'boot'}) {
	# Enable at boot
	my $startscript = &has_command($config{'client_cmd'})." -x start";
	my $stopscript = &has_command($config{'client_cmd'})." stop";
	&init::enable_at_boot($config{'init_script'},
		"Start Fail2Ban server",
		$startscript,
		$stopscript,
		undef,
		{ 'fork' => 1 },
		);
	&webmin_log("atboot");
	}
elsif ($starting == 2 && !$in{'boot'}) {
	# Disable at boot
	&init::disable_at_boot($config{'init_script'});
	&webmin_log("delboot");
	}

&redirect("");

