#!/usr/local/bin/perl

require './usermin-lib.pl';
$access{'categories'} || &error($text{'acl_ecannot'});
&get_usermin_miniserv_config(\%miniserv);
&read_file("$miniserv{'root'}/lang/en", \%utext);
&read_file("$miniserv{'root'}/ulang/en", \%utext);

&ui_print_header(undef, $text{'categories_title'}, undef);

# Show language selector
print ui_form_start("edit_categories.cgi");
print "<b>$text{'categories_lang'}</b>\n";
print ui_select("lang", $in{'lang'},
        [ [ "", "&lt;$text{'default'}&gt;" ],
          map { [ $_->{'lang'}, "$_->{'desc'} (".uc($_->{'lang'}).")" ] }
              list_languages() ]),"\n";
print ui_submit($text{'categories_langok'}),"\n";
print ui_form_end();

print "$text{'categories_desc'}<p>\n";
print ui_form_start("save_categories.cgi");
print ui_hidden("lang", $in{'lang'});

print &ui_columns_start([ $text{'categories_code'},
                          $text{'categories_name'} ]);

# Show the existing categories
$file = "$config{'usermin_dir'}/webmin.catnames";
$file .= ".".$in{'lang'} if ($in{'lang'});
read_file($file, \%catnames);
foreach $t (keys %utext) {
        $t =~ s/^category_// || next;
        $field = $t || "other";
        print &ui_columns_row([
                $t || "<i>other</i>",
                &ui_opt_textbox($field, $catnames{$t}, 30,
                        $text{'default'}, $text{'categories_custom'}),
                ], [ "valign=middle","valign=middle" ]);
        $realcat{$t}++;
        }

# Show new categories
$i = 0;
foreach $c (keys %catnames) {
        if (!$realcat{$c}) {
                print &ui_columns_row([
                        &ui_textbox("cat_$i", $c, 10),
                        &ui_textbox("desc_$i", $catnames{$c}, 30),
                        ], [ "valign=middle","valign=middle" ]);
                $i++;
                }
        }
print &ui_columns_row([
        &ui_textbox("cat_$i", "", 10),
        &ui_textbox("desc_$i", "", 30),
        ], [ "valign=middle","valign=middle" ]);

print &ui_columns_end();
print ui_form_end([ [ "ok", $text{'categories_ok'} ] ]);
ui_print_footer("", $text{'index_return'});

