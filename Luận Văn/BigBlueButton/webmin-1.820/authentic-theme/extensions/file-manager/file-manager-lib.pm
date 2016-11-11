#
# Authentic Theme 18.10 (https://github.com/qooob/authentic-theme)
# Copyright 2014-2016 Ilia Rostovtsev <programming@rostovtsev.ru>
# Licensed under MIT (https://github.com/qooob/authentic-theme/blob/master/LICENSE)
#

our %request_uri = get_request_uri();
set_module( $request_uri{'module'} );
get_libs( $request_uri{'module'} );

our %text = ( load_language($current_theme), %text );
our %text = ( load_language( $request_uri{'module'} ), %text );

our $checked_path;

sub set_module {
    my ($module) = @_;
    set_env( 'foreign_module_name', $module );
    set_env( 'foreign_root_directory', ( get_env('document_root') . '/' . $module ) );

}

sub get_libs {
    my ($module) = @_;

    use Cwd 'abs_path';
    use Encode qw(decode encode);
    use File::Basename;
    use File::MimeInfo;
    use POSIX;
    use JSON qw( decode_json );

    require( get_env('document_root') . '/' . $module . '/filemin-lib.pl' );

    &ReadParse();

    get_paths();

    if ( !$in{'error'} ) {
        set_response();
        set_response_count();
    }

    $checked_path = $path;
    if ( join( " , ", @allowed_paths ) ne '/' ) {
        $checked_path =~ s/$in{'cwd'}\//\//ig;
    }

}

sub get_errors {
    my %errors = %{ $_[0] };

    if ( scalar %errors ) {
        return JSON->new->latin1->encode( \%errors );
    }
    else {
        return undef;
    }

}

sub get_request_uri {
    ( my $uri = get_env('request_uri') ) =~ s/\?/&/;
    my @r = split /&/, $uri;
    my %c;

    foreach (@r) {
        my ( $k, $v ) = split /=/, $_;
        $c{$k} = $v;
    }

    return %c;
}

sub head {
    print "Content-type: text/html\n\n";
}

sub set_response {
    my ($c) = @_;
    print "Set-Cookie: file-manager-response=" . $c . "; path=/\r\n";
}

sub set_response_count {
    my ($c) = @_;
    print "Set-Cookie: file-manager-response_count=" . $c . "; path=/\r\n";
}

sub fatal_errors {
    my @errors = @_;

    head();
    print $text{'errors_occured'};
    print "<ul>";
    foreach $error (@errors) {
        print("<li>$error</li>");
    }
    print "</ul>";
}

sub print_error {
    my ($error) = @_;

    head();
    print $error;
    exit;

}

sub print_content {

    # Filter out not allowed entries
    if ( $remote_user_info[0] ne 'root' && $allowed_paths[0] ne '$ROOT' ) {

        # Leave only allowed
        for $path (@allowed_paths) {
            my $slashed = $path;
            $slashed .= "/" if ( $slashed !~ /\/$/ );
            push @tmp_list, grep { $slashed =~ /^$_\// || $_ =~ /$slashed/ } @list;
        }

        # Remove duplicates
        my %hash = map { $_, 1 } @tmp_list;
        @list = keys %hash;
    }

    # Get info about directory entries
    @info = map { [ $_, stat($_), mimetype($_), -d $_ ] } @list;

    # Filter out folders
    @folders = map {$_} grep { $_->[15] == 1 } @info;

    # Filter out files
    @files = map {$_} grep { $_->[15] != 1 } @info;

    # Sort stuff by name
    @folders = sort { $a->[0] cmp $b->[0] } @folders;
    @files   = sort { $a->[0] cmp $b->[0] } @files;

    # Recreate list
    undef(@list);
    push @list, @folders, @files;

    @allowed_for_edit = split( /\s+/, $access{'allowed_for_edit'} );
    %allowed_for_edit = map { $_ => 1 } @allowed_for_edit;

    # Set icons variables
    $edit_icon    = "<i class='fa fa-edit' alt='$text{'edit'}'></i>";
    $rename_icon  = "<i class='fa fa-font' title='$text{'rename'}'></i>";
    $extract_icon = "<i class='fa fa-external-link' alt='$text{'extract_archive'}'></i>";
    $goto_icon    = "<i class='fa fa-arrow-right' alt='$text{'goto_folder'}'></i>";

    $page      = 1;
    $pagelimit = 4294967295;

    my $info_total;
    my $info_files   = scalar @files;
    my $info_folders = scalar @folders;

    if ( $info_files eq 1 && $info_folders eq 1 ) {
        $info_total = 'filemanager_global_info_total1';
    }
    elsif ( $info_files ne 1 && $info_folders eq 1 ) {
        $info_total = 'filemanager_global_info_total2';
    }
    elsif ( $info_files eq 1 && $info_folders ne 1 ) {
        $info_total = 'filemanager_global_info_total3';
    }
    else {
        $info_total = 'filemanager_global_info_total4';
    }

    head();
    print '<!DOCTYPE html>';
    print '<html>';
    print '<head></head>';
    print '<body>';
    print "<div class='total'>" . text( $info_total, $info_files, $info_folders ) . "</div>";

    # Render current directory entries
    print &ui_form_start( "", "post", undef, "id='list_form'" );
    @ui_columns = ( '<input id="select-unselect" type="checkbox" onclick="selectUnselect(this)" />', '' );
    push @ui_columns, $text{'name'};
    push @ui_columns, $text{'type'} if ( $userconfig{'columns'} =~ /type/ );
    push @ui_columns, $text{'actions'};
    push @ui_columns, $text{'size'} if ( $userconfig{'columns'} =~ /size/ );
    push @ui_columns, $text{'owner_user'} if ( $userconfig{'columns'} =~ /owner_user/ );
    push @ui_columns, $text{'permissions'} if ( $userconfig{'columns'} =~ /permissions/ );
    push @ui_columns, $text{'last_mod_time'} if ( $userconfig{'columns'} =~ /last_mod_time/ );

    print &ui_columns_start( \@ui_columns );
    for ( my $count = 1 + $pagelimit * ( $page - 1 ); $count <= $pagelimit + $pagelimit * ( $page - 1 ); $count++ ) {
        if ( $count > scalar(@list) ) { last; }
        my $class = $count & 1 ? "odd" : "even";
        my $link = $list[ $count - 1 ][0];
        $link =~ s/\Q$cwd\E\///;
        $link =~ s/^\///g;
        $vlink = html_escape($link);
        $vlink = quote_escape($vlink);
        $vlink = decode( 'UTF-8', $vlink, Encode::FB_DEFAULT );
        $path  = html_escape($path);
        $vpath = quote_escape($vpath);
        $vpath = decode( 'UTF-8', $vpath, Encode::FB_DEFAULT );

        my $type = $list[ $count - 1 ][14];
        $type =~ s/\//\-/g;
        my $img = "images/icons/mime/$type.png";
        unless ( -e $request_uri{'module'} . '/' . $img ) { $img = "images/icons/mime/unknown.png"; }
        $size        = &nice_size( $list[ $count - 1 ][8] );
        $user        = getpwuid( $list[ $count - 1 ][5] ) ? getpwuid( $list[ $count - 1 ][5] ) : $list[ $count - 1 ][5];
        $group       = getgrgid( $list[ $count - 1 ][6] ) ? getgrgid( $list[ $count - 1 ][6] ) : $list[ $count - 1 ][6];
        $permissions = sprintf( "%04o", $list[ $count - 1 ][3] & 07777 );
        $mod_time    = POSIX::strftime( '%Y/%m/%d - %T', localtime( $list[ $count - 1 ][10] ) );

        $actions
            = "<a class='action-link' href='javascript:void(0)' onclick='renameDialog(\"$vlink\")' title='$text{'rename'}' data-container='body'>$rename_icon</a>";

        if ( $list[ $count - 1 ][15] == 1 ) {
            if ( $path eq '/' . $link ) {
                $href = "index.cgi?path=" . &urlize("$path");
            }
            else {
                $href = "index.cgi?path=" . &urlize("$path/$link");
            }
        }
        else {
            $href = "download.cgi?file=" . &urlize($link) . "&path=" . &urlize($path);
            if ( $0 =~ /search.cgi/ ) {
                ( $fname, $fpath, $fsuffix ) = fileparse( $list[ $count - 1 ][0] );
                if ( $base ne '/' ) {
                    $fpath =~ s/^\Q$base\E//g;
                }
                $actions
                    = "$actions<a class='action-link' "
                    . "href='index.cgi?path="
                    . &urlize($fpath) . "' "
                    . "title='$text{'goto_folder'}'>$goto_icon</a>";
            }
            if ( index( $type, "text-" ) != -1
                or exists( $allowed_for_edit{$type} ) )
            {
                $actions
                    = "$actions<a class='action-link' href='edit_file.cgi?file="
                    . &urlize($link)
                    . "&path="
                    . &urlize($path)
                    . "' title='$text{'edit'}' data-container='body'>$edit_icon</a>";
            }
            if (   ( index( $type, "application-zip" ) != -1 && has_command('unzip') )
                || ( index( $type, "application-x-7z-compressed" ) != -1 && has_command('7z') )
                || ( index( $type, "application-x-rar" ) != -1           && has_command('unrar') )
                || ( index( $type, "application-x-rpm" ) != -1 && has_command('rpm2cpio') && has_command('cpio') )
                || ( index( $type, "application-x-deb" ) != -1 && has_command('dpkg') )
                || ((      index( $type, "x-compressed-tar" ) != -1
                        || index( $type, "-x-tar" ) != -1
                        || ( index( $type, "-x-bzip" ) != -1 && has_command('bzip2') )
                        || ( index( $type, "-gzip" ) != -1   && has_command('gzip') )
                        || ( index( $type, "-x-xz" ) != -1   && has_command('xz') )
                    )
                    && has_command('tar')
                )
                )
            {
                $actions
                    = "$actions <a class='action-link' href='extract.cgi?path="
                    . &urlize($path)
                    . "&file="
                    . &urlize($link)
                    . "' title='$text{'extract_archive'}' data-container='body'>$extract_icon</a> ";
            }
        }
        @row_data
            = ( "<a href='$href'><img src=\"$img\"></a>", "<a href=\"$href\" data-filemin-path=\"$href\">$vlink</a>" );
        push @row_data, $type                if ( $userconfig{'columns'} =~ /type/ );
        push @row_data, $actions;
        push @row_data, $size                if ( $userconfig{'columns'} =~ /size/ );
        push @row_data, $user . ':' . $group if ( $userconfig{'columns'} =~ /owner_user/ );
        push @row_data, $permissions         if ( $userconfig{'columns'} =~ /permissions/ );
        push @row_data, $mod_time            if ( $userconfig{'columns'} =~ /last_mod_time/ );
        print &ui_checked_columns_row( \@row_data, "", "name", $vlink );
    }
    print ui_columns_end();
    print &ui_hidden( "path", $path ), "\n";
    print '</form>';
    print '<div class="error_message">' . $in{'error'} . '</div>'     if ( length $in{'error'} );
    print '<div class="error_fatal">' . $in{'error_fatal'} . '</div>' if ( length $in{'error_fatal'} );
    print '</body>';
    print '</html>';

}

sub paster {
    my ( $c, $f, $s, $d, $r, $m ) = @_;
    my $x;
    my $j = $c . '/' . $f;
    if ( !$r && -f $j ne -d $j ) {
        for ( my $t = 1; $t <= inf; $t += 1 ) {
            if ( !-e ( $j . '(' . $t . ')' ) ) {
                $x = $t;
                last;
            }
        }
    }
    if ( $m && index( $j, $s ) eq '0' ) {
        set_response('merr');
        return;
    }
    my ( $o, $e ) = copy_source_dest( $s, $j . ( !$x ? '' : '(' . $x . ')' ) );
    if ($x) {
        set_response('cc');
    }
    if ($m) {
        unlink_file($s);
    }

    return $e;

}

sub get_env {
    my ($key) = @_;
    return $ENV{ uc($key) };
}

sub set_env {
    my ( $k, $v ) = @_;
    $ENV{ uc($k) } = $v;
}

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

1;
