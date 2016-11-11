#!/usr/bin/perl

#
# Authentic Theme 18.10 (https://github.com/qooob/authentic-theme)
# Copyright 2015 Alexandr Bezenkov (https://github.com/Real-Gecko/filemin)
# Copyright 2014-2016 Ilia Rostovtsev <programming@rostovtsev.ru>
# Licensed under MIT (https://github.com/qooob/authentic-theme/blob/master/LICENSE)
#

use File::Basename;
use lib ( dirname(__FILE__) . '/../../lib' );

require( dirname(__FILE__) . '/file-manager-lib.pm' );

if ( !$in{'arch'} ) {
    redirect( 'list.cgi?path=' . urlize($path) . '&module=' . $in{'module'} );
}

my %errors;
my $command;
my $extension;

if ( $in{'method'} eq 'tar' ) {
    $command   = "tar czf " . quotemeta("$cwd/$in{'arch'}.tar.gz") . " -C " . quotemeta($cwd);
    $extension = ".tar.gz";
}
elsif ( $in{'method'} eq 'zip' ) {
    $command   = "cd " . quotemeta($cwd) . " && zip -r " . quotemeta("$cwd/$in{'arch'}.zip");
    $extension = ".zip";
}

foreach my $name ( split( /\0/, $in{'name'} ) ) {
    $name =~ s/$in{'cwd'}\///ig;
    $command .= " " . quotemeta($name);

    if (!-e ( $cwd . '/' . $name ) ) {
    	$errors{urlize($name)} = lc($text{'theme_xhred_global_no_target'});
    }
}

system_logged($command);

redirect( 'list.cgi?path=' . urlize($path) . '&module=' . $in{'module'} . '&error=' . get_errors( \%errors ) );
