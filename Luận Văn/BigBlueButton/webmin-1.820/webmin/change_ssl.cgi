#!/usr/local/bin/perl
# change_ssl.cgi
# Enable or disable SSL support

require './webmin-lib.pl';
&ReadParse();
&error_setup($text{'ssl_err'});

&lock_file($ENV{'MINISERV_CONFIG'});
&get_miniserv_config(\%miniserv);
$miniserv{'ssl'} = $in{'ssl'};
&validate_key_cert($in{'key'}, $in{'cert_def'} ? undef : $in{'cert'});
$miniserv{'keyfile'} = $in{'key'};
$miniserv{'certfile'} = $in{'cert_def'} ? undef : $in{'cert'};
$miniserv{'ssl_redirect'} = $in{'ssl_redirect'};
$miniserv{'no_sslcompression'} = !$in{'ssl_compression'};
$miniserv{'ssl_honorcipherorder'} = $in{'ssl_honorcipherorder'};
if ($in{'version_def'}) {
	delete($miniserv{'ssl_version'});
	}
else {
	$in{'version'} =~ /^\d+$/ || &error($text{'ssl_eversion'});
	$miniserv{'ssl_version'} = $in{'version'};
	}
$miniserv{'no_ssl2'} = $in{'no_ssl2'};
$miniserv{'no_ssl3'} = $in{'no_ssl3'};
$miniserv{'no_tls1'} = $in{'no_tls1'};
$miniserv{'no_tls1_1'} = $in{'no_tls1_1'};
$miniserv{'no_tls1_2'} = $in{'no_tls1_2'};
if ($in{'cipher_list_def'} == 1) {
	delete($miniserv{'ssl_cipher_list'});
	}
elsif ($in{'cipher_list_def'} == 2) {
	$miniserv{'ssl_cipher_list'} = $strong_ssl_ciphers;
	}
elsif ($in{'cipher_list_def'} == 3) {
	$miniserv{'ssl_cipher_list'} = $pfs_ssl_ciphers;
	}
else {
	$in{'cipher_list'} =~ /^\S+$/ || &error($text{'ssl_ecipher_list'});
	$miniserv{'ssl_cipher_list'} = $in{'cipher_list'};
	}
$miniserv{'cipher_list_def'} = $in{'cipher_list_def'};
foreach $ec (split(/[\r\n]+/, $in{'extracas'})) {
	-r $ec && !-d $ec || &error(&text('ssl_eextraca', $ec));
	push(@extracas, $ec);
	}
$miniserv{'extracas'} = join("\t", @extracas);
&put_miniserv_config(\%miniserv);
&unlock_file($ENV{'MINISERV_CONFIG'});

$SIG{'TERM'} = 'IGNORE';	# stop process from being killed by restart
&restart_miniserv();
&webmin_log("ssl", undef, undef, \%in);

$url = "$ENV{'SERVER_NAME'}:$miniserv{'port'}/webmin/";
if ($in{'ssl'}) { &redirect("https://$url"); }
else { &redirect("http://$url"); }

