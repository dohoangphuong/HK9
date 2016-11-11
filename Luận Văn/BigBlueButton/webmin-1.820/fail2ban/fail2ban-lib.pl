# Functions for configuring the fail2ban log analyser

BEGIN { push(@INC, ".."); };
use strict;
use warnings;
use WebminCore;
&init_config();
our ($module_root_directory, %text, %config, %gconfig, $base_remote_user);
our %access = &get_module_acl();

# check_fail2ban()
# Returns undef if installed, or an appropriate error message if missing
sub check_fail2ban
{
-d $config{'config_dir'} || return &text('check_edir',
					 "<tt>$config{'config_dir'}</tt>");
-r "$config{'config_dir'}/fail2ban.conf" ||
	return &text('check_econf', "<tt>$config{'config_dir'}</tt>",
		     "<tt>fail2ban.conf</tt>");
&has_command($config{'client_cmd'}) ||
	return &text('check_eclient', "<tt>$config{'client_cmd'}</tt>");
&has_command($config{'server_cmd'}) ||
	return &text('check_eserver', "<tt>$config{'server_cmd'}</tt>");
return undef;
}

sub is_fail2ban_running
{
my ($pid) = &find_byname($config{'server_cmd'});
if (!$pid) {
	($pid) = &find_byname("fail2ban-server");
	}
return $pid;
}

# list_filters()
# Returns a list of all defined filter files, each of which contains multiple
# sections like [Definition]
sub list_filters
{
my $dir = "$config{'config_dir'}/filter.d";
my @rv;
foreach my $f (glob("$dir/*.conf")) {
	my @conf = &parse_config_file($f);
	if (@conf) {
		push(@rv, \@conf);
		}
	}
return @rv;
}

# list_actions()
# Returns a list of all defined action files, each of which contains multiple
# sections like [Definition] and [Init]
sub list_actions
{
my $dir = "$config{'config_dir'}/action.d";
my @rv;
foreach my $f (glob("$dir/*.conf")) {
	my @conf = &parse_config_file($f);
	if (@conf) {
		push(@rv, \@conf);
		}
	}
return @rv;
}

# list_jails()
# Returns a list of all sections from the jails file
sub list_jails
{
my @rv;
my $jfile = "$config{'config_dir'}/jail.conf";
if (-r $jfile) {
	push(@rv, &parse_config_file($jfile));
	}
my $jlfile = "$config{'config_dir'}/jail.local";
if (-r $jlfile) {
	# Add jails from .local file that aren't directive-level overrides
	my @lrv = &parse_config_file($jlfile);
	my %names = map { $_->{'name'}, $_ } @rv;
	foreach my $j (@lrv) {
		if (!$names{$j->{'name'}}) {
			push(@rv, $j);
			}
		}
	}
my $jdir = "$config{'config_dir'}/jail.d";
if (-d $jdir) {
	foreach my $f (glob("$jdir/*.conf")) {
		push(@rv, &parse_config_file($f));
		}
	}
return @rv;
}

# get_config()
# Returns the global config as an array ref of directives
sub get_config
{
my @conf = &parse_config_file("$config{'config_dir'}/fail2ban.conf");
return \@conf;
}

# parse_config_file(file)
# Parses one file into a list of [] sections, each with multiple directives
sub parse_config_file
{
my ($file) = @_;
my $lref = &read_file_lines($file, 1);
my $lnum = 0;
my $fh = "CONF";
my $sect;
my @rv;
&open_readfile($fh, $file) || return ( );
while(<$fh>) {
	s/\r|\n//g;
	s/^\s*#.*$//;
	s/^\s;.*$//;
	if (/^\[([^\]]+)\]/) {
		# Start of a section
		$sect = { 'name' => $1,
			  'line' => $lnum,
		 	  'eline' => $lnum,
			  'file' => $file,
			  'members' => [] };
		push(@rv, $sect);
		}
	elsif (/^(\S+)\s*=\s*(.*)/ && $sect) {
		# A directive in a section
		my $dir = { 'name' => $1,
			    'value' => $2,
			    'line' => $lnum,
                            'eline' => $lnum,
                            'file' => $file,
			  };
		push(@{$sect->{'members'}}, $dir);
		$sect->{'eline'} = $lnum;
		&split_directive_values($dir);
		}
	elsif (/^\s+(\S.*)/ && $sect && @{$sect->{'members'}}) {
		# Continuation of a directive
		my $dir = $sect->{'members'}->[@{$sect->{'members'}} - 1];
		$dir->{'value'} .= "\n".$1;
		$dir->{'eline'} = $lnum;
		$sect->{'eline'} = $lnum;
		&split_directive_values($dir);
		}
	$lnum++;
	}
close($fh);
if ($file =~ /^(.*)\.conf$/) {
	# Read local overrides file, which takes effect first for each block
	my $localfile = $1.".local";
	if (-r $localfile) {
		my @lrv = &parse_config_file($localfile);
		my %lsects = map { $_->{'name'}, $_ } @lrv;
		foreach my $sect (@rv) {
			# For each section in the .conf file, put directives
			# from the .local file in first
			my $lsect = $lsects{$sect->{'name'}};
			next if (!$lsect);
			my $msect = { %$lsect };
			$msect->{'local'} = 1;
			$msect->{'origfile'} = $sect->{'file'};
			push(@{$msect->{'members'}}, @{$sect->{'members'}});
			$rv[&indexof($sect, @rv)] = $msect;
			}
		}
	}
return @rv;
}

# split_directive_values(&dir)
# Populate the 'values' field by splitting up the 'value' field
sub split_directive_values
{
my ($dir) = @_;
my @w;
my $v = $dir->{'value'};
$v =~ s/\n/ /g;
while($v =~ /\S/) {
	if ($v =~ /^([^\[]+\[[^\]]+\])\s*(.*)/) {
		push(@w, $1);
		$v = $2;
		}
	elsif ($v =~ /^\s*(\S+)\s*(.*)/) {
		push(@w, $1);
		$v = $2;
		}
	}
$dir->{'words'} = \@w;
}

# create_section(file, &section)
# Add a new section to a file
sub create_section
{
my ($file, $sect) = @_;
my $lref = &read_file_lines($file);
$sect->{'file'} = $file;
$sect->{'line'} = scalar(@$lref);
push(@$lref, &section_lines($sect));
$sect->{'eline'} = scalar(@$lref);
&flush_file_lines($file);
}

# modify_section(file, &section)
# Update the first line (only) for some section
sub modify_section
{
my ($file, $sect) = @_;
my $lref = &read_file_lines($file);
my @lines = &section_lines($sect);
$lref->[$sect->{'line'}] = $lines[0];
&flush_file_lines($file);
}

# delete_section(file, &section, [keep-file])
# Remove a section and all directives from a file
sub delete_section
{
my ($file, $sect, $keepfile) = @_;
my $lref = &read_file_lines($file);
splice(@$lref, $sect->{'line'}, $sect->{'eline'} - $sect->{'line'} + 1);
my $empty = 1;
foreach my $l (@$lref) {
	my $ll = $l;
	$ll =~ s/^\s*#.*//;
	$empty = 0 if ($ll =~ /\S/);
	}
if ($empty && !$keepfile) {
	# File is now empty, so delete it
	&unflush_file_lines($file);
	&unlink_file($file);
	}
else {
	# Save the file
	&flush_file_lines($file);
	}
}

# section_lines(&section)
# Returns all the lines of text for some section plus directives
sub section_lines
{
my ($sect) = @_;
my @rv;
push(@rv, "[".$sect->{'name'}."]");
foreach my $m (@{$sect->{'members'}}) {
	push(@rv, &directive_lines($m));
	}
return @rv;
}

# directive_lines(&directive)
# Returns all lines of text for some directive
sub directive_lines
{
my ($dir) = @_;
my @rv;
my @v = ref($dir->{'value'}) eq 'ARRAY' ? @{$dir->{'value'}}
					: split(/\n/, $dir->{'value'});
push(@rv, $dir->{'name'}." = ".shift(@v));
push(@rv, map { "        ".$_ } @v);	# Continuation
return @rv;
}

# save_directive(name, value|&values|&directive, &section)
# Updates one directive in a section
sub save_directive
{
my ($name, $v, $sect) = @_;
my $dir;
if (ref($v) eq 'HASH') {
	$dir = $v;
	}
elsif (ref($v) eq 'ARRAY') {
	$dir = { 'name' => $name,
		 'value' => $v };
	}
elsif (defined($v)) {
	$dir = { 'name' => $name,
		 'value' => $v };
	}
else {
	$dir = undef;
	}
my $old = &find($name, $sect);
my $oldlen = $old ? $old->{'eline'} - $old->{'line'} + 1 : undef;
my $oldidx = $old ? &indexof($old, @{$sect->{'members'}}) : -1;
my $file = $old ? $old->{'file'} : $sect->{'file'};
my $lref = &read_file_lines($file);
my @dirlines = defined($dir) ? &directive_lines($dir) : ();
if ($old && defined($dir) && $old->{'value'} ne $dir->{'value'}) {
	# Update existing
	if ($sect->{'local'} && $old->{'file'} ne $sect->{'file'}) {
		# Section is in a local file, so to override we need to
		# add a new line in the local file
		&unflush_file_lines($file);
		$file = $sect->{'file'};
		$lref = &read_file_lines($file);
		splice(@$lref, $sect->{'eline'}+1, 0, @dirlines);
		$dir->{'line'} = $sect->{'eline'}+1;
		$dir->{'file'} = $sect->{'file'};
		$sect->{'eline'} += scalar(@dirlines);
		$dir->{'eline'} = $sect->{'eline'};
		}
	else {
		# Just update the existing line
		splice(@$lref, $old->{'line'}, $oldlen, @dirlines);
		$dir->{'line'} = $old->{'line'};
		$dir->{'eline'} = $dir->{'line'} + scalar(@dirlines) - 1;
		$dir->{'file'} = $sect->{'file'};
		if ($oldidx >= 0) {
			$sect->{'members'}->[$oldidx] = $dir;
			}
		my $offset = scalar(@dirlines) - $oldlen;
		foreach my $m (@{$sect->{'members'}}) {
			next if ($m eq $dir || $m eq $old);
			if ($m->{'line'} > $old->{'line'}) {
				$m->{'line'} += $offset;
				$m->{'eline'} += $offset;
				}
			}
		}
	}
elsif (!$old && defined($dir)) {
	# Add new
	splice(@$lref, $sect->{'eline'}+1, 0, @dirlines);
	$dir->{'line'} = $sect->{'eline'}+1;
	$dir->{'file'} = $sect->{'file'};
	$sect->{'eline'} += scalar(@dirlines);
	$dir->{'eline'} = $sect->{'eline'};
	}
elsif ($old && !defined($dir)) {
	# Remove existing
	splice(@$lref, $old->{'line'}, $oldlen);
	$sect->{'eline'} -= $oldlen;
	if ($oldidx >= 0) {
		splice(@{$sect->{'members'}}, $oldidx, 1);
		}
	foreach my $m (@{$sect->{'members'}}) {
		next if ($m eq $old);
		if ($m->{'line'} > $old->{'line'}) {
			$m->{'eline'} -= $oldlen;
			$m->{'line'} -= $oldlen;
			}
		}
	}
&flush_file_lines($file);
}

sub find_value
{
my ($name, $object) = @_;
my @rv = map { $_->{'value'} } &find($name, $object);
return wantarray ? @rv : $rv[0];
}

sub find
{
my ($name, $object) = @_;
my $members = ref($object) eq 'HASH' ? $object->{'members'} : $object;
my @rv = grep { lc($_->{'name'}) eq $name } @$members;
return wantarray ? @rv : $rv[0];
}

# filename_to_name(file)
# Given a filename like /etc/fail2ban/foo.d/bar.conf , return bar
sub filename_to_name
{
my ($file) = @_;
$file =~ s/^.*\///;
$file =~ s/\.[^\.]+$//;
return $file;
}

# find_jail_by_filter(&filter)
# returns the jail objects using a filter
sub find_jail_by_filter
{
my ($filter) = @_;
my $fname = &filename_to_name($filter->[0]->{'file'});
my @rv;
foreach my $jail (&list_jails()) {
	my $jfilter = &find_value("filter", $jail);
	if ($jfilter eq $fname) {
		push(@rv, $jail);
		}
	}
return @rv;
}

# find_jail_by_action(&action)
# returns the jail objects using an action
sub find_jail_by_action
{
my ($action) = @_;
my $aname = &filename_to_name($action->[0]->{'file'});
my @rv;
foreach my $jail (&list_jails()) {
	my $jaction = &find("action", $jail);
	next if (!$jaction);
	my @jactions = map { /^([^\[]+)/; $1 } @{$jaction->{'words'}};
	if (&indexof($aname, @jactions) >= 0) {
		push(@rv, $jail);
		}
	}
return @rv;
}

# start_fail2ban_server()
# Attempts to start the server process, returning undef on success or an error message
# on failure.
sub start_fail2ban_server
{
if ($config{'init_script'}) {
	&foreign_require("init");
	my ($ok, $out) = &init::start_action($config{'init_script'});
	return $ok ? undef : $out;
	}
else {
	my $out = &backquote_logged("$config{'client_cmd'} -x start 2>&1 </dev/null");
	return $? ? $out : undef;
	}
}

# stop_fail2ban_server()
# Attempts to stop the server process, returning undef on success or an error message
# on failure.
sub stop_fail2ban_server
{
if ($config{'init_script'}) {
	&foreign_require("init");
	my ($ok, $out) = &init::stop_action($config{'init_script'});
	return $ok ? undef : $out;
	}
else {
	my $out = &backquote_logged("$config{'client_cmd'} stop 2>&1 </dev/null");
	return $? ? $out : undef;
	}
}

# restart_fail2ban_server()
# Force the fail2ban server to re-read its config
sub restart_fail2ban_server
{
my $out = &backquote_logged("$config{'client_cmd'} reload 2>&1 </dev/null");
return $? ? $out : undef;
}

# list_all_config_files()
# Returns a list of all Fail2Ban config files
sub list_all_config_files
{
my @rv;
push(@rv, "$config{'config_dir'}/fail2ban.conf");
push(@rv, "$config{'config_dir'}/fail2ban.local");
push(@rv, glob("$config{'config_dir'}/filter.d/*.conf"));
push(@rv, glob("$config{'config_dir'}/filter.d/*.local"));
push(@rv, glob("$config{'config_dir'}/action.d/*.conf"));
push(@rv, glob("$config{'config_dir'}/action.d/*.local"));
push(@rv, "$config{'config_dir'}/jail.conf");
push(@rv, "$config{'config_dir'}/jail.local");
return grep { -r $_ } @rv;
}

1;
