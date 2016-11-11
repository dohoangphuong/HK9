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

my %errors;
my $error_fatal;

if ( !$in{'owner'} or !$in{'group'} ) {
    redirect( 'list.cgi?path=' . urlize($path) . '&module=' . $in{'module'} );
}

( my $login, my $pass, my $uid, my $gid ) = getpwnam( $in{'owner'} );
my $grid = getgrnam( $in{'group'} );
my $recursive;
if   ( $in{'recursive'} eq 'true' ) { $recursive = '-R'; }
else                                { $recursive = ''; }

if ( !defined $login ) {
    $errors{ $in{'owner'} } = $text{'error_user_not_found'};
    $error_fatal = 1;
}

if ( !defined $grid ) {
    $errors{ $in{'group'} } = $text{'error_group_not_found'};
    $error_fatal = 1;
}

if ( !scalar %errors ) {
    foreach $name ( split( /\0/, $in{'name'} ) ) {
        if ( system_logged( "chown $recursive $uid:$grid " . quotemeta("$cwd/$name") ) != 0 ) {
            $errors{urlize($name)} = lc("$text{'error_chown'}: $?");
        }
    }
}

redirect( 'list.cgi?path=' . urlize($path) . '&module=' . $in{'module'} . '&error=' . get_errors( \%errors ) . '&error_fatal=' . $error_fatal );

