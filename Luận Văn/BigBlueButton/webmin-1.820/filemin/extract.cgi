#!/usr/local/bin/perl

require './filemin-lib.pl';
use lib './lib';
use File::MimeInfo;

&ReadParse();

get_paths();

$archive_type = mimetype($cwd.'/'.$in{'file'});


if ( index( $archive_type, "x-bzip" ) != -1 ) {
    &backquote_logged( "tar xvjfp " . quotemeta("$cwd/$in{'file'}") . " -C " . quotemeta($cwd) );
    &redirect("index.cgi?path=$path");
}
elsif (index( $archive_type, "x-tar" ) != -1
    || index( $archive_type, "/gzip" ) != -1
    || index( $archive_type, "x-xz" ) != -1
    || index( $archive_type, "x-compressed-tar" ) != -1 )
{
    &backquote_logged( "tar xfp " . quotemeta("$cwd/$in{'file'}") . " -C " . quotemeta($cwd) );
    &redirect("index.cgi?path=$path");
}
elsif ( index( $archive_type, "x-7z" ) != -1 ) {
    &backquote_logged( "7z x " . quotemeta("$cwd/$in{'file'}") . " -o" . quotemeta($cwd) );
    &redirect("index.cgi?path=$path");
}
elsif ( index( $archive_type, "/zip" ) != -1 ) {
    &backquote_logged( "unzip " . quotemeta("$cwd/$in{'file'}") . " -d " . quotemeta($cwd) );
    &redirect("index.cgi?path=$path");
}
elsif ( index( $archive_type, "/x-rar" ) != -1 ) {
    &backquote_logged( "unrar x -r -y " . quotemeta("$cwd/$in{'file'}") . " " . quotemeta($cwd) );
    &redirect("index.cgi?path=$path");
}
elsif ( index( $archive_type, "/x-rpm" ) != -1 || index( $archive_type, "/x-deb" ) != -1 ) {
    my $dir = fileparse( "$cwd/$name", qr/\.[^.]*/ );
    my $path = quotemeta("$cwd/$dir");
    &backquote_logged("mkdir $path");
    if ( index( $archive_type, "/x-rpm" ) != -1 ) {
        &backquote_logged(
            "(rpm2cpio " . quotemeta("$cwd/$name") . " | (cd " . $path . "; cpio -idmv))" );
    }
    else {
        &backquote_logged( "dpkg -x " . quotemeta("$cwd/$name") . " " . $path );
    }
}

