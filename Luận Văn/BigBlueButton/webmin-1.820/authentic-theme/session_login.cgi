#!/usr/bin/perl

#
# Authentic Theme 18.10 (https://github.com/qooob/authentic-theme)
# Copyright 2014-2016 Ilia Rostovtsev <programming@rostovtsev.ru>
# Licensed under MIT (https://github.com/qooob/authentic-theme/blob/master/LICENSE)
#

do "authentic-theme/authentic-lib.pm";

get_miniserv_config( \%miniserv );

#Define page title
$title = $text{'session_header'};
if ( $gconfig{'showhost'} ) {
    $title = &get_display_hostname() . " : " . $title;
}

# Show pre-login text banner
if (   $gconfig{'loginbanner'}
    && get_env('http_cookie') !~ /banner=1/
    && !$in{'logout'}
    && !$in{'failed'}
    && !$in{'timed_out'} )
{

    print "Auth-type: auth-required=1\r\n";
    print "Set-Cookie: banner=1; path=/\r\n";
    &PrintHeader($charset);
    print '<!DOCTYPE HTML>', "\n";
    print '<html data-background-style="' . $__settings{'settings_background_color'} . '" class="session_login">', "\n";
    embed_login_head();
    print '<body class="session_login" data-style="' . get_filters('content') . '">' . "\n";
    print
        '<div class="form-signin-banner container session_login alert alert-danger"><i class="fa fa-3x fa-exclamation-triangle"></i><br><br>'
        . "\n";
    $url = $in{'page'};
    open( BANNER, $gconfig{'loginbanner'} );

    while (<BANNER>) {
        s/LOGINURL/$url/g;
        print;
    }

    close(BANNER);
    &footer();
    return;
}

$sec = lc( get_env('https') ) eq 'on' ? "; secure" : "";
$sidname = $miniserv{'sidname'} || "sid";
print "Auth-type: auth-required=1\r\n";
print "Set-Cookie: banner=0; path=/$sec\r\n"   if ( $gconfig{'loginbanner'} );
print "Set-Cookie: $sidname=x; path=/$sec\r\n" if ( $in{'logout'} );
print "Set-Cookie: redirect=1; path=/\r\n";
print "Set-Cookie: testing=1; path=/$sec\r\n";
$charset = &get_charset();
&PrintHeader($charset);
print '<!DOCTYPE HTML>', "\n";
print '<html data-background-style="' . $__settings{'settings_background_color'} . '" class="session_login">', "\n";
embed_login_head();
print '<body class="session_login" data-style="' . get_filters('content') . '">' . "\n";
print '<div class="container session_login">' . "\n";

if ( defined( $in{'failed'} ) ) {
    if ( $in{'twofactor_msg'} ) {
        print "<h3>",, "</h3><p></p>\n";
        print '<div class="alert alert-warning">' . "\n";
        print '<strong><i class ="fa fa-exclamation-triangle"></i> '
            . $Atext{'login_warning'}
            . '</strong><br />'
            . &Atext( 'session_twofailed', &html_escape( $in{'twofactor_msg'} ) ) . "\n";
        print '</div>' . "\n";
    }
    else {
        print '<div class="alert alert-warning">' . "\n";
        print '<strong><i class ="fa fa-exclamation-triangle"></i> ' . $Atext{'login_warning'} . '</strong><br />' . "\n";
        print $Atext{'session_failed'} . "\n";
        print '</div>' . "\n";
    }
}
elsif ( $in{'logout'} ) {
    print '<div class="alert alert-success">' . "\n";
    print '<strong><i class ="fa fa-check"></i> ' . $Atext{'login_success'} . '</strong><br />' . "\n";
    print $Atext{'session_logout'} . "\n";
    print '</div>' . "\n";
}
elsif ( $in{'timed_out'} ) {
    print '<div class="alert alert-warning">' . "\n";
    print '<strong><i class ="fa fa fa-exclamation-triangle"></i> ' . $Atext{'login_warning'} . '</strong><br />' . "\n";
    print &Atext( 'session_timed_out', int( $in{'timed_out'} / 60 ) ) . "\n";
    print '</div>' . "\n";
}
print "$text{'session_prefix'}\n";
print '<form method="post" target="_top" action="'
    . $gconfig{'webprefix'}
    . '/session_login.cgi" class="form-signin session_login clearfix" role="form" onsubmit="spinner()">' . "\n";

print '<i class="wbm-webmin"></i><h2 class="form-signin-heading">
     <span>'
    . (
      &get_product_name() eq 'webmin'
    ? $Atext{'theme_xhred_titles_wm'}
    : $Atext{'theme_xhred_titles_um'}
    ) . '</span></h2>' . "\n";

#Process logo
embed_logo();

# Login message
if ( $gconfig{'realname'} ) {
    $host = &get_display_hostname();
}
else {
    $host = get_env('server_name');
    $host =~ s/:\d+//g;
    $host = &html_escape($host);
}
print '<p class="form-signin-paragraph">' . &Atext('login_message') . '<strong> ' . $host . '</strong></p>' . "\n";
$tag = $gconfig{'noremember'} ? 'autocomplete="off"' : '';
print '<div class="input-group form-group">' . "\n";
print '<span class="input-group-addon"><i class="fa fa-fw fa-user"></i></span>' . "\n";
print '<input type="text" class="form-control session_login" name="user" autocomplete="off" placeholder="'
    . &Atext('login_user') . '" '
    . $tag
    . ' autofocus>' . "\n";
print '</div>' . "\n";
print '<div class="input-group form-group">' . "\n";
print '<span class="input-group-addon"><i class="fa fa-fw fa-lock"></i></span>' . "\n";
print '<input type="password" class="form-control session_login" name="pass" autocomplete="off" placeholder="'
    . &Atext('login_pass') . '"  '
    . $tag . '>' . "\n";
print '</div>' . "\n";

if ( $miniserv{'twofactor_provider'} ) {
    print '<div class="input-group form-group">' . "\n";
    print '<span class="input-group-addon"><i class="fa fa-fw fa-qrcode"></i></span>' . "\n";
    print '<input type="text" class="form-control session_login" name="twofactor" autocomplete="off" placeholder="'
        . &Atext('login_token') . '">' . "\n";
    print '</div>' . "\n";
}
if ( !$gconfig{'noremember'} ) {
    print '<div class="input-group form-group">
            <span class="awcheckbox awobject"><input class="iawobject" name="save" value="1" id="save" type="checkbox"> <label class="lawobject" for="save">'
        . $Atext{'login_save'}
        . '</label></span>
         </div>' . "\n";
}
print '<div class="form-group">';
print
    '<button class="btn btn-primary pull-left" type="submit" style="margin-top: 0 !important; width: 50%"><i class="fa fa-sign-in"></i>&nbsp;&nbsp;'
    . &Atext('login_signin')
    . '</button>' . "\n";
if ( -r $root_directory . "/virtualmin-password-recovery/index.cgi"
    && index( $miniserv{'anonymous'}, 'virtualmin-password-recovery' ) > -1 )
{
    print
        '<button onclick=\'window.open("/virtualmin-password-recovery", "password_recovery", "toolbar=no,menubar=no,scrollbars=no,resizable=yes,width=700,height=500");\' class="btn btn-warning pull-right" style="width: 50%" type="reset"><i class="fa fa-undo"></i>&nbsp;&nbsp;'
        . &Atext('login_reset')
        . '</button>' . "\n";
}
else {
    print
        '<button class="btn btn-danger pull-right" type="reset" style="width: 50%"><i class="fa fa-backup fa-1_25x"></i>&nbsp;&nbsp;'
        . &Atext('login_reset')
        . '</button>' . "\n";
}
print '<script>function spinner(){var x=$(".fa-sign-in"),s =\'<span class="cspinner_container" style="position: absolute; width: 18px; height: 14px; display: inline-block;"><span class="cspinner" style="margin-top: 2px; margin-left: -22px;"><span class="cspinner-icon white small"></span></span></span>\';x.addClass("invisible").after(s);x.parent(".btn").addClass("disabled")}</script>';
print '</div>';
print '</form>' . "\n";

&footer();
