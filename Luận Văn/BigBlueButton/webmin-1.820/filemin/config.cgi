#!/usr/local/bin/perl

require './filemin-lib.pl';
use lib './lib';

&ReadParse();

get_paths();

&ui_print_header(undef, $text{'module_config'}, "");
$head = "<link rel='stylesheet' type='text/css' href='unauthenticated/css/style.css' />";
print $head;

if(!-e "$confdir/.config") {
    &read_file("$module_root_directory/defaultuconf", \%config);
} else {
    &read_file("$confdir/.config", \%config);
}

if(!-e "$confdir/.bookmarks") {
    $bookmarks = '';
} else {
    $bookmarks = &read_file_contents($confdir.'/.bookmarks', 1);
}

print &ui_form_start("save_config.cgi", "post");

print &ui_table_start($text{'module_config'}, undef, 2);
print &ui_table_row($text{'config_columns_to_display'},
    &ui_checkbox('columns', 'type', $text{'type'}, $config{'columns'} =~ /type/).
    &ui_checkbox('columns', 'size', $text{'size'}, $config{'columns'} =~ /size/).
    &ui_checkbox('columns', 'owner_user', $text{'owner_user'}, $config{'columns'} =~ /owner_user/).
    &ui_checkbox('columns', 'permissions', $text{'permissions'}, $config{'columns'} =~ /permissions/).
    &ui_checkbox('columns', 'last_mod_time', $text{'last_mod_time'}, $config{'columns'} =~ /last_mod_time/)
);
print &ui_table_row($text{'config_per_page'}, ui_textbox("per_page", $config{'per_page'}, 80));
print &ui_table_row($text{'config_disable_pagination'}, &ui_checkbox('disable_pagination', 1, '', $config{'disable_pagination'}));
print &ui_table_row($text{'config_toolbar_style'}, &ui_yesno_radio('menu_style', $config{'menu_style'}, 1, 0));
print &ui_table_row($text{'config_bookmarks'}, &ui_textarea("bookmarks", $bookmarks, 5, 40));

print &ui_table_end();

print &ui_hidden('path', $path);

print &ui_form_end([ [ save, $text{'save'} ] ]);

&ui_print_footer("index.cgi?path=$path", $text{'previous_page'});
