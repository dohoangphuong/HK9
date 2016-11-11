#!/usr/local/bin/perl
# index.cgi
# List all at jobs and display a form for creating a new one
#
# F&AS : default parameters can be set 
#   ext_user : default user
#   ext_cmd  : default command
use strict;
use warnings;
our (%access, %text, %in, %config);
our ($module_name, $remote_user);

require './at-lib.pl';
use POSIX;
&ui_print_header(undef, $text{'index_title'}, "", undef, 1, 1);
ReadParse();

# Check if at is installed
if (!&has_command("at")) {
	&ui_print_endpage(&text('index_noat', "<tt>at</tt>",
			        "../config.cgi?$module_name"));
	}

# Show list of existing jobs
my @jobs = &list_atjobs();
@jobs = grep { &can_edit_user(\%access, $_->{'user'}) } @jobs;
if (@jobs) {
	print &ui_form_start("delete_jobs.cgi", "post");
	@jobs = sort { $a->{'id'} <=> $b->{'id'} } @jobs;
	my @tds = ( "width=5", "nowrap" );
	my @links = ( &select_all_link("d"), &select_invert_link("d") );
	print &ui_links_row(\@links);
	print &ui_columns_start([
		"",
		$text{'index_id'},
		$text{'index_user'},
		$text{'index_exec'},
		$text{'index_created'},
		$text{'index_cmd'} ], 100, 0, \@tds);
	foreach my $j (@jobs) {
		my @cols;
		push(@cols, &ui_link("edit_job.cgi?id=".$j->{'id'}, $j->{'id'}) );
		push(@cols, &html_escape($j->{'user'}));
		my $date = localtime($j->{'date'});
		push(@cols, "<tt>$date</tt>");
		my $created = localtime($j->{'created'});
		push(@cols, "<tt>$created</tt>");
		push(@cols, join("<br>", split(/\n/,
				&html_escape($j->{'realcmd'}))));
		print &ui_checked_columns_row(\@cols, \@tds, "d", $j->{'id'});
		}
	print &ui_columns_end();
	print &ui_links_row(\@links);
	print &ui_form_end([ [ "delete", $text{'index_delete'} ] ]);
	print &ui_hr();
	}


# Show form for creating a new At job
print &ui_form_start("create_job.cgi");
print &ui_table_start($text{'index_header'}, undef, 2);

# User to run as
my $dir = "/";
my ($user, $usel);
if ($access{'mode'} == 1) {
	$usel = &ui_select("user", undef,
			   [ split(/\s+/, $access{'users'}) ]);
	}
elsif ($access{'mode'} == 3) {
	$usel = "<tt>$remote_user</tt>";
	print &ui_hidden("user", $remote_user);
	my @uinfo = getpwnam($remote_user);
	$dir = $uinfo[7];
	}
else {
	$usel = &ui_user_textbox("user", $in{'ext_user'});
	}
print &ui_table_row($text{'index_user'}, $usel, undef, ["valign=middle","valign=middle"]);

# Run date
my @now = localtime(time());
print &ui_table_row($text{'index_date'},
	&ui_textbox("day", $now[3], 2)."/".
	&ui_select("month", $now[4],
		   [ map { [ $_, $text{"smonth_".($_+1)} ] } ( 0 .. 11 ) ])."/".
	&ui_textbox("year", $now[5]+1900, 4).
	&date_chooser_button("day", "month", "year"), undef, ["valign=middle","valign=middle"]);

# Run time
print &ui_table_row($text{'index_time'},
	&ui_textbox("hour", undef, 2).":".&ui_textbox("min", "00", 2), undef, ["valign=middle","valign=middle"]);

# Current date and time
my ($date, $time) = split(/\s+/, &make_date(time()));
print &ui_table_row($text{'index_cdate'}, $date, undef, ["valign=middle","valign=middle"]);
print &ui_table_row($text{'index_ctime'}, $time, undef, ["valign=middle","valign=middle"]);

# Run in directory
print &ui_table_row($text{'index_dir'},
		    &ui_textbox("dir", $dir, 50), undef, ["valign=middle","valign=middle"]);

# Commands to run
print &ui_table_row($text{'index_cmd'},
		    &ui_textarea("cmd", $in{'ext_cmd'}, 5, 50), undef, ["valign=top","valign=top"]);

# Send email on completion
print &ui_table_row($text{'index_mail'},
		    &ui_yesno_radio("mail", 0), undef, ["valign=middle","valign=middle"]);

print &ui_table_end();
print &ui_form_end([ [ undef, $text{'create'} ] ]);

if ($access{'allow'} && $config{'allow_file'}) {
	# Show form to manage allowed and denied users
	my @allow = &list_allowed();
	my @deny = &list_denied();
	print &ui_hr();
	print &ui_form_start("save_allow.cgi", "post");
	print &ui_table_start($text{'index_allow'}, undef, 2);
	print &ui_table_row($text{'index_amode'},
		    &ui_radio("amode", 
			@allow ? 1 : @deny ? 2 : 0,
			[ [ 0, $text{'index_amode0'} ],
			  [ 1, $text{'index_amode1'} ],
			  [ 2, $text{'index_amode2'} ] ]), undef, ["valign=middle","valign=middle"]);
	print &ui_table_row("",
		    &ui_textarea("ausers", @allow ? join("\n", @allow) :
					  @deny ? join("\n", @deny) : undef,
				5, 50));
	print &ui_table_end();
	print &ui_form_end([ [ "save", $text{'save'} ] ]);
	}

&ui_print_footer("/", $text{'index'});

