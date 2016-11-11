#
# Authentic Theme 18.10 (https://github.com/qooob/authentic-theme)
# Copyright 2014-2016 Ilia Rostovtsev <programming@rostovtsev.ru>
# Licensed under MIT (https://github.com/qooob/authentic-theme/blob/master/LICENSE)
#
#use strict;
#use warnings;
our ( %in, %text, %config );

BEGIN { push( @INC, ".." ); }
use WebminCore;
init_type();
init_config();

use lib 'authentic-theme/lib';
use JSON qw( decode_json );

do "authentic-theme/authentic-init.pm";

sub authentic {
    init();
    header($title);
    content();
    footer();
}

sub licenses {
    my ($id) = @_;
    if ( &foreign_available("virtual-server") && $id eq "vm" ) {
        my %virtualmin = &get_module_info("virtual-server");
        if ( $virtualmin{'version'} =~ /pro/i ) {
            return 1;
        }
        else {
            return 0;
        }
    }
    elsif ( &foreign_available("server-manager") && $id eq "cm" ) {
        my %cloudmin = &get_module_info("server-manager");
        if ( $cloudmin{'version'} =~ /pro/i ) {
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        return 0;
    }
}

sub print_category {
    my ( $c, $label ) = @_;
    $label = $c eq "others" ? $Atext{'left_others'} : $label;

    my %icon_table = (
        'webmin'            => 'fa-cog',
        'usermin'           => 'fa-cog',
        'settings'          => 'fa-cog',
        'global_setting'    => 'fa-cog',
        'cat_settings'      => 'fa-cog',
        'system'            => 'fa-wrench',
        'cat_system'        => 'fa-wrench',
        'servers'           => 'fa-rocket',
        'other'             => 'fa-gavel',
        'info'              => 'fa-info',
        'hardware'          => 'fa-hdd-o',
        'global_hardware'   => 'fa-hdd-o',
        'global_storage'    => 'fa-hdd-o',
        'cluster'           => 'fa-power-off',
        'global_cluster'    => 'fa-power-off',
        'unused'            => 'fa-puzzle-piece',
        'global_unused'     => 'fa-puzzle-piece',
        'mail'              => 'fa-envelope',
        'global_mail'       => 'fa-envelope',
        'email'             => 'fa-envelope',
        'global_email'      => 'fa-envelope',
        'login'             => 'fa-user',
        'global_login'      => 'fa-user',
        'apps'              => 'fa-rocket',
        'global_apps'       => 'fa-rocket',
        'custom'            => 'fa-wrench',
        'global_custom'     => 'fa-wrench',
        'net'               => 'fa-shield',
        'ip'                => 'fa-shield',
        'global_ip'         => 'fa-shield',
        'check'             => 'fa-user-md',
        'global_check'      => 'fa-user-md',
        'add'               => 'fa-plus',
        'global_add'        => 'fa-plus',
        'backup'            => 'fa-floppy-o',
        'global_backup'     => 'fa-floppy-o',
        'global_server',    => 'fa-cogs',
        'cat_server',       => 'fa-cogs',
        'global_system'     => 'fa-cogs',
        'global_delete'     => 'fa-plug',
        'cat_delete'        => 'fa-plug',
        'global_logs'       => 'fa-file-text',
        'cat_logs'          => 'fa-file-text',
        'global_services'   => 'fa-puzzle-piece',
        'cat_services'      => 'fa-puzzle-piece',
        'create_new'        => 'fa-plus',
        'global_gce'        => 'fa-google',
        'global_ec2'        => 'fa-cubes',
        'global_hosts'      => 'fa-globe',
        'global_virtualmin' => 'fa-sun-o',
        'global_owners'     => 'fa-users',
        'global_monitor'    => 'fa-desktop',
        'global_settings'   => 'fa-cloud',
        'cat_manage'        => 'fa-gavel',
        'cat_res'           => 'fa-share-alt',
        'global_admin'      => 'fa-key',
        'cat_admin'         => 'fa-key',
        'global_power'      => 'fa-power-off',
        'cat_power'         => 'fa-power-off',
    );
    my $icon = $icon_table{$c} || 'fa-link';

    if ($label) {

        # Show link to close or open catgory
        print '<li class="has-sub">' . "\n";
        print '<a href="#' . $c . '"><i class="fa ' . $icon . ' fa-fw"></i> <span>' . $label . '</span></a>' . "\n";
        print '</li>' . "\n";
    }
}

sub get_swith_mode {
    my ( $t_var_switch_m, $t_var_product_m );

    if (   &get_product_name() eq 'webmin'
        && &foreign_available("asterisk") )
    {
        $t_var_switch_m  = '2';
        $t_var_product_m = '5';
    }
    elsif (&get_product_name() eq 'usermin'
        && &foreign_available("mailbox") )
    {
        $t_var_switch_m  = '2';
        $t_var_product_m = '4';
    }
    elsif ( !&foreign_available("virtual-server") && !&foreign_available("server-manager")
        || &get_product_name() eq 'usermin'
        || $get_user_level eq '2' )
    {

        $t_var_switch_m  = '2';
        $t_var_product_m = '1';
    }
    elsif (&foreign_available("virtual-server")
        && &foreign_available("server-manager") )
    {
        $t_var_switch_m  = '3';
        $t_var_product_m = '3';
    }
    elsif (
        &foreign_available("virtual-server")
        || &foreign_available("server-manager") && ( !&foreign_available("virtual-server")
            || !&foreign_available("server-manager") )
        )
    {
        $t_var_switch_m  = '2';
        $t_var_product_m = '2';
    }

    return ( $t_var_switch_m, $t_var_product_m );
}

sub print_switch_webmin {
    print '<input class="dynamic" id="open_'
        . &get_product_name()
        . '" name="product-switcher" type="radio"'
        . ( $t_uri_virtualmin == -1 && $t_uri_cloudmin == -1 && $t_uri_webmail == -1 ? " checked" : "" ) . '>
        <label for="open_'
        . &get_product_name() . '">
                <i class="wbm-webmin wbm-sm"></i><span>'
        . (
          &get_product_name() eq 'webmin'
        ? $Atext{'theme_xhred_titles_wm'}
        : $Atext{'theme_xhred_titles_um'}
        ) . '</span></label>';
}

sub print_switch_dashboard {
    print '<input class="dynamic" id="open_dashboard" name="product-switcher" type="radio"'
        . ( $t_uri_dashboard != -1 ? " checked" : "" ) . '>
          <label for="open_dashboard" style="padding-top: 1px;">
          <i class="fa fa-asterisk __sysinfo_asterisk blinking-default hidden" style="position: absolute; font-size: 40%; margin-top: 1px; margin-left: 26px; color: #e4312d !important"></i><i class="fa fa-stack fa-area-chart"></i><span>'
        . $Atext{'theme_xhred_titles_dashboard'} . '</span></label>';
}

sub print_switch_virtualmin {
    print '<input class="dynamic" id="open_virtualmin" name="product-switcher" type="radio"'
        . ( $t_uri_virtualmin != -1 ? " checked" : "" ) . '>
          <label for="open_virtualmin">
          <i class="wbm-virtualmin wbm-sm"></i><span>'
        . $Atext{'theme_xhred_titles_vm'} . '</span></label>';
}

sub print_switch_cloudmin {
    print '<input class="dynamic" id="open_cloudmin" name="product-switcher" type="radio"'
        . ( $t_uri_cloudmin != -1 ? " checked" : "" ) . '>
          <label for="open_cloudmin">
          <i class="wbm-cloudmin wbm-sm"></i><span>'
        . $Atext{'theme_xhred_titles_cm'} . '</span></label>';
}

sub print_switch_webmail {
    print '<input class="dynamic" id="open_webmail" name="product-switcher" type="radio"'
        . ( $t_uri_webmail != -1 ? " checked" : "" ) . '>
          <label for="open_webmail">
          <i class="fa fa-stack fa-envelope"></i>
          <span>' . $Atext{'theme_xhred_titles_mail'} . '</span></label>';
}

sub print_switch_thirdlane {
    print '<input class="dynamic" id="open_thirdlane" id="open_cloudmin" name="product-switcher" type="radio">
          <label for="open_thirdlane">
          <img alt="" style="margin-left:3px; height:17px;" src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiIHZpZXdCb3g9IjAgMCA1MCA1MCIgZW5hYmxlLWJhY2tncm91bmQ9Im5ldyAwIDAgNTAgNTAiIHhtbDpzcGFjZT0icHJlc2VydmUiPjxnPjxnPjxwYXRoIGZpbGw9IiNGRkZGRkYiIHN0cm9rZT0iI0ZGRkZGRiIgc3Ryb2tlLXdpZHRoPSIwLjUiIHN0cm9rZS1taXRlcmxpbWl0PSIxMCIgZD0iTTI0LjksNDguOEMxMS44LDQ4LjgsMSwzOC4xLDEsMjQuOVMxMS44LDEsMjQuOSwxczIzLjksMTAuNywyMy45LDIzLjlTMzguMSw0OC44LDI0LjksNDguOHogTTI0LjksMy44Yy0xMS43LDAtMjEuMSw5LjUtMjEuMSwyMS4xczkuNSwyMS4xLDIxLjEsMjEuMWMxMS43LDAsMjEuMS05LjUsMjEuMS0yMS4xUzM2LjYsMy44LDI0LjksMy44eiIvPjwvZz48Zz48Zz48Zz48cGF0aCBmaWxsPSIjRkZGRkZGIiBzdHJva2U9IiNGRkZGRkYiIHN0cm9rZS13aWR0aD0iMC41IiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiIGQ9Ik0xNi42LDIwLjJjLTAuOCwwLTEuNC0wLjYtMS40LTEuNGMwLTAuOCwwLjYtMS40LDEuNC0xLjRjOC4yLDAsMTYuMy0yLDE2LjQtMi4xYzAuNy0wLjIsMS41LDAuMywxLjcsMWMwLjIsMC43LTAuMywxLjUtMSwxLjdDMzMuMywxOC4xLDI1LjEsMjAuMiwxNi42LDIwLjJ6Ii8+PC9nPjwvZz48Zz48Zz48cGF0aCBmaWxsPSIjRkZGRkZGIiBzdHJva2U9IiNGRkZGRkYiIHN0cm9rZS13aWR0aD0iMC41IiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiIGQ9Ik0xNi42LDI3LjRjLTAuOCwwLTEuNC0wLjYtMS40LTEuNHMwLjYtMS40LDEuNC0xLjRjOC4yLDAsMTYuMy0yLDE2LjQtMi4xYzAuNy0wLjIsMS41LDAuMywxLjcsMWMwLjIsMC43LTAuMywxLjUtMSwxLjdDMzMuMywyNS4zLDI1LjEsMjcuNCwxNi42LDI3LjR6Ii8+PC9nPjwvZz48Zz48Zz48cGF0aCBmaWxsPSIjRkZGRkZGIiBzdHJva2U9IiNGRkZGRkYiIHN0cm9rZS13aWR0aD0iMC41IiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiIGQ9Ik0xNi42LDM0LjZjLTAuOCwwLTEuNC0wLjYtMS40LTEuNGMwLTAuOCwwLjYtMS40LDEuNC0xLjRjOC4yLDAsMTYuMy0yLDE2LjQtMi4xYzAuNy0wLjIsMS41LDAuMywxLjcsMWMwLjIsMC43LTAuMywxLjUtMSwxLjdDMzMuMywzMi41LDI1LjEsMzQuNiwxNi42LDM0LjZ6Ii8+PC9nPjwvZz48L2c+PC9nPjwvc3ZnPg==">
          <span class="block">'
        . $Atext{'theme_xhred_titles_thirdlane'} . '</span></label>';
}

sub print_switch {
    my $o = (
        $__settings{'settings_switch_rdisplay'} ne 'true'
        ? 'd'
        : 'r'
    );

    print '<div class="switch-toggle switch-' . $t_var_switch_m . ' switch-mins">';
    if ( $t_var_product_m eq '1' ) {
        if ( $o eq 'd' ) {
            $get_user_level eq '2'
                ? print_switch_virtualmin()
                : print_switch_webmin();
            print_switch_dashboard();

        }
        else {

            print_switch_dashboard();
            $get_user_level eq '2'
                ? print_switch_virtualmin()
                : print_switch_webmin();
        }
    }
    if ( $t_var_product_m eq '2' ) {

        if ( $o eq 'd' ) {
            print_switch_webmin();
            &foreign_available("virtual-server")
                ? print_switch_virtualmin()
                : print_switch_cloudmin();

        }
        else {
            &foreign_available("virtual-server")
                ? print_switch_virtualmin()
                : print_switch_cloudmin();
            print_switch_webmin();

        }

    }
    if ( $t_var_product_m eq '3' ) {
        if ( $o eq 'd' ) {
            print_switch_webmin();
            print_switch_virtualmin();
            print_switch_cloudmin();

        }
        else {
            print_switch_cloudmin();
            print_switch_virtualmin();
            print_switch_webmin();

        }
    }
    if ( $t_var_product_m eq '4' ) {

        if ( $o eq 'd' ) {
            print_switch_webmail();
            print_switch_webmin();
        }
        else {
            print_switch_webmin();
            print_switch_webmail();
        }

    }
    if ( $t_var_product_m eq '5' ) {

        if ( $o eq 'd' ) {
            print_switch_webmin();
            print_switch_thirdlane();
        }
        else {
            print_switch_thirdlane();
            print_switch_webmin();
        }

    }
    print '<a></a>
            </div><br style="line-height:4.4">';
}

sub print_category_link {
    my ( $link, $label, $state ) = @_;
    print '<li' . ( $state && ' class="hidden"' ) . '>' . "\n";
    print '<a target="page" href="' . $link . '"> ' . $label . '</a>' . "\n";
    print '</li>' . "\n";
}

sub print_sysinfo_link {
    if ( dashboard_switch() ne '1' ) {
        print '<li><a target="page" data-href="'
            . $gconfig{'webprefix'}
            . '/sysinfo.cgi" class="navigation_module_trigger'
            . ( $__settings{'settings_sysinfo_link_mini'} ne 'false' && ' hidden' )
            . '"><i class="fa fa-asterisk __sysinfo_asterisk blinking-default hidden" style="position: absolute; font-size: 40%; margin-top: -3px; margin-left: 8px;"></i><i class="fa fa-fw fa-info"></i> <span>'
            . $Atext{'left_home'}
            . '</span></a></li>' . "\n";
    }
}

sub print_sysinfo_warning {
    my (@info) = @_;

    # Show notifications first
    @info = sort { ( $b->{'type'} eq 'warning' ) <=> ( $a->{'type'} eq 'warning' ) } @info;
    print '<br>';
    foreach my $info (@info) {
        if ( $info->{'type'} eq 'warning' ) {
            print &ui_alert_box( $info->{'warning'}, $info->{'level'} || 'warn', undef, 1 );
        }
    }
}

sub print_extended_sysinfo {
    my (@info) = @_;
    if (@info) {
        print '<div class="panel-group" id="extended_sysinfo" role="tablist" aria-multiselectable="true">';
        foreach my $info (@info) {
            if (   $info->{'id'} ne 'domain'
                && $info->{'id'} ne 'notifications'
                && $info->{'type'} ne 'link'
                && $info->{'module'} ne 'mailbox'
                && $info->{'module'} ne 'system-status'
                && $a->{'type'} ne 'warning'
                && $b->{'type'} ne 'warning' )
            {
                our $charts_not_supported = 'no';
                if ( $info->{'type'} eq 'chart' ) {
                    foreach my $t ( @{ $info->{'chart'} } ) {
                        if ( $t->{'chart'}[0] < 0 || $t->{'chart'}[1] < 0 ) {
                            $charts_not_supported = 'yes';
                        }
                    }
                }

                if ( $info->{'id'} && $charts_not_supported eq 'no' ) {

                    my $open
                        = $info->{'open'}
                        ? ' in'
                        : ( $__settings{'settings_sysinfo_expand_all_accordions'} eq 'true' ? ' in' : '' );

                    print '
                    <div data-sorter="'
                        . $info->{'module'}
                        . '" class="panel panel-default'
                        . (
                        $__settings{'settings_animation_tabs'} ne 'false'
                        ? ''
                        : ' disable-animations'
                        )
                        . '">
                        <div class="panel-heading" role="tab" id="'
                        . $info->{'id'} . '-' . $info->{'module'} . '">
                          <h4 class="panel-title">
                            <a data-toggle="collapse" href="#'
                        . $info->{'id'} . '-'
                        . $info->{'module'}
                        . '-collapse" aria-expanded="true" aria-controls="'
                        . $info->{'id'} . '-'
                        . $info->{'module'}
                        . '-collapse">
                              ' . $info->{'desc'} . '
                            </a>
                          </h4>
                        </div>
                    <div id="'
                        . $info->{'id'} . '-'
                        . $info->{'module'}
                        . '-collapse" class="panel-collapse collapse'
                        . $open
                        . '" role="tabpanel" aria-labelledby="'
                        . $info->{'id'} . '-'
                        . $info->{'module'} . '">
                      <div class="panel-body">';

                    print
                        '<div class="table-responsive" style="width:99.8%"><table class="table table-striped table-hover"><tbody>';

                    if ($info->{'type'} eq 'table'
                        && (   $info->{'module'} ne 'system-status'
                            && $info->{'type'} ne 'link'

                        )
                        )
                    {

                        foreach my $t ( @{ $info->{'table'} } ) {
                            my $__checkmark = '<i class="fa fa-fw fa-lg fa-check text-success"></i>';
                            my $__stop      = '<i class="fa fa-fw fa-lg fa-times-circle text-danger"></i>';
                            my $__down      = '<i class="fa fa-fw fa-lg fa-minus-circle text-danger"></i>';
                            my $__start     = '<i class="fa fa-fw fa-lg fa-play text-success"></i>';
                            my $__restart   = '<i class="fa fa-fw fa-lg fa-refresh text-info"></i>';

                            $t->{"value"} =~ s/<img src='\/virtual-server\/images\/up.gif'.*?>/$__checkmark/g;
                            $t->{"value"} =~ s/<img src='\/virtual-server\/images\/stop.png'.*?>/$__stop/g;
                            $t->{"value"} =~ s/<img src='\/virtual-server\/images\/down.gif'.*?>/$__down/g;
                            $t->{"value"} =~ s/<img src='\/virtual-server\/images\/start.png'.*?>/$__start/g;
                            $t->{"value"} =~ s/<img src='\/virtual-server\/images\/reload.png'.*?>/$__restart/g;

                            print '<tr>
                                <td>' . $t->{"desc"} . '</td>
                                <td>'
                                . $t->{"value"} . '</td>
                              </tr>';
                        }
                    }
                    elsif ( $info->{'type'} eq 'chart' ) {
                        foreach my $t ( @{ $info->{'chart'} } ) {
                            my $percent       = '&nbsp;' . $t->{'chart'}[1] . '%';
                            my $percent_width = $t->{'chart'}[1];
                            my $dd            = $Atext{'right_out'};
                            $dd =~ s/\s|&nbsp;|\$1|\$2//g;

                            if ( index( $t->{"value"}, $dd ) == -1 ) {
                                $percent       = '&nbsp;' . $Atext{'right_unlimited'};
                                $percent_width = '0';
                            }

                            print '<tr>
                                <td style="width:25%">'
                                . $t->{"desc"} . '</td>
                                <td style="width:60%">
                                <div class="graph-container">
                                    <div class="graph">
                                        <strong class="bar" style="width:'
                                . $percent_width . '%;">' . $percent . '</strong>
                                    </div>
                                </div>
                                </td>
                                      <td style="width:15%">'
                                . $t->{"value"} . '</td>
                              </tr>';
                        }
                    }
                    elsif ( $info->{'type'} eq 'html' ) {
                        $info->{'html'} =~ s/<script[^>]*>.*?<\/script>//igs;
                        print $info->{'html'};
                    }
                    print '</tbody></table></div>';

                    print '</div>
                    </div>
                </div>';

                }
            }
        }
        print '</div><br><br><br><br>';
    }

}

sub print_sysstat_link {
    my $link;
    if ( $get_user_level eq '0'
        && ( $t_uri_cloudmin != -1 || $t_uri_virtualmin != -1 ) )
    {
        if ( $t_uri_cloudmin == -1
            && -d $root_directory . "/virtual-server/timeplot" )
        {
            $link = 'virtual-server';
        }
        elsif ( $t_uri_cloudmin != -1
            && -d $root_directory . "/server-manager/timeplot" )
        {
            $link = 'server-manager';
        }
        if ($link) {
            print '<li><a target="page" data-href="'
                . $gconfig{'webprefix'} . '/'
                . $link
                . '/history.cgi" class="navigation_module_trigger"><i class="fa fa-fw fa-area-chart"></i> <span>'
                . $Atext{'left_statistics'}
                . '</span></a></li>' . "\n";
        }
    }
}

sub print_search {
    if ( -r "$root_directory/webmin_search.cgi" && $gaccess{'webminsearch'} ) {
        print
            '<li class="menu-container"><form id="webmin_search_form" action="webmin_search.cgi" target="page" role="search">'
            . "\n";
        print '<div class="form-group">' . "\n";
        if ( $t_uri_virtualmin != -1 ) {
            print '<input type="hidden" class="form-control" name="mod" value="virtual-server">' . "\n";
        }
        if ( $t_uri_cloudmin != -1 ) {
            print '<input type="hidden" class="form-control" name="mod" value="server-manager">' . "\n";
        }

        if (   ( &get_product_name() == 'webmin' || &get_product_name() == 'usermin' )
            && $t_uri_virtualmin == -1
            && $t_uri_cloudmin == -1 )
        {
            $_search = ucfirst( &get_product_name() );
        }
        elsif ( $t_uri_virtualmin != -1 ) {
            $_search = 'Virtualmin';
        }
        elsif ( $t_uri_cloudmin != -1 ) {
            $_search = 'Cloudmin';
        }
        print
            '<i class="fa fa-search"></i><input type="text" class="form-control sidebar-search" name="search" placeholder="'
            . $Atext{'left_search'} . '"">' . "\n";
        print '</div>' . "\n";
        print '</form></li>' . "\n";
    }
    else {
        print '<br>';
    }
}

sub add_webprefix {
    my ($link) = @_;
    if ( substr( $link, -5 ) eq '&amp;' ) {
        $link = substr( $link, 0, -5 );
    }
    return $link =~ /^\// ? $gconfig{'webprefix'} . $link : $link;
}

sub print_left_menu {
    my ( $module, $items, $group, $id, $selected, $xhr ) = @_;
    my $__hr = 0;
    foreach my $item (@$items) {
        if ( $module eq $item->{'module'} || $group ) {

            my $link = add_webprefix( $item->{'link'} );
            my $icon;

            if (   $item->{'type'} eq 'item'
                && $link ne "/virtual-server/edit_lang.cgi"
                && $link ne "/virtual-server/edit_lang.cgi"
                && $link ne "/virtual-server/history.cgi" )
            {

                # Define an icon for the link/accordion
                if (   $link eq "/virtual-server/index.cgi"
                    || $link eq "/server-manager/index.cgi" )
                {
                    $icon = '<i class="fa fa-fw fa-tasks"></i>';
                }
                elsif ($link eq "/mailbox/list_folders.cgi"
                    || $link eq "/mailbox/list_ifolders.cgi" )
                {
                    $icon = '<i class="fa fa-fw fa-folder"></i>';
                }
                elsif ( $link eq "/mailbox/list_addresses.cgi" ) {
                    $icon = '<i class="fa fa-fw fa-users"></i>';
                }
                elsif ( $link eq "/filter/edit_forward.cgi" ) {
                    $icon = '<i class="fa fa-fw fa-share"></i>';
                }
                elsif ( $link eq "/filter/edit_auto.cgi" ) {
                    $icon = '<i class="fa fa-fw fa-reply-all"></i>';
                }
                elsif ( $link eq "/filter/" ) {
                    $icon = '<i class="fa fa-fw fa-filter"></i>';
                }
                elsif ( $link eq "/mailbox/edit_sig.cgi" ) {
                    $icon = '<i class="fa fa-fw fa-pencil"></i>';
                }
                elsif ( index( $link, 'mailbox/index.cgi?id=' ) > -1 ) {
                    $icon = '<i class="fa fa-fw fa-folder-o"></i>';
                }
                if ( $get_user_level == 1 ) {
                    if (   index( $link, '/virtual-server/edit_pass.cgi' ) > -1
                        && index( $link, '/virtual-server/edit_pass.cgi?' ) == -1 )
                    {
                        $icon = '<i class="fa fa-fw fa-ticket"></i>';
                    }
                    elsif ( index( $link, '/virtual-server/edit_newplan.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-list"></i>';
                    }
                    elsif ( index( $link, '/virtual-server/edit_newresels.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-cog"></i>';
                    }
                }

                if ( $__settings{'settings_leftmenu_singlelink_icons'} ne 'false' ) {
                    if ( index( $link, '/virtual-server/domain_form.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-plus-square-o"></i>';
                    }

                    elsif (index( $link, '/virtual-server/edit_domain.cgi' ) > -1
                        || index( $link, '/server-manager/edit_serv.cgi' ) > -1 )
                    {
                        $icon = '<i class="fa fa-fw fa-pencil-square-o"></i>';
                    }
                    elsif ( index( $link, '/virtual-server/view_domain.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-info-circle"></i>';
                    }

                    elsif ( index( $link, '/virtual-server/list_users.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-users"></i>';
                    }
                    elsif ( index( $link, '/virtual-server/list_aliases.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-envelope-o"></i>';
                    }
                    elsif ( index( $link, '/virtual-server/list_databases.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-database"></i>';
                    }
                    elsif (index( $link, '/virtual-server/list_scripts.cgi' ) > -1
                        || index( $link, '/server-manager/mass_update_form.cgi' ) > -1 )
                    {
                        $icon = '<i class="fa fa-fw fa-archive"></i>';
                    }

                    elsif ( index( $link, '/virtual-server/edit_html.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-globe"></i>';
                    }
                    elsif ( index( $link, '/server-manager/edit_pass.cgi' ) > -1 ) {
                        $icon = '<i class="fa fa-fw fa-key"></i>';
                    }
                    elsif ( index( $link, '/server-manager/save_serv.cgi' ) > -1 ) {
                        if ( index( $link, 'refresh=1' ) > -1 ) {
                            $icon = '<i class="fa fa-fw fa-refresh"></i>';
                        }
                        elsif ( index( $link, 'regen=1' ) > -1 ) {
                            $icon = '<i class="fa fa-fw fa-retweet"></i>';
                        }
                    }
                    elsif ($link =~ /^http:\/\//
                        || $link =~ /^https:\/\//
                        || $link =~ /^ftp:\/\//
                        || $link =~ /^ftps:\/\// )
                    {
                        $icon = '<i class="fa fa-fw fa-external-link"></i>';
                    }

                }

                # Set variable in case it hasn't been set before
                if ( !length $link ) {
                    $icon = undef;
                }

                if (   $link
                    && index( $link, '/virtual-server/list_scripts.cgi' ) == -1
                    && index( $link, '/virtual-server/edit_html.cgi' ) == -1
                    && index( $link, '/virtual-server/list_buckets.cgi' ) == -1
                    || ((   $__settings{'settings_leftmenu_vm_installscripts'} ne 'false'
                            && index( $link, '/virtual-server/list_scripts.cgi' ) > -1
                        )
                        || ( $__settings{'settings_leftmenu_vm_webpages'} ne 'false'
                            && index( $link, '/virtual-server/edit_html.cgi' ) > -1 )
                        || ( $__settings{'settings_leftmenu_vm_backup_amazon'} ne 'false'
                            && index( $link, '/virtual-server/list_buckets.cgi' ) > -1 )
                    )
                    )
                {
                    if ( $id eq 'cat_webmin' ) {
                        substr( $link, 0, 1, "" )
                            if "/" eq substr( $link, 0, 1 );
                    }
                    print '<li'
                        . (
                        $item->{'target'}
                        ? ' class="navigation_external"'
                        : ''
                        ) . '>' . "\n";
                    print '<a target="'
                        . ( $item->{'target'} ? '_blank' : 'page' ) . '" '
                        . (
                        ( !$group && !$item->{'target'} )
                        ? "class=\"navigation_module_trigger\" data-"
                        : ''
                        )
                        . 'href="'
                        . $link . '">'
                        . ( index( $icon, '<i ' ) > -1 ? $icon : '' )
                        . ' <span>'
                        . $item->{'desc'}
                        . '</span></a>' . "\n";
                    print '</li>' . "\n";
                    print "\n";
                }

            }
            elsif ( $item->{'type'} eq 'html' ) {
                print '<li class="menu-container menu-status hidden">' . $item->{'html'} . '</li>';
            }
            elsif ( $item->{'type'} eq 'cat' ) {
                my $c = $item->{'id'};
                if ( $item->{'module'} ne 'mailbox' ) {
                    &print_category( $c, $item->{'desc'} );
                }
                print '<li class="sub-wrapper"><ul class="sub" style="display: none;" id="' . $c . '">' . "\n";
                print_left_menu( $module, $item->{'members'}, 1, $c );
                if (   $c eq 'global_setting'
                    || $c eq 'global_settings' && &foreign_available("webmin") )
                {
                    &print_category_link( "/webmin/edit_themes.cgi",
                        $Atext{'settings_right_theme_left_configuration_title'}, 1 );
                    &print_category_link( "/settings-editor_read.cgi",
                        $Atext{'settings_right_theme_left_extensions_title'}, 1 );
                    &print_category_link( "/settings-upload.cgi", $Atext{'settings_right_theme_left_logo_title'}, 1 );
                }
                print "</ul></li>\n";
            }
            elsif ( $item->{'type'} eq 'hr' ) {
                if ( $__hr eq '1' ) {
                    print_search();
                }
                $__hr++;
            }
            elsif ( ( $item->{'type'} eq 'menu' || $item->{'type'} eq 'input' )
                && $item->{'module'} ne 'mailbox' )
            {
                # For with an input of some kind
                if ( $item->{'cgi'} ) {
                    print "<li class=\"menu-container\"><form action='$item->{'cgi'}' target=page>\n";
                }
                else {
                    print "<li class=\"menu-container\"><form>\n";
                }
                foreach my $h ( @{ $item->{'hidden'} } ) {
                    print ui_hidden(@$h);
                }

                print $item->{'desc'}, "\n";
                if ( $item->{'type'} eq 'menu' || $item->{'type'} eq 'input' ) {
                    my $default = get_default_target();
                    print ui_select(
                        (     $item->{'name'} eq 'dname' ? 'dom'
                            : $item->{'name'}
                        ),
                        (   ( ( $selected || $selected == 0 ) && $xhr ) ? $selected
                            : (   $default ? $default
                                : $item->{'value'}
                            )
                        ),
                        (   $item->{'name'} eq 'dname'
                            ? [ map { [ $_->{'id'}, &virtual_server::show_domain_name($_) ] }
                                grep { &virtual_server::can_edit_domain($_) }
                                sort { $a->{'dom'} cmp $b->{'dom'} } &virtual_server::list_domains()
                                ]
                            : $item->{'menu'}
                        ),
                        1, 0, 0, 0,
                        "data-autocomplete-title=\"
                            "
                            . (
                            index( $t_uri__i, 'virtualmin' ) != -1
                            ? $Atext{'right_fdoms'}
                            : $Atext{'right_fvm2'}
                            )
                            . "
                            \" "
                            . "style='width:"
                            . (
                            (     $__settings{'settings_leftmenu_width'}
                                ? $__settings{'settings_leftmenu_width'}
                                : '260'
                            ) - 24
                            )
                            . "px; margin-top: 0 !important' disabled"
                    );

                }
                print "</form></li>\n";
            }
        }
    }
}

sub print_easypie_charts {
    my ( $cpu_percent, $mem_percent, $virt_percent, $disk_percent ) = @_;

    print '<div class="row" style="margin: 0;">' . "\n";
    my $columns = '3';

    # CPU usage
    print_easypie_chart( $columns, ( ( $cpu_percent || $cpu_percent eq "0" ) ? $cpu_percent : 'NaN' ),
        $Atext{'body_cp'}, 'sysinfo_cpu_percent' );

    # Memory allocation
    print_easypie_chart(
        $columns,
        ( ( $mem_percent || $mem_percent eq "0" ) ? $mem_percent : 'NaN' ),
        (   ( $current_lang eq 'ru' || $current_lang eq 'ru.UTF-8' )
            ? $Atext{'body_real2'}
            : $Atext{'body_real'}
        ),
        'sysinfo_mem_percent'
    );
    print_easypie_chart(
        $columns,
        ( ( $virt_percent || $virt_percent eq "0" ) ? $virt_percent : 'NaN' )
        ,    # -sin(9**9**9)
        (   ( $current_lang eq 'ru' || $current_lang eq 'ru.UTF-8' )
            ? $Atext{'body_virt2'}
            : $Atext{'body_virt'}
        ),
        'sysinfo_virt_percent'
    );

    # Disk usage
    print_easypie_chart(
        $columns,
        ( ( $disk_percent || $disk_percent eq "0" ) ? $disk_percent : 'NaN' ),
        (   ( $current_lang eq 'ru' || $current_lang eq 'ru.UTF-8' )
            ? $Atext{'body_disk2'}
            : $Atext{'body_disk'}
        ),
        'sysinfo_disk_percent'
    );

    print '</div>' . "\n";
}

sub print_easypie_chart {
    my ( $columns, $percent, $label, $id ) = @_;
    print '<div class="col-xs-6 col-sm-' . $columns . ' text-center">' . "\n";
    print '<span class="piechart" data-charts="' . $id . '" data-percent="' . $percent . '">
        <span class="percent"></span>
        <span class="label">' . $label . '</span>
    </span>';
    print '</div>' . "\n";
}

sub get_sysinfo_vars {

    if ( &foreign_available("system-status") ) {

        # Ask status module for collected info
        &foreign_require("system-status");
        my ($info) = &system_status::get_collected_info();

        # Define used vars
        my ($cpu_percent,        $mem_percent,             $virt_percent,    $disk_percent,
            $host,               $os,                      $webmin_version,  $virtualmin_version,
            $cloudmin_version,   $authentic_theme_version, $local_time,      $kernel_arch,
            $cpu_type,           $cpu_temperature,         $hdd_temperature, $uptime,
            $running_proc,       $load,                    $real_memory,     $virtual_memory,
            $disk_space,         $package_message,         $csf_title,       $csf_data,
            $csf_remote_version, $authentic_remote_version
        );

        # Require memory information
        if ( $info->{'mem'} ) {
            @m = @{ $info->{'mem'} };
        }

        # Easypie charts numbers
        if ( $info->{'cpu'} ) {
            @c           = @{ $info->{'cpu'} };
            $cpu_percent = $c[0] + $c[1] + $c[3];
            $cpu_percent = int($cpu_percent);
        }
        if ( @m && $m[0] ) {
            $mem_percent = ( $m[0] - $m[1] ) / $m[0] * 100;
            $mem_percent = int($mem_percent);
        }
        if ( @m && $m[2] ) {
            $virt_percent = ( $m[2] - $m[3] ) / $m[2] * 100;
            $virt_percent = int($virt_percent);
        }
        if ( $info->{'disk_total'} ) {
            ( $total, $free )
                = ( $info->{'disk_total'}, $info->{'disk_free'} );
            $disk_percent = ( $total - $free ) / $total * 100;
            $disk_percent = int($disk_percent);
        }

        # Operation system
        my $ip
            = $info->{'ips'}
            ? $info->{'ips'}->[0]->[0]
            : &to_ipaddress( get_system_hostname() );
        $ip = " ($ip)" if ($ip);
        my $host = &get_system_hostname() . $ip;
        if ( &foreign_available("net") ) {
            $host = '<a href="' . $gconfig{'webprefix'} . '/net/list_dns.cgi">' . $host . '</a>';
        }

        # Operating System Info
        if ( $gconfig{'os_version'} eq '*' ) {
            $os = $gconfig{'real_os_type'};
        }
        else {
            $os = $gconfig{'real_os_type'} . ' ' . $gconfig{'real_os_version'};
        }

        #Webmin version
        $webmin_version
            = &get_webmin_version()
            . ' <div class="btn-group margined-left-4"><a class="btn btn-default btn-xxs btn-hidden hidden" title="'
            . $Atext{'theme_sysinfo_wmdocs'}
            . '" href="http://doxfer.webmin.com" target="_blank"><i class="fa fa-fwh fa-book"></i></a></div>';

        # Virtualmin version
        if ($has_virtualmin) {
            my ( $vs_license, $__virtual_server_version );
            my %vinfo = &get_module_info("virtual-server");

            $vs_license = licenses('vm');

            $__virtual_server_version = $vinfo{'version'};
            $__virtual_server_version =~ s/.gpl//igs;

            $virtualmin_version = (
                $__virtual_server_version . " " . (
                    $vs_license eq '0'
                    ? ''
                    : 'Pro'

                        . ' <div class="btn-group margined-left-4"><a class="btn btn-default btn-xxs btn-hidden hidden" title="'
                        . $Atext{'theme_sysinfo_vmdocs'}
                        . '" href="http://www.virtualmin.com/documentation" target="_blank"><i class="fa fa-book"></i></a>'
                        . (
                        ( $vs_license eq '1' )
                        ? ' <a class="btn btn-default btn-xxs btn-hidden hidden" title="'
                            . $Atext{'right_vlcheck'}
                            . '" href="'
                            . $gconfig{'webprefix'}
                            . '/virtual-server/licence.cgi"><i class="fa fa-refresh"></i></a></div>'
                        : '</div>'
                        )

                )
            );
        }

        # Cloudmin version
        if ($has_cloudmin) {
            my ( $vm2_license, $__server_manager_version );
            my %vinfo = &get_module_info("server-manager");

            $vm2_license = licenses('cm');

            $__server_manager_version = $vinfo{'version'};
            $__server_manager_version =~ s/.gpl//igs;

            $cloudmin_version = (
                $__server_manager_version . " " . (
                    $vm2_license eq '0'
                    ? ''
                    : 'Pro'

                        . ' <div class="btn-group margined-left-4"><a class="btn btn-default btn-xxs btn-hidden hidden" title="'
                        . $Atext{'theme_sysinfo_cmdocs'}
                        . '" href="http://www.virtualmin.com/documentation/cloudmin" target="_blank"><i class="fa fa-book"></i></a>'
                        . (
                        ( $vm2_license eq '1' )
                        ? ' <a class="btn btn-default btn-xxs btn-hidden hidden" title="'
                            . $Atext{'right_slcheck'}
                            . '" href="'
                            . $gconfig{'webprefix'}
                            . '/server-manager/licence.cgi"><i class="fa fa-refresh"></i></a></div>'
                        : '</div>'
                        )

                )
            );
        }

        #
        # Theme version/updates
        get_authentic_version();

        $authentic_remote_version = $remote_version;

        # Build version response message
        if ( $remote_version <= $installed_version ) {
            do "authentic-theme/changelog.pm";
            $authentic_theme_version
                = '<a href="https://github.com/qooob/authentic-theme" target="_blank">'
                . $Atext{'theme_name'} . '</a> '
                . $installed_version
                . '<div class="btn-group margined-left-4"><a href="'
                . $gconfig{'webprefix'}
                . '/webmin/edit_themes.cgi" data-href="'
                . $gconfig{'webprefix'}
                . '/webmin/edit_themes.cgi" class="btn btn-default btn-xxs btn-hidden hidden" title="'
                . $Atext{'settings_right_theme_configurable_options_title'}
                . '"><i class="fa fa-cogs"></i></a> '
                . '<a data-href="#theme-info" class="btn btn-default btn-xxs btn-hidden hidden"><i class="fa fa-info-circle"></i></a></div>';
        }
        else {
            $authentic_theme_version
                = '<a href="https://github.com/qooob/authentic-theme" target="_blank">'
                . $Atext{'theme_name'} . '</a> '
                . $installed_version . '. '
                . $Atext{'theme_update_available'} . ' '
                . $remote_version
                . '&nbsp;&nbsp;&nbsp;<div class="btn-group margined-left-4">'
                . '<a class="btn btn-xxs btn-success authentic_update" href="'
                . $gconfig{'webprefix'}
                . '/webmin/edit_themes.cgi"><i class="fa fa-fw fa-refresh">&nbsp;</i>'
                . $Atext{'theme_update'} . '</a>'
                . '<a class="btn btn-xxs btn-info" target="_blank" href="https://github.com/qooob/authentic-theme/blob/master/CHANGELOG.md"><i class="fa fa-fw fa-pencil-square-o">&nbsp;</i>'
                . $Atext{'theme_changelog'} . '</a>'
                . '<a class="btn btn-xxs btn-warning" target="_blank" href="https://raw.githubusercontent.com/qooob/authentic-theme/master/.build/authentic-theme-latest.wbt.gz"><i class="fa fa-fw fa-download">&nbsp;</i>'
                . $Atext{'theme_download'} . '</a>'
                . '<a class="btn btn-xxs btn-primary" href="'
                . $gconfig{'webprefix'}
                . '/webmin/edit_themes.cgi" data-href="'
                . $gconfig{'webprefix'}
                . '/webmin/edit_themes.cgi" ><i class="fa fa-fw fa-cogs">&nbsp;</i>'
                . $Atext{'settings_right_options'} . '</a>'
                . '</div>';
        }

        #System time
        use Time::Local;
        my ( $_time, $local_time );
        $_time      = time();
        $local_time = '<span data-convertible-timestamp-full="' . $_time . '" >' . localtime($_time) . '</span>';
        if ( &foreign_available("time") ) {
            $local_time
                = '<a data-convertible-timestamp-full="'
                . $_time
                . '" href='
                . $gconfig{'webprefix'}
                . '/time/>'
                . $local_time . '</a>';
        }

        # Kernel and arch
        if ( $info->{'kernel'} ) {
            $kernel_arch = &Atext(
                'body_kernelon',                $info->{'kernel'}->{'os'},
                $info->{'kernel'}->{'version'}, $info->{'kernel'}->{'arch'}
            );
        }

        # CPU Type and cores
        if ( $info->{'load'} ) {
            @c = @{ $info->{'load'} };
            if ( @c > 3 ) {
                $cpu_type = &Atext( 'body_cputype', @c );
            }
        }

        # Temperatures
        if ( $info->{'cputemps'} ) {
            foreach my $t ( @{ $info->{'cputemps'} } ) {
                $cpu_temperature
                    .= '<span class="badge-custom badge-drivestatus badge-cpustatus" style="margin-right:3px; margin-bottom: 3px"> Core '
                    . $t->{'core'} . ': '
                    . int( $t->{'temp'} )
                    . '&#176;C</span>'
                    . ( $__settings{'settings_sysinfo_drive_status_on_new_line'} eq 'true' ? '<br>' : '&nbsp;' );
            }
        }
        if ( $info->{'drivetemps'} ) {
            foreach my $t ( @{ $info->{'drivetemps'} } ) {
                my $short = $t->{'device'};
                $short =~ s/^\/dev\///;
                my $emsg;
                if ( $t->{'errors'} ) {
                    $emsg
                        .= '&nbsp;&nbsp;<span class="label label-warning" style="vertical-align: middle; max-height: 11px; display: inline-block; line-height: 9px;">'
                        . &Atext( 'body_driveerr', $t->{'errors'} )
                        . "</span>";
                }
                elsif ( $t->{'failed'} ) {
                    $emsg
                        .= '&nbsp;&nbsp;<span class="label label-danger" style="vertical-align: middle; max-height: 11px; display: inline-block; line-height: 9px;">'
                        . &Atext('body_drivefailed')
                        . '</span>';
                }
                $hdd_temperature
                    .= '<span class="badge-custom badge-drivestatus" style="margin-right:3px; margin-bottom: 3px">'
                    . $short . ': '
                    . int( $t->{'temp'} )
                    . '&#176;C '
                    . $emsg
                    . '</span>'
                    . ( $__settings{'settings_sysinfo_drive_status_on_new_line'} eq 'true' ? '<br>' : '&nbsp;' );
            }
        }

        # System uptime
        &foreign_require("proc");
        my ( $day, $hour, $minute ) = &proc::get_system_uptime();
        if ($day) {
            $uptime_text = &Atext( 'body_updays', $day, $hour, $minute );
        }
        elsif ( $minute && $hour ) {
            $uptime_text = &Atext( 'body_uphours', $hour, $minute );
        }
        elsif ($minute) {
            $uptime_text = &Atext( 'body_upmins', $minute );
        }

        $uptime = '<a href=' . $gconfig{'webprefix'} . '/init/>' . $uptime_text . '</a>';

        # Running processes
        if ( &foreign_check("proc") ) {
            @procs        = &proc::list_processes();
            $running_proc = scalar(@procs);
            if ( &foreign_available("proc") ) {
                $running_proc = '<a href=' . $gconfig{'webprefix'} . '/proc/>' . $running_proc . '</a>';
            }
        }

        # Load averages
        if ( $info->{'load'} ) {
            my @c = @{ $info->{'load'} };
            if (@c) {
                $load = &Atext( 'body_load', @c );
            }
        }

        # Memory
        if ( $info->{'mem'} ) {

            # Real memory details
            $real_memory = &Atext( 'body_used', nice_size( ( $m[0] ) * 1000 ), nice_size( ( $m[0] - $m[1] ) * 1000 ) );

            # Virtual memory details
            $virtual_memory
                = &Atext( 'body_used', nice_size( ( $m[2] ) * 1000 ), nice_size( ( $m[2] - $m[3] ) * 1000 ) );
        }

        # Local disk space
        if ( $info->{'disk_total'} && $info->{'disk_total'} ) {
            $disk_space = &Atext(
                'body_used_and_free',
                nice_size( $info->{'disk_total'} ),
                nice_size( $info->{'disk_free'} ),
                nice_size( $info->{'disk_total'} - $info->{'disk_free'} )
            );
        }

        #ConfigServer Security & Firewall
        if ( &foreign_check("csf") && &foreign_available("csf") ) {

            # Define CSF installed version
            my $csf_installed_version = read_file_lines( '/etc/csf/version.txt', 1 );
            our $csf_installed_version = $csf_installed_version->[0];

            # Define CSF actual version if allowed
            if ( $__settings{'settings_sysinfo_csf_updates'} eq 'true' ) {
                http_download( 'download.configserver.com', '80',
                    '/csf/version.txt', \$csf_remote_version, \$error, undef, undef, undef, undef, 5 );

                # Trim versions' number
                $csf_installed_version =~ s/^\s+|\s+$//g;
                $csf_remote_version =~ s/^\s+|\s+$//g;
            }
            else {
                $csf_remote_version = '0';
            }

            if ( $csf_remote_version <= $csf_installed_version ) {
                $csf_update_required = '0';
            }
            else {
                $csf_update_required = '1';
            }

            $csf_title
                = $Atext{'body_firewall'} . ' '
                . (
                  `pgrep lfd`
                ? ''
                : ' &nbsp;&nbsp;&nbsp;&nbsp;<a class="label label-danger csf-submit" href="#" data-id="csf_lfdstatus" class="label label-danger">Stopped</a> '
                );
            $csf_data = (
                      '<a href="/csf">ConfigServer Security & Firewall</a> '
                    . $csf_installed_version . ''
                    . (
                    $csf_update_required eq '1'
                    ? '. ' . $Atext{'theme_update_available'} . ' ' . $csf_remote_version . '&nbsp;&nbsp;&nbsp;'
                    : '&nbsp;&nbsp;&nbsp;'
                    )
                    . '
                <form action="/csf/index.cgi" method="post" class="hidden" id="csf_lfdstatus">
                    <input type="hidden" name="action" value="lfdstatus">
                </form>
                <form action="/csf/index.cgi" method="post" class="hidden" id="csf_upgrade">
                    <input type="hidden" name="action" value="upgrade">
                </form>
                <form action="/csf/index.cgi" method="post" class="hidden" id="csf_temporary_ip_entries">
                    <input type="hidden" name="action" value="temp">
                </form>
                <form action="/csf/index.cgi" method="post" class="hidden" id="csf_search_system_log">
                    <input type="hidden" name="action" value="loggrep">
                </form>
                <form action="/csf/index.cgi" method="post" class="hidden" id="csf_denyf">
                    <input type="hidden" name="action" value="denyf">
                </form>
            '
                    . (
                    $csf_update_required eq '1'
                    ? '<div class="btn-group">
                <a class="btn btn-xxs btn-success csf csf-submit" href="#" data-id="csf_upgrade"><i class="fa fa-fw fa-refresh">&nbsp;</i>'
                        . $Atext{'theme_update'} . '</a>
                <a class="btn btn-xxs btn-info csf" target="_blank" href="https://download.configserver.com/csf/changelog.txt"><i class="fa fa-fw fa-pencil-square-o">&nbsp;</i>'
                        . $Atext{'theme_changelog'} . '</a>
                <a class="btn btn-xxs btn-warning csf" target="_blank" href="https://download.configserver.com/csf.tgz"><i class="fa fa-fw fa-download">&nbsp;</i>'
                        . $Atext{'theme_download'} . '</a>
            </div>'
                    : '<div class="btn-group">
               <a class="btn btn-default btn-xxs btn-hidden hidden csf csf-submit" data-toggle="tooltip" data-placement="top" data-container="body" data-title="Search system logs" href="#" data-id="csf_search_system_log"><i class="fa fa-fw fa-filter"></i></a>
               <a class="btn btn-default btn-xxs btn-hidden hidden csf csf-submit" data-toggle="tooltip" data-placement="top" data-container="body" data-title="Temporary IP entries" href="#" data-id="csf_temporary_ip_entries"><i class="fa fa-fw fa-ban"></i></a>
               <a class="btn btn-default btn-xxs btn-hidden hidden csf csf-submit" href="#" data-id="csf_denyf"><i class="fa fa-fw fa-trash-o"></i> Flush all blocks</a>
              </div>'
                    )
                    . ''
            );
        }

        # Package updates
        if ( &foreign_available("package-updates") && $info->{'poss'} ) {
            @poss = @{ $info->{'poss'} };
            @secs = grep { $_->{'security'} } @poss;

            my $poss = scalar(@poss);
            my $secs = scalar(@secs);

            if ( $poss && $secs ) {
                $msg = &Atext(
                    (          $poss gt 1
                            && $secs gt 1 ? 'body_upsec'  : $poss gt 1
                            && $secs eq 1 ? 'body_upsec1' : $poss eq 1
                            && $secs gt 1 ? 'body_upsec2' : 'body_upsec3'
                    ),
                    $poss, $secs
                );
            }
            elsif ($poss) {
                $msg = &Atext( ( $poss gt 1 ? 'body_upneed' : 'body_upneed1' ), $poss );
            }
            else {
                $msg = $Atext{'body_upok'};
            }
            if ( &foreign_available("package-updates") ) {
                $msg =~ s/([0-9]+)/"<i class=\'badge badge-danger\'> $1 <\/i>"/eg;
                $package_message
                    = '<a href="'
                    . $gconfig{'webprefix'}
                    . '/package-updates/index.cgi?mode=updates">'
                    . $msg
                    . '</a> <a href="/?updated" target="_top" data-href="'
                    . $gconfig{'webprefix'}
                    . '/package-updates/index.cgi" data-refresh="system-status package-updates" class="btn btn-primary btn-xxs btn-hidden hidden"><i class="fa fa-refresh"></i></a>';
            }
        }

        return (
            $cpu_percent,        $mem_percent,             $virt_percent,    $disk_percent,
            $host,               $os,                      $webmin_version,  $virtualmin_version,
            $cloudmin_version,   $authentic_theme_version, $local_time,      $kernel_arch,
            $cpu_type,           $cpu_temperature,         $hdd_temperature, $uptime,
            $running_proc,       $load,                    $real_memory,     $virtual_memory,
            $disk_space,         $package_message,         $csf_title,       $csf_data,
            $csf_remote_version, $authentic_remote_version
        );

    }
    else {
        return;
    }
}

sub csf_temporary_list {
    if ( &foreign_check("csf") && &foreign_available("csf") ) {
        my @t;
        my @l;

        if ( -e "/var/lib/csf/csf.tempban" && !-z "/var/lib/csf/csf.tempban" ) {
            open( $IN, "<", "/var/lib/csf/csf.tempban" ) or die $!;
            @t = <$IN>;
            chomp @t;
            close($IN);
        }

        if ( @t && -e "/var/lib/csf/stats/iptables_log" ) {
            open( $IN, "<", "/var/lib/csf/stats/iptables_log" ) or die $!;
            flock( $IN, LOCK_SH );
            my @i = <$IN>;
            close($IN);
            chomp @i;
            @i = reverse @i;
            my $c = 0;

            my $s = scalar @i;
            for ( my $x = 0; $x < $s; $x++ ) {
                $c++;
                my $u = $i[$x];
                my ( $o, $l ) = split( /\|/, $u );
                my ( $r, $w, $k );
                if ( $l =~ /SRC=(\S+)/ ) { $r = $1 }
                if ( $l =~ /DST=(\S+)/ ) { $w = $1 }
                if ( $l =~ /DPT=(\d+)/ ) { $k = $1 }

                foreach my $h ( reverse @t ) {
                    if ( !length $h ) {next}
                    my ( $a, $b, $d, $e, $f, $g ) = split( /\|/, $h );
                    if ( $r eq $b ) {
                        push @l, $a . '|' . $b . '|' . $w . '|' . $k . '|' . $d . '|' . $e . '|' . $f . '|' . $g;
                    }
                }

            }
        }

        if (@l) {
            return JSON->new->latin1->encode( \@l );
        }
        else {
            return JSON->new->latin1->encode( {} );
        }
    }
    else {
        return JSON->new->latin1->encode( {} );
    }
}

sub get_current_user_config {
    our ($___user)
        = grep { $_->{'name'} eq $base_remote_user } &acl::list_users();
    return $___user;
}

sub get_col_num {
    my ( $info, $max_col ) = @_;
    my $num_col = 0;
    if ( $info->{'cpu'} ) { $num_col++; }
    if ( $info->{'mem'} ) {
        @m = @{ $info->{'mem'} };
        if ( @m && $m[0] ) { $num_col++; }
        if ( @m && $m[2] ) { $num_col++; }
    }
    if ( $info->{'disk_total'} ) { $num_col++; }
    my $col = $max_col / $num_col;
    return $col;
}

sub print_table_row {
    my ( $title, $content, $id ) = @_;
    print '<tr>' . "\n";
    print '<td style="width:30%;vertical-align:middle; padding:8px;"><strong>' . $title . '</strong></td>' . "\n";
    print '<td  style="width:70%; vertical-align:middle; padding:8px;"><span data-id="'
        . $id . '">'
        . $content
        . '</span></td>' . "\n";
    print '</tr>' . "\n";
}

sub print_favorites {

    my $f = &read_file_contents( $config_directory . "/authentic-theme/favorites.json" );

    print '
    <div id="favorites-menu">
        <div class="favorites-menu-outer">
            <nav class="favorites-menu">
                <ul class="favorites-menu-content ui-sortable">
                    <li class="menu-exclude exclude favorites-title">
                        <h1><i class="fa fa-star-o"></i>&nbsp;&nbsp;'
        . $Atext{'left_favorites'}
        . '<sup style="position: absolute; margin: 25px 0 0 -10px;" class="hidden">&nbsp;&nbsp;<small class="text-white"> <a href="'
        . $gconfig{'webprefix'}
        . '/settings-editor_read.cgi?file='
        . $config_directory
        . '/authentic-theme/favorites.json" target="page" class="fa fa-pencil-square-o'
        . ( $f =~ m/"favorites":/ ? '' : ' hidden' )
        . '" style="display: inline; font-size: 1em;"></a></small></sup></h1>
                    </li>
    ';

    if ( $f && $f =~ m/"favorites":/ ) {
        my ($f) = $f =~ /\{(?:\{.*\}|[^{])*\}/sg;
        my $fc = decode_json($f);
        foreach my $favorite ( @{ $fc->{'favorites'} } ) {
            if ( length( $favorite->{"link"} ) ) {
                print '
                    <li class="menu-exclude ui-sortable-handle">
                        <a class="menu-exclude-link" target="page" href="'
                    . $favorite->{"link"}
                    . '"><i data-product="'
                    . $favorite->{"icon"}
                    . '" class="wbm-'
                    . $favorite->{"icon"}
                    . ' wbm-sm">&nbsp;</i><span class="f__c">
                            ' . $favorite->{"title"} . '
                        &nbsp;<small class="hidden" style="font-size: 0.6em; position: absolute; margin-top: -1px"><i class="fa fa-times"></i></small></span></a>
                    </li>
              ';
            }
        }
    }
    print '
                <li class="menu-exclude exclude favorites-no-message'
        . ( $f !~ m/"favorites":/ ? '' : ' hidden' ) . '">
                    <span>' . $Atext{'left_favorites_no'} . '</span>
                </li>
        ';

    print '
                </ul>
            </nav>
        </div>
        <a class="favorites-menu-close">
            <div class="favorites-menu-icon">
                <div class="favorites-menu-bar"></div>
                <div class="favorites-menu-bar"></div>
            </div>
        </a>
    </div>
    ';
}

sub parse_license_date {
    if ( $_[0] =~ /^(\d{4})-(\d+)-(\d+)$/ ) {
        return eval { timelocal( 0, 0, 0, $3, $2 - 1, $1 - 1900 ) };
    }
    return undef;
}

sub _post_install {

    #Clear update notice
    unlink $root_directory . '/authentic-theme/update';

    return '1';
}

sub embed_logo {

    my $logo;
    my $usermin_config_directory;
    my $usermin_root_directory;

    get_env('script_name') eq '/session_login.cgi'
        ? ( $logo = 'logo_welcome' )
        : ( $logo = 'logo' );

    if ( usermin_available() ) {
        ( $usermin_config_directory = $config_directory ) =~ s/webmin/usermin/;
        ( $usermin_root_directory   = $root_directory ) =~ s/webmin/usermin/;

    }

    if ( -r $config_directory . "/authentic-theme/" . $logo . ".png" ) {
        if ($get_user_level eq '0'
            && (  -s $config_directory
                . "/authentic-theme/"
                . $logo
                . ".png" ne -s $root_directory
                . "/authentic-theme/images/"
                . $logo . ".png"
                || -s $usermin_config_directory
                . "/authentic-theme/"
                . $logo
                . ".png" ne -s $usermin_root_directory
                . "/authentic-theme/images/"
                . $logo
                . ".png" )
            )
        {
            # Update logo in case it changed
            copy_source_dest( $config_directory . "/authentic-theme/" . $logo . ".png",
                $root_directory . "/authentic-theme/images" );

            # Push logo update in case Usermin is installed
            if ( usermin_available() ) {
                copy_source_dest(
                    $usermin_config_directory . "/authentic-theme/" . $logo . ".png",
                    $usermin_root_directory . "/authentic-theme/images"
                );
                if ( -r $usermin_config_directory . "/authentic-theme/logo_welcome.png" ) {
                    copy_source_dest(
                        $usermin_config_directory . "/authentic-theme/logo_welcome.png",
                        $usermin_root_directory . "/authentic-theme/images"
                    );
                }
            }
        }
        if ( -r $root_directory . "/authentic-theme/images/" . $logo . ".png" ) {
            print '<div class="__' . $logo . ' _' . $logo . '">';
            print '<img src="' . $gconfig{'webprefix'} . '/images/' . $logo . '.png">';
            print '</div>' . "\n";
        }
    }
}

sub head {
    print "Content-type: text/html\n\n";
}

sub embed_login_head {
    print '<head>',                 "\n";
    print '<title>',                $title, '</title>', "\n";
    print '<meta charset="utf-8">', "\n";
    print '<link rel="shortcut icon" href="'
        . $gconfig{'webprefix'}
        . '/images/favicon'
        . (
        ( &get_product_name() eq 'usermin' )
        ? '-usermin'
        : '-webmin'
        ) . '.ico">' . "\n";
    print '<meta name="viewport" content="width=device-width, initial-scale=1.0">' . "\n";

    print '<link href="'
        . $gconfig{'webprefix'}
        . '/unauthenticated/css/bootstrap.min.css?1801" rel="stylesheet" type="text/css">' . "\n";

    print '<link href="'
        . $gconfig{'webprefix'}
        . '/unauthenticated/css/authentic.min.css?1801" rel="stylesheet" type="text/css">' . "\n";

    embed_styles();

    print '<script src="'
        . $gconfig{'webprefix'}
        . '/unauthenticated/js/jquery.min.js?1801" type="text/javascript"></script>' . "\n";
    print '</head>', "\n";
}

sub get_authentic_version {

    # Get local version
    my $installed_version = read_file_lines( $root_directory . "/authentic-theme/VERSION.txt", 1 );
    our $installed_version = $installed_version->[0];

    $installed_version =~ s/^\s+|\s+$//g;
    $installed_version = sprintf '%.2f', $installed_version;

    if ( $__settings{'settings_sysinfo_theme_updates'} eq 'true' ) {

        # Get remote version if allowed
        http_download( 'raw.githubusercontent.com', '443', '/qooob/authentic-theme/master/VERSION.txt',
            \$remote_version, \$error, undef, 1, undef, undef, 5 );

        # Trim versions' number
        $remote_version =~ s/^\s+|\s+$//g;
        $remote_version = sprintf '%.2f', $remote_version;
    }
    else {
        $remote_version = '0';
    }

    return ( $installed_version, $remote_version );
}

sub __config_dir_available {
    if ( !-d $config_directory . '/authentic-theme' ) {
        mkdir( $config_directory . '/authentic-theme', 0755 );
    }
}

sub domain_available {
    my ( $id, $type ) = @_;
    if ( &foreign_available('virtual-server') ) {
        &foreign_require( "virtual-server", "virtual-server-lib.pl" );
        foreach my $dom ( &virtual_server::list_visible_domains() ) {
            if ( $id eq $dom->{$type} ) {
                return $dom;
            }
        }
    }
    else {
        return undef;
    }

}

sub server_available {
    my ( $id, $type ) = @_;
    if ( &foreign_available('server-manager') ) {
        &foreign_require( "server-manager", "server-manager-lib.pl" );
        foreach my $host ( &server_manager::list_managed_servers() ) {
            if ( $id eq $host->{$type} ) {
                return $host;
            }
        }
    }
    else {
        return undef;
    }

}

sub get_default_target {
    my $default;
    my $taget_data;
    my $in;
    my $module = (
        $t_uri_cloudmin == -1
        ? 'virtualmin'
        : 'cloudmin'
    );

    if ($t_uri___i_virtualmin) {
        $in = $t_uri___i_virtualmin;
    }
    elsif ($t_uri___i_cloudmin) {
        $in = $t_uri___i_cloudmin;
    }
    else {
        $in = $in{$t_uri____i};
    }

    $taget_data = (
        $module eq 'virtualmin'
        ? domain_available( $in, 'dom' )
        : server_available( $in, 'host' )
    );
    if ($taget_data) {
        $default = $taget_data->{'id'};
    }
    else {
        $default = $__settings{ 'settings_right_' . $module . '_default' };
        $default = (
              $default ne 'index.cgi'
            ? $default
            : undef
        );
    }

    return $default;
}

sub _settings {
    my ( $t, $k, $v ) = @_;

    if ( $t eq 'get' ) {
        my @settings = (
            '__',
            _settings(
                'fa',
                'file-o',
                &Atext('settings_right_page_defaults_title') . "~" . &Atext('settings_right_page_default_description')
            ),
            'settings_right_default_tab_webmin',
            ( foreign_available("virtual-server") ? '/?virtualmin' : '/' ),
            'settings_force_default_tab',
            'false',
            'settings_right_virtualmin_default',
            'sysinfo.cgi',
            'settings_right_cloudmin_default',
            'sysinfo.cgi',
            'settings_right_default_tab_usermin',
            '/',

            '__',
            _settings( 'fa', 'desktop', &Atext('settings_global_options_title') ),
            'settings_navigation_color',
            'blue',
            'settings_grayscale_level_navigation',
            '0',
            'settings_sepia_level_navigation',
            '0',
            'settings_saturate_level_navigation',
            '1',
            'settings_hue_level_navigation',
            '0',
            'settings_invert_level_navigation',
            '0',
            'settings_brightness_level_navigation',
            '1',
            'settings_contrast_level_navigation',
            '1',
            'settings_background_color',
            'gainsboro',
            'settings_grayscale_level_content',
            '0',
            'settings_saturate_level_content',
            '1',
            'settings_hue_level_content',
            '0',
            'settings_cm_view_palette',
            'elegant',
            'settings_cm_editor_palette',
            'monokai',
            'settings_animation_left',
            'true',
            'settings_animation_tabs',
            'true',
            'settings_right_reload',
            'true',
            'settings_window_autoscroll',
            'true',
            'settings_global_passgen_format',
            '12|a-z,A-Z,0-9,#',
            '__',
            _settings(
                'fa', 'sub-title', '' . "~" . &Atext('settings_window_replaced_timestamps_options_description')
            ),
            'settings_window_replace_timestamps',
            'true',
            'settings_window_replaced_timestamp_format_full',
            'LLLL',
            'settings_window_replaced_timestamp_format_short',
            'L, LTS', '__',
            _settings( 'fa', 'sub-title', '' . "~" . &Atext('settings_window_exclusion_description') ),
            'settings_window_exclusion_list',
            'sysstats,drweb-maild,cwaf',

            '__',
            _settings( 'fa', 'bell', &Atext('settings_right_notification_slider_options_title') ),
            'settings_notification_slider_enabled',
            'true',
            'settings_notification_color',
            'grey',
            'settings_notification_slider_fixed',
            'false',
            'settings_sysinfo_background_call_timeout',
            '10',

            '__',
            _settings( 'fa', 'bars', &Atext('settings_right_navigation_menu_title') ),
            'settings_leftmenu_width',
            '260',
            'settings_switch_rdisplay',
            'false',
            'settings_leftmenu_section_hide_refresh_modules',
            'false',
            'settings_leftmenu_section_hide_unused_modules',
            'false',
            'settings_sysinfo_link_mini',
            'true',
            'settings_favorites',
            'true',
            'settings_theme_options_button',
            'true',
            'settings_leftmenu_button_language',
            'false',
            'settings_leftmenu_button_refresh',
            'true',
            'settings_leftmenu_singlelink_icons',
            'true',
            'settings_leftmenu_section_hide_vm_and_cm_links',
            'true',
            'settings_leftmenu_vm_installscripts',
            'true',
            'settings_leftmenu_vm_webpages',
            'true',
            'settings_leftmenu_vm_backup_amazon',
            'true',
            'settings_leftmenu_user_html',
            '',
            'settings_leftmenu_user_html_only_for_administrator',
            'false',

            '__',
            _settings( 'fa', 'table', &Atext('settings_right_table_options_title') ),
            'settings_right_iconize_header_links',
            'true',
            'settings_right_hide_table_icons',
            'false',
            'settings_right_small_table_icons',
            'false',
            'settings_right_xsmall_table_icons',
            'false',
            'settings_right_animate_table_icons',
            'true',
            'settings_right_grayscaled_table_icons',
            'true',

            '__',
            _settings( 'fa', 'keyboard-o', &Atext('settings_right_hotkey_options_title') ),
            'settings_hotkeys_active',
            'true',
            'settings_hotkey_toggle_modifier',
            'altKey',
            'settings_hotkey_toggle_key_webmin',
            'w',
            'settings_hotkey_toggle_key_virtualmin',
            'v',
            'settings_hotkey_toggle_key_cloudmin',
            'c',
            'settings_hotkey_toggle_key_usermin',
            'u',
            'settings_hotkey_toggle_key_webmail',
            'm',
            'settings_hotkey_sysinfo',
            'i',
            'settings_hotkey_toggle_slider',
            'n',
            'settings_hotkey_favorites',
            'f',
            'settings_hotkey_focus_search',
            's',
            'settings_hotkey_reload',
            'r', '__',
            _settings( 'fa', 'sub-title', '' . "~" . &Atext('settings_right_hotkey_custom_options_description') ),
            'settings_hotkey_custom_1',
            '',
            'settings_hotkey_custom_2',
            '',
            'settings_hotkey_custom_3',
            '',
            'settings_hotkey_custom_4',
            '',
            'settings_hotkey_custom_5',
            '',
            'settings_hotkey_custom_6',
            '',
            'settings_hotkey_custom_7',
            '',
            'settings_hotkey_custom_8',
            '',
            'settings_hotkey_custom_9',
            '',

            '__',
            _settings( 'fa', 'info-circle', &Atext('settings_right_sysinfo_page_options_title') ),
            'settings_sysinfo_easypie_charts',
            'true',
            'settings_sysinfo_easypie_charts_width',
            '4',
            'settings_sysinfo_easypie_charts_scale',
            '8',
            'settings_sysinfo_theme_updates',
            'false',
            'settings_sysinfo_csf_updates',
            'false',
            'settings_sysinfo_drive_status_on_new_line',
            'true',
            'settings_sysinfo_expand_all_accordions',
            'false'
        );

        return (@settings);
    }

    if ( $t eq 'exclusions' ) {
        my @_s_e = ();

        ##
        # List of combined settings for Virtualmin/Cloudmin/Usermin
        my @s_vc_e = (
            'settings_leftmenu_section_hide_vm_and_cm_links', 'settings_leftmenu_singlelink_icons',
            'settings_right_default_tab_webmin',              'settings_force_default_tab',
            'settings_right_reload'
        );

        if (   !&foreign_available("server-manager")
            && !foreign_available("virtual-server") )
        {
            foreach my $e (@s_vc_e) {
                push( @_s_e, $e );
            }
        }

        if (   !&foreign_available("server-manager")
            && !foreign_available("virtual-server")
            && !usermin_available('mailbox') )
        {
            push( @_s_e, 'settings_right_page_defaults_title' );
        }

        #
        ##

        ##
        # List of settings for Virtualmin
        my @s_vm_e = (
            'settings_leftmenu_vm_installscripts', 'settings_leftmenu_vm_webpages',
            'settings_leftmenu_vm_backup_amazon',  'settings_right_virtualmin_default',
            'settings_hotkey_toggle_key_virtualmin'
        );

        if ( !foreign_available("virtual-server") ) {
            foreach my $e (@s_vm_e) {
                push( @_s_e, $e );
            }
        }
        #
        ##

        ##
        # List of settings for Cloudmin
        my @s_cm_e = ( 'settings_right_cloudmin_default', 'settings_hotkey_toggle_key_cloudmin' );
        if ( !&foreign_available("server-manager") ) {
            foreach my $e (@s_cm_e) {
                push( @_s_e, $e );
            }
        }
        #
        ##

        ##
        # List of settings for Usermin
        my @s_um_e = ('settings_hotkey_toggle_key_usermin');
        if ( !usermin_available() ) {
            foreach my $e (@s_um_e) {
                push( @_s_e, $e );
            }
        }
        #
        ##

        ##
        # List of settings for Webmail
        my @s_wm_e = ( 'settings_hotkey_toggle_key_webmail', 'settings_right_default_tab_usermin' );
        if ( !usermin_available("mailbox") ) {
            foreach my $e (@s_wm_e) {
                push( @_s_e, $e );
            }
        }
        #
        ##

        ##
        # List of settings for ConfigServer Security & Firewall
        my @s_cf_e = ('settings_sysinfo_csf_updates');
        if ( !&foreign_available("csf") ) {
            foreach my $e (@s_cf_e) {
                push( @_s_e, $e );
            }
        }
        #
        ##

        return @_s_e;
    }

    if ( $t eq 'fa' ) {
        return $v;

        #   '<i class="fa fa-'
        # . $k
        # . '" style="vertical-align: text-bottom !important;">&nbsp;&nbsp;</i>'
        # . $v;
    }

    if ( $t eq 'header' ) {
        return '
            ' . $Atext{'settings_right_title'} . '
            <p></p>
            <form class="ui_form" role="form" action="/settings.cgi" method="post"
                data-text-current_theme="'
            . $Atext{'settings_right_current_theme'}

            . '" data-text-settings_right_saved="' . $Atext{'settings_right_saved'}

            . '" data-text-save="' . $text{'save'}

            . '" data-text-settings_right_saving="' . $Atext{'settings_right_saving'}

            . '" data-text-settings_right_restore_defaults="' . $Atext{'settings_right_restore_defaults'}

            . '" data-text-settings_right_clear_local_cache="' . $Atext{'settings_right_clear_local_cache'}

            . '" data-text-settings_right_restored="' . $Atext{'settings_right_restored'}

            . '" data-text-settings_right_restoring="' . $Atext{'settings_right_restoring'}

            . '" data-text-error="' . $Atext{'error'}

            . '">
                <div class="table-responsive">
                    <table class="table table-striped table-condensed table-subtable">
                        <thead><tr><th class="table-title" style="width: auto"><i class="fa fa-cogs vertical-align-text-bottom"></i>&nbsp;<b>'
            . $Atext{'settings_right_theme_configurable_options_title'} . '</b></th></tr></thead>
                        <tbody>
                            <tr>
                                <td>
                                    <table class="sub_table_container table-hardcoded" width="100%">
                                        <tbody>
                                        ';
    }

    if ( $t eq 'section' ) {
        foreach my $e (@_s_e) {
            if ( index( $k, $Atext{$e} ) != -1 ) {
                return;
            }
        }
        return '
            <tr>
                <td colspan="2" class="col_value'
            . ( $k ? ' col_header ' : '' )
            . ' atssection"><b>'
            . $k . '</b>'
            . ( $v && '<br><div class="smaller text-normal no-padding">' . $v . '</div>' ) . '</td>
            </tr>
        ';
    }

    if ( $t eq 'content' ) {
        foreach my $o (@_s_e) {
            if ( $k eq $o ) {
                return;
            }
        }

        my $v = ( length $__settings{$k} ? $__settings{$k} : $v );

        if ( $v eq 'true' || $v eq 'false' ) {
            $v = '<span class="awradio awobject">
                    <input class="iawobject" type="radio" name="'
                . $k . '" id="' . $k . '_1" value="true"' . ( $v eq 'true' && ' checked' ) . '>
                    <label class="lawobject" for="'
                . $k . '_1">' . $text{'yes'} . '</label>
                    <input class="iawobject" type="radio" name="'
                . $k . '" id="' . $k . '_0" value="false"' . ( $v eq 'false' && ' checked' ) . '>
                    <label class="lawobject" for="'
                . $k . '_0">' . $text{'no'} . '</label>
                </span>
            ';

        }
        elsif (index( $k, 'settings_security_notify_on_' ) != -1
            || index( $k, 'settings_hotkey_toggle_key_' ) != -1
            || $k eq 'settings_hotkey_focus_search'
            || $k eq 'settings_hotkey_toggle_slider'
            || $k eq 'settings_hotkey_reload'
            || $k eq 'settings_hotkey_sysinfo'
            || $k eq 'settings_hotkey_favorites'
            || $k eq 'settings_sysinfo_background_call_timeout'
            || $k eq 'settings_sysinfo_easypie_charts_width'
            || $k eq 'settings_sysinfo_easypie_charts_scale' )
        {

            my $width
                = (    index( $k, 'settings_hotkey_toggle_key_' ) != -1
                    || $k eq 'settings_hotkey_focus_search'
                    || $k eq 'settings_hotkey_toggle_slider'
                    || $k eq 'settings_hotkey_reload'
                    || $k eq 'settings_hotkey_sysinfo'
                    || $k eq 'settings_hotkey_favorites'
                    || $k eq 'settings_sysinfo_background_call_timeout'
                    || $k eq 'settings_sysinfo_easypie_charts_width'
                    || $k eq 'settings_sysinfo_easypie_charts_scale' )
                ? ' width: 31px; '
                : ' width: 95%; ';
            my $max_length
                = (    index( $k, 'settings_hotkey_toggle_key_' ) != -1
                    || $k eq 'settings_hotkey_focus_search'
                    || $k eq 'settings_hotkey_toggle_slider'
                    || $k eq 'settings_hotkey_reload'
                    || $k eq 'settings_hotkey_sysinfo'
                    || $k eq 'settings_hotkey_favorites' )
                ? ' maxlength="1"'
                : ' ';

            $v = '
                <input style="display: inline;'
                . $width
                . 'height: 28px; vertical-align: middle;" class="form-control ui_textbox" type="text" name="'
                . $k
                . '" value="'
                . $v . '"'
                . $max_length . '>
            ';

        }
        elsif ($k eq 'settings_grayscale_level_navigation'
            || $k eq 'settings_sepia_level_navigation'
            || $k eq 'settings_saturate_level_navigation'
            || $k eq 'settings_hue_level_navigation'
            || $k eq 'settings_invert_level_navigation'
            || $k eq 'settings_brightness_level_navigation'
            || $k eq 'settings_contrast_level_navigation'
            || $k eq 'settings_grayscale_level_content'
            || $k eq 'settings_saturate_level_content'
            || $k eq 'settings_leftmenu_width'
            || $k eq 'settings_hue_level_content' )
        {

            my $range_max = '1';
            my $range_min = '0';
            my $range_step;

            if (   $k eq 'settings_grayscale_level_navigation'
                || $k eq 'settings_sepia_level_navigation'
                || $k eq 'settings_saturate_level_navigation'
                || $k eq 'settings_invert_level_navigation'
                || $k eq 'settings_grayscale_level_content'
                || $k eq 'settings_saturate_level_content' )
            {

                if (   $k eq 'settings_saturate_level_navigation'
                    || $k eq 'settings_saturate_level_content' )
                {
                    $range_max = '3';
                }
                $range_step = '0.1';
            }
            elsif ($k eq 'settings_brightness_level_navigation'
                || $k eq 'settings_contrast_level_navigation' )
            {
                $range_min  = '0.1';
                $range_max  = '3';
                $range_step = '0.01';
            }
            elsif ($k eq 'settings_hue_level_navigation'
                || $k eq 'settings_hue_level_content' )
            {
                $range_min  = '-360';
                $range_max  = '360';
                $range_step = '1';
            }
            elsif ( $k eq 'settings_leftmenu_width' ) {
                $range_min  = '260';
                $range_max  = '520';
                $range_step = '1';
            }
            $v = '
                <input style="display: inline; width: 80%; height: 28px; vertical-align: middle;" class="form-control ui_textbox" type="range" min="'
                . $range_min
                . '" max="'
                . $range_max
                . '" step="'
                . $range_step
                . '" name="'
                . $k
                . '" value="'
                . $v . '">
            ';

        }
        elsif ($k eq 'settings_hotkey_custom_1'
            || $k eq 'settings_hotkey_custom_2'
            || $k eq 'settings_hotkey_custom_3'
            || $k eq 'settings_hotkey_custom_4'
            || $k eq 'settings_hotkey_custom_5'
            || $k eq 'settings_hotkey_custom_6'
            || $k eq 'settings_hotkey_custom_7'
            || $k eq 'settings_hotkey_custom_8'
            || $k eq 'settings_hotkey_custom_9'
            || $k eq 'settings_leftmenu_user_html'
            || $k eq 'settings_global_passgen_format'
            || $k eq 'settings_window_replaced_timestamp_format_full'
            || $k eq 'settings_window_replaced_timestamp_format_short' )
        {
            my $width = ' width: 40%; ';

            if ( $k eq 'settings_global_passgen_format' ) {
                $width = ' width: 30%; ';
            }
            if (   $k eq 'settings_window_replaced_timestamp_format_full'
                || $k eq 'settings_window_replaced_timestamp_format_short' )
            {
                $width = ' width: 50%; ';
            }
            elsif ( $k eq 'settings_leftmenu_user_html' ) {
                $width = ' width: 95%; ';
            }

            $v = '
                <input style="display: inline;'
                . $width
                . 'height: 28px; vertical-align: middle;" class="form-control ui_textbox" type="text" name="'
                . $k
                . '" value="'
                . $v . '">
            ';
        }
        elsif ( $k eq 'settings_right_default_tab_webmin' ) {
            $v = '<select class="ui_select" name="' . $k . '">
                <option value="/"'
                . ( $v eq '/' && ' selected' ) . '>Webmin</option>

                '
                . ( &foreign_available("virtual-server")
                    && ' <option value="/?virtualmin"'
                    . ( $v eq '/?virtualmin' && ' selected' )
                    . '>Virtualmin</option> ' )
                . '

               '
                . ( &foreign_available("server-manager")
                    && ' <option value="/?cloudmin"' . ( $v eq '/?cloudmin' && ' selected' ) . '>Cloudmin</option>' )
                . '
                </select>';
        }
        elsif ( $k eq 'settings_right_default_tab_usermin' ) {
            $v = '<select class="ui_select" name="' . $k . '">
                <option value="/"'
                . ( $v eq '/' && ' selected' ) . '>Usermin</option>

                '
                . ( usermin_available('mailbox')
                    && ' <option value="/?mail"' . ( $v eq '/?mail' && ' selected' ) . '>Mail</option> ' )
                . '

                </select>';
        }

        elsif ( $k eq 'settings_hotkey_toggle_modifier' ) {
            $v = '<select class="ui_select" name="' . $k . '">
                    <option value="altKey"'
                . ( $v eq 'altKey' && ' selected' ) . '>Alt</option>
                    <option value="ctrlKey"'
                . ( $v eq 'ctrlKey' && ' selected' ) . '>Ctrl</option>
                    <option value="metaKey"'
                . ( $v eq 'metaKey' && ' selected' ) . '>Meta</option>
                </select>';
        }
        elsif ( $k eq 'settings_right_virtualmin_default' ) {
            get_user_level();
            $v = &ui_select(
                $k, $v,
                [   [ undef,       undef ],
                    [ 'index.cgi', $Atext{'theme_settings_virtualmin'} ],
                    map { [ $_->{'id'}, &virtual_server::show_domain_name($_) ] }
                        grep { &virtual_server::can_edit_domain($_) }
                        sort { $a->{'dom'} cmp $b->{'dom'} } &virtual_server::list_domains()
                ]
            );
        }
        elsif ( $k eq 'settings_right_cloudmin_default' ) {
            get_user_level();
            @servers = &server_manager::list_available_managed_servers_sorted();
            $v       = &ui_select(
                $k, $v,
                [   [ undef,       undef ],
                    [ 'index.cgi', $Atext{'theme_settings_cloudmin'} ],
                    map { [ $_->{'id'}, $_->{'host'} ] } @servers,
                ]
            );

        }
        elsif ( $k eq 'settings_navigation_color' ) {
            $v = '<select class="ui_select" name="' . $k . '">

                    <option value="blue"'
                . ( $v eq 'blue' && ' selected' ) . '>Royal Blue (Default)</option>

                    <option value="darkBlue"'
                . ( $v eq 'darkBlue' && ' selected' ) . '>Midnight Blue</option>

                    <option value="lightBlue"'
                . ( $v eq 'lightBlue' && ' selected' ) . '>Dodger Blue</option>

                    <option value="gold"'
                . ( $v eq 'gold' && ' selected' ) . '>Pale Golden</option>

                    <option value="green"'
                . ( $v eq 'green' && ' selected' ) . '>Sea Green</option>

                 <option value="red"'
                . ( $v eq 'red' && ' selected' ) . '>Dark Red</option>

                    <option value="indianRed"'
                . ( $v eq 'indianRed' && ' selected' ) . '>Indian Red</option>

                    <option value="orange"'
                . ( $v eq 'orange' && ' selected' ) . '>Longhorn Orange</option>

                    <option value="white"'
                . ( $v eq 'white' && ' selected' ) . '>White Snow</option>

                    <option value="brown"'
                . ( $v eq 'brown' && ' selected' ) . '>Saddle Brown</option>


                    <option value="purple"'
                . ( $v eq 'purple' && ' selected' ) . '>Dark Purple</option>

                    <option value="grey"'
                . ( $v eq 'grey' && ' selected' ) . '>Dim Grey</option>

                    <option value="darkGrey"'
                . ( $v eq 'darkGrey' && ' selected' ) . '>Dark Grey</option>

                    <option value="user-palette-1"'
                . ( $v eq 'user-palette-1' && ' selected' ) . '>User Palette 1</option>

                    <option value="user-palette-2"'
                . ( $v eq 'user-palette-2' && ' selected' ) . '>User Palette 2</option>

                    <option value="user-palette-3"'
                . ( $v eq 'user-palette-3' && ' selected' ) . '>User Palette 3</option>

                    <option value="user-palette-4"'
                . ( $v eq 'user-palette-4' && ' selected' ) . '>User Palette 4</option>

                    <option value="user-palette-5"'
                . ( $v eq 'user-palette-5' && ' selected' ) . '>User Palette 5</option>

                    <option value="user-palette-6"'
                . ( $v eq 'user-palette-6' && ' selected' ) . '>User Palette 6</option>

                    <option value="user-palette-7"'
                . ( $v eq 'user-palette-7' && ' selected' ) . '>User Palette 7</option>

                    <option value="user-palette-8"'
                . ( $v eq 'user-palette-8' && ' selected' ) . '>User Palette 8</option>

                    <option value="user-palette-9"'
                . ( $v eq 'user-palette-9' && ' selected' ) . '>User Palette 9</option>

                    <option value="user-palette-10"'
                . ( $v eq 'user-palette-10' && ' selected' ) . '>User Palette 10</option>


                </select>';
        }
        elsif ( $k eq 'settings_background_color' ) {
            $v = '<select class="ui_select" name="' . $k . '">

                    <option value="gainsboro"'
                . ( $v eq 'gainsboro' && ' selected' ) . '>Gainsboro (Default)</option>

                    <option value="lightGrey"'
                . ( $v eq 'lightGrey' && ' selected' ) . '>White Smoke</option>

                    <option value="ghostWhite"'
                . ( $v eq 'ghostWhite' && ' selected' ) . '>Ghost White</option>

                </select>';
        }
        elsif ($k eq 'settings_cm_view_palette'
            || $k eq 'settings_cm_editor_palette' )
        {
            $v = '<select class="ui_select" name="' . $k . '">

                    <option value="elegant"'
                . ( $v eq 'elegant' && ' selected' ) . '>Elegant (Default)</option>

                    <option value="monokai"'
                . ( $v eq 'monokai' && ' selected' ) . '>Monokai</option>

                </select>';
        }
        elsif ( $k eq 'settings_notification_color' ) {
            $v = '<select class="ui_select" name="' . $k . '">

                    <option value="grey"'
                . ( $v eq 'grey' && ' selected' ) . '>Dim Grey (Default)</option>

                    <option value="white"'
                . ( $v eq 'white' && ' selected' ) . '>White</option>

                </select>';
        }
        elsif ( $k eq 'settings_window_exclusion_list' ) {
            $v = '
                <input data-role="tagsinput" style="display: inline; width: 75%; height: 26px; max-height: 26px; vertical-align: middle;" class="form-control ui_textbox" type="text" name="'
                . $k . '" value="' . $v . '">
            ';
        }

        return '
            <tr class="atshover">
                <td class="col_label atscontent"><b>'
            . $Atext{$k} . '</b>'
            . ( $Atext{ $k . '_description' }
                && '<div class="smaller text-normal no-padding">' . $Atext{ $k . '_description' } . '</div>' )
            . '</td>
                <td class="col_value atscontent"><span>'
            . $v . '</span></td>
            </tr>
        ';
    }

    if ( $t eq 'footer' ) {
        return '
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <table class="ui_form_end_buttons" style="width:100%">
                    <tbody>
                        <tr>
                            <td>
                                <div class="btn-group">
                                    <a style="min-width:106px" class="btn btn-success" id="atsave"><i class="fa fa-fw fa-floppy-o" style="margin-right:7px;"></i>'
            . $text{'save'} . '</a>
                                    <a style="min-width:146px" class="btn btn-default" id="atrestore"><i class="fa fa-fw fa-history" style="margin-right:7px;"></i>'
            . $Atext{'settings_right_restore_defaults'} . '</a>
                                    <a style="min-width:132px" class="btn btn-default" id="atclearcache"><i class="fa fa-fw fa-hourglass-o" style="margin-right:7px;"></i>'
            . $Atext{'settings_right_clear_local_cache'} . '</a>
                                    <a class="btn btn-warning authentic_update" href="'
            . $gconfig{'webprefix'}
            . '/webmin/edit_themes.cgi"><i class="fa fa-fw fa-refresh" style="margin-right:7px;"></i>'
            . $Atext{'theme_force_update'} . '</a>
                                </div>
                            </td>
                            <td style="text-align: right;">
                                <div class="btn-group">
                                    <a class="btn btn-default page_footer_ajax_submit" id="edit_styles" href="'
            . $gconfig{'webprefix'}
            . '/settings-editor_read.cgi"><i class="fa fa-fw fa-file-code-o" style="margin-right:7px;"></i>'
            . $Atext{'settings_right_theme_extensions'} . '</a>
                                    <a class="btn btn-default page_footer_ajax_submit" id="edit_logos" href="'
            . $gconfig{'webprefix'}
            . '/settings-upload.cgi"><i class="fa fa-fw fa-file-image-o" style="margin-right:7px;"></i>'
            . $Atext{'settings_right_theme_logos'} . '</a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        ';
    }

    if ( $t eq 'save' || $t eq 'restore' ) {

        __config_dir_available();

        if ( $t eq 'save' ) {

            !foreign_available("webmin") && error($Atext{'theme_error_access_not_root'});

            delete @in{ grep( !/^settings_/, keys %in ) };
            for ( values %in ) {s/(.*)/'$1';/}
            for ( values %in ) {s/"/'/g}
            for ( values %in ) {s/\/\//&#47;&#47;/g}
            for ( values %in ) {s/'true'/true/g}
            for ( values %in ) {s/'false'/false/g}
            for ( values %in ) {
                s/
                   \G
                   (
                      (?: ^ [^']* ' | (?!^) )
                      (?: [^'\\]+ | \\. )*
                   )
                   '
                   (?! [^']* \z )
                /
                   $1 . "\\'"
                /xseg;
            }
            write_file( $config_directory . "/authentic-theme/settings.js", \%in );
        }
        if ( $t eq 'restore' ) {

            !foreign_available("webmin") && error($Atext{'theme_error_access_not_root'});

            unlink_file( $config_directory . "/authentic-theme/settings.js" );
            if ( usermin_available() ) {
                unlink_file( $__usermin_config . "/authentic-theme/settings.js" );
            }
        }

        if ( usermin_available() ) {
            unlink_file( $__usermin_config . "/authentic-theme/settings.js" );
            copy_source_dest( $config_directory . "/authentic-theme/settings.js",
                $__usermin_config . "/authentic-theme" );
        }

        if ( -r $config_directory . "/authentic-theme/logo.png"
            && usermin_available() )
        {
            unlink_file( $__usermin_config . "/authentic-theme/logo.png" );
            copy_source_dest( $config_directory . "/authentic-theme/logo.png", $__usermin_config . "/authentic-theme" );
        }
        if ( -r $config_directory . "/authentic-theme/logo_welcome.png"
            && usermin_available() )
        {
            unlink_file( $__usermin_config . "/authentic-theme/logo_welcome.png" );
            copy_source_dest( $config_directory . "/authentic-theme/logo_welcome.png",
                $__usermin_config . "/authentic-theme" );
        }
    }
}

sub get_xhr_request {
    if ( $in{'xhr-navigation'} eq '1' ) {
        head();
        do "authentic-theme/navigation.pm";
    }
    elsif ( $in{'xhr-buttons'} eq '1' ) {
        head();
        do "authentic-theme/buttons.pm";
    }
    elsif ( $in{'xhr-default'} eq '1' ) {
        head();
        print $t_goto;
    }
    elsif ( $in{'xhr-settings'} eq '1' ) {
        head();
        if ( $in{'save'} eq '1' ) {
            _settings( 'save', undef, undef );
        }
        elsif ( $in{'restore'} eq '1' ) {
            _settings( 'restore', undef, undef );
        }
        else {
            do "authentic-theme/settings.pm";
        }
    }
    elsif ( $in{'xhr-get_theme_language'} eq '1' ) {
        head();
        print get_theme_language();
    }
    elsif ( $in{'xhr-get_available_modules'} eq '1' ) {
        head();
        print get_available_modules('json');
    }
    elsif ( $in{'xhr-get_size'} eq '1' ) {
        head();
        my $size = recursive_disk_usage( get_access_data('root') . $in{'xhr-get_size_path'} );
        print nice_size($size) . '|' . $size;
    }
    elsif ( $in{'xhr-get_nice_size'} eq '1' ) {
        head();
        print nice_size( $in{'xhr-get_nice_size_sum'} );
    }
    elsif ( $in{'xhr-get_command_exists'} eq '1' ) {
        head();
        print has_command( $in{'xhr-get_command_exists_name'} );
    }
    elsif ( $in{'xhr-get_symlink'} eq '1' ) {
        head();
        print resolve_links( get_access_data('root') . $in{'xhr-get_symlink_path'} );
    }
    elsif ( $in{'xhr-info'} eq '1' ) {

        our (
            $cpu_percent,        $mem_percent,             $virt_percent,    $disk_percent,
            $host,               $os,                      $webmin_version,  $virtualmin_version,
            $cloudmin_version,   $authentic_theme_version, $local_time,      $kernel_arch,
            $cpu_type,           $cpu_temperature,         $hdd_temperature, $uptime,
            $running_proc,       $load,                    $real_memory,     $virtual_memory,
            $disk_space,         $package_message,         $csf_title,       $csf_data,
            $csf_remote_version, $authentic_remote_version
        ) = get_sysinfo_vars();

        head();

        if ( &foreign_available("system-status") ) {

            my @updated_info = {
                "data"                     => 1,
                "cpu_percent"              => $cpu_percent,
                "mem_percent"              => $mem_percent,
                "virt_percent"             => $virt_percent,
                "disk_percent"             => $disk_percent,
                "host"                     => $host,
                "os"                       => $os,
                "webmin_version"           => $webmin_version,
                "virtualmin_version"       => $virtualmin_version,
                "cloudmin_version"         => $cloudmin_version,
                "authentic_theme_version"  => $authentic_theme_version,
                "local_time"               => $local_time,
                "kernel_arch"              => $kernel_arch,
                "cpu_type"                 => $cpu_type,
                "cpu_temperature"          => $cpu_temperature,
                "hdd_temperature"          => $hdd_temperature,
                "uptime"                   => $uptime,
                "running_proc"             => $running_proc,
                "load"                     => $load,
                "real_memory"              => $real_memory,
                "virtual_memory"           => $virtual_memory,
                "disk_space"               => $disk_space,
                "package_message"          => $package_message,
                "csf_title"                => $csf_title,
                "csf_data"                 => $csf_data,
                "csf_remote_version"       => $csf_remote_version,
                "authentic_remote_version" => $authentic_remote_version,
                "csf_deny"                 => csf_temporary_list(),
            };
            print JSON->new->latin1->encode(@updated_info);
        }
        else {
            print JSON->new->latin1->encode( {} );
        }
    }
    if ( index( $in, 'xhr-' ) gt "-1" ) {
        exit;
    }
}

sub get_default_right {
    my $udefgoto;
    my $t_goto;

    # Check user settings on default page for Virtualmin/Cloudmin
    if ($t_uri_virtualmin != -1
        && ($t_uri___i
            || (   length $__settings{'settings_right_virtualmin_default'}
                && $__settings{'settings_right_virtualmin_default'} ne ''
                && ( \domain_available( $__settings{'settings_right_virtualmin_default'}, 'id' )
                    || $__settings{'settings_right_virtualmin_default'} eq 'index.cgi' )
            )
        )

        )
    {
        if ( $get_user_level eq '2' ) {
            if ($t_uri___i) {
                my $dom = domain_available( $t_uri___i, 'dom' );
                if ($dom) {
                    $udefgoto = '/virtual-server/view_domain.cgi?dom=' . $dom->{'id'};
                }
                else {
                    $udefgoto = '/sysinfo.cgi';
                }
            }
            else {
                $udefgoto = '/sysinfo.cgi';
            }

        }
        else {
            if ( $__settings{'settings_right_virtualmin_default'} eq 'index.cgi' && !$t_uri___i ) {
                $udefgoto = '/virtual-server/index.cgi';
            }
            else {
                if ( !$t_uri___i ) {
                    $udefgoto
                        = '/virtual-server/summary_domain.cgi?dom=' . $__settings{'settings_right_virtualmin_default'};
                }
                else {
                    if ($t_uri___i) {
                        my $dom = domain_available( $t_uri___i, 'dom' );
                        if ($dom) {
                            $udefgoto = '/virtual-server/summary_domain.cgi?dom=' . $dom->{'id'};
                        }
                        else {
                            $udefgoto = '/virtual-server/index.cgi';
                        }
                    }
                    else {
                        $udefgoto = '/virtual-server/index.cgi';
                    }
                }

            }
        }
    }
    elsif (
        $t_uri_cloudmin != -1
        && ($t_uri___i
            || (   length $__settings{'settings_right_cloudmin_default'}
                && $__settings{'settings_right_cloudmin_default'} ne ''
                && ( \server_available( $__settings{'settings_right_cloudmin_default'}, 'id' )
                    || $__settings{'settings_right_cloudmin_default'} eq 'index.cgi' )
            )
        )
        )
    {
        if ( $__settings{'settings_right_cloudmin_default'} eq 'index.cgi'
            && !$t_uri___i )
        {
            $udefgoto = '/server-manager/index.cgi';
        }
        else {
            if ( !$t_uri___i ) {
                $udefgoto = '/server-manager/edit_serv.cgi?id=' . $__settings{'settings_right_cloudmin_default'};
            }
            else {

                if ($t_uri___i) {
                    my $host = server_available( $t_uri___i, 'host' );
                    if ($host) {
                        $udefgoto = '/server-manager/edit_serv.cgi?id=' . $host->{'id'};
                    }
                    else {
                        $udefgoto = '/server-manager/index.cgi';
                    }
                }
                else {
                    $udefgoto = '/server-manager/index.cgi';
                }
            }
        }
    }
    else {
        our %virtualmin_config = &foreign_config('virtual-server');
        if (   $t_uri_virtualmin != -1
            && $virtualmin_config{'wizard_run'} ne '1' )
        {
            $udefgoto = '/virtual-server/wizard.cgi';
        }
        else {
            $udefgoto = '/sysinfo.cgi';
        }
    }

    # Going to default right page
    my $minfo = &get_goto_module();
    $t_goto
        = ( $t_uri_virtualmin != -1 || $t_uri_cloudmin != -1 || $t_uri_dashboard != -1 ) ? $udefgoto
        : $minfo ? "$minfo->{'dir'}/"
        :          $udefgoto;

    # Filemin tweak for maintaining localStorage consistency
    if (   index( $t_goto, 'filemin' ) == 0
        || index( $t_goto, 'file-manager' ) == 0 )
    {
        $t_goto = $t_goto . 'index.cgi?path=';
    }

    # Prevent Virtualmin/Cloudmin module from being set as default page
    if (   $minfo->{'dir'} eq 'virtual-server'
        || $minfo->{'dir'} eq 'server-manager' )
    {
        $t_goto = '/sysinfo.cgi';
    }

    # Goto Inbox in Usermin Mail mode
    if (   $get_user_level eq '3' & foreign_available("mailbox")
        && $t_uri_webmail != -1 )
    {
        $t_goto = '/mailbox/index.cgi?id=INBOX';
    }

    return $t_goto;
}

sub init_error {
    if (  !-d $root_directory . "/authentic-theme"
        && -d $root_directory . "/authentic-theme-master" )
    {
        die("ATTENTION:\nHave you downloaded Authentic Theme from GitHub, and unpacked it manually\nto Webmin directory? In this case you need to rename theme directory from\n`authentic-theme-master` to `authentic-theme` in order to make theme work.\nAfterward, you will need to reset the theme again in Webmin Configuration.\n"
        );
    }
}

sub init_type {
    ( ( $ENV{'CONTENT_TYPE'} =~ /multipart\/form-data/i ) ? ReadParseMime() : ReadParse() );
}

sub init {

    # Register hooks
    $t_uri____i = ( $t_uri_cloudmin == -1 ? 'dom' : 'sid' );
    $t_uri_virtualmin != -1
        ? ( $t_uri___i = ( $in{'domain'} ? $in{'domain'} : $in{'dom'} ) )
        : undef;
    $t_uri_cloudmin != -1
        ? ( $t_uri___i = ( $in{'serv'} ? $in{'serv'} : $in{'server'} ) )
        : undef;

    # Store request and prevent collisions
    if ( index( $t_uri__i, 'virtualmin&dom' ) eq 2 ) {
        $t_uri___i_virtualmin = $t_uri___i;
        $t_uri__i             = '/?virtualmin';
    }
    elsif ( index( $t_uri__i, 'cloudmin&serv' ) eq 2 ) {
        $t_uri___i_cloudmin = $t_uri___i;
        $t_uri__i           = '/?cloudmin';
    }

    our $t_goto = get_default_right();

    # User-friendly message for those installing from GitHub
    &init_error();

    # Provide unobstructive access for AJAX calls
    &get_xhr_request();

    # Redirect user away, in case requested mode can not be satisfied
    if (   $t_uri__i ne '/'
        && $t_uri__i ne '/?virtualmin'
        && $t_uri__i ne '/?cloudmin'
        && $t_uri__i ne '/?mail'
        && $t_uri__i ne '/?dashboard'
        && index( $t_uri__i, 'xhr' ) lt 0 )
    {
        my $l = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/';
        print "Location: $l\n\n";

    }
    elsif (
           ( $t_uri_virtualmin != -1 && !&foreign_available("virtual-server") )
        || ( $t_uri_cloudmin != -1 && !&foreign_available("server-manager") )
        || ($t_uri_webmail != -1
            && (&get_product_name() ne 'usermin'
                || ( &get_product_name() eq 'usermin'
                    && !&foreign_available("mailbox") )
            )
        )
        )
    {
        print "Set-Cookie: redirect=0; path=/\r\n";
        my $l = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/';
        print "Location: $l\n\n";
    }

    # In case Virtualmin/Cloudmin is installed, after
    # logging in, redirect to Virtualmin/Cloudmin
    # and check for force options as well
    my $settings_force_default_tab        = $__settings{'settings_force_default_tab'};
    my $settings_right_default_tab_webmin = $__settings{'settings_right_default_tab_webmin'};
    my %virtualmin_config                 = &foreign_config('virtual-server');

    if (   $get_user_level eq '0'
        && &foreign_available("virtual-server")
        && $virtualmin_config{'wizard_run'} ne '1'
        && $cookies{'redirect'} eq '1' )
    {
        print "Set-Cookie: redirect=0; path=/\r\n";

        $d = '/?virtualmin';
        print "Location: $d\n\n";
    }
    elsif (
        ( $cookies{'redirect'} eq '1' || $settings_force_default_tab eq 'true' )
        && (   &foreign_available("virtual-server")
            || &foreign_available("server-manager") )
        && &get_product_name() eq "webmin"
        && ((   $t_uri_virtualmin == -1 && $t_uri_cloudmin == -1 && length $settings_right_default_tab_webmin > 1
                || ($settings_force_default_tab eq 'true'
                    && (( $t_uri_cloudmin != -1 && index( $settings_right_default_tab_webmin, 'cloudmin' ) == -1 )
                        || ( $t_uri_virtualmin != -1
                            && index( $settings_right_default_tab_webmin, 'virtualmin' ) == -1 )
                    )
                )
            )
        )
        )
    {
        print "Set-Cookie: redirect=0; path=/\r\n";
        my $d
            = ( get_env('https') ? 'https://' : 'http://' )
            . get_env('http_host')
            . (
            length $settings_right_default_tab_webmin
            ? $settings_right_default_tab_webmin
            : ( foreign_available("virtual-server") ? '/?virtualmin' : '/' )
            );

        # Prevent redirect-loop in case one of the
        # modules were remove and old settings are used
        if (( index( $settings_right_default_tab_webmin, 'cloudmin' ) != -1 && !&foreign_available("server-manager") )
            || ( index( $settings_right_default_tab_webmin, 'virtualmin' ) != -1
                && !&foreign_available("virtual-server") )
            )
        {
        }
        else {
            print "Location: $d\n\n";

        }
    }

    # In case Mailbox module is installed, after
    # logging in, redirect to Webmail
    if (   $cookies{'redirect'} eq '1'
        && &foreign_check("mailbox")
        && &foreign_available("mailbox")
        && &get_product_name() eq "usermin"
        && $t_uri_webmail == -1 )
    {
        print "Set-Cookie: redirect=0; path=/\r\n";
        my $webmail
            = ( get_env('https') ? 'https://' : 'http://' )
            . get_env('http_host')
            . (
            length $__settings{'settings_right_default_tab_usermin'}
            ? $__settings{'settings_right_default_tab_usermin'}
            : '/'
            );
        print "Location: $webmail\n\n";
    }

    if ( $cookies{'redirect'} eq '1' ) {
        print "Set-Cookie: redirect=0; path=/\r\n";

    }

    # Clearing possibly stuck update states
    if (   index( $t_uri__i, 'updating-webmin-theme' ) != -1
        || index( $t_uri__i, 'downloading-webmin-theme' ) != -1
        || index( $t_uri__i, 'updating-usermin-theme' ) != -1
        || index( $t_uri__i, 'downloading-usermin-theme' ) != -1
        || index( $t_uri__i, 'recollect' ) != -1
        || index( $t_uri__i, 'recollect-system-status' ) != -1
        || index( $t_uri__i, 'recollecting' ) != -1
        || index( $t_uri__i, 'recollecting-system-status' ) != -1
        || index( $t_uri__i, 'recollecting-package-updates' ) != -1
        || index( $t_uri__i, 'recollecting-package-updates-processing' ) != -1 )
    {
        if ( $t_uri_virtualmin != -1 ) {
            my $virtualmin = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/?virtualmin';
            print "Location: $virtualmin\n\n";
        }
        elsif ( $t_uri_cloudmin != -1 ) {
            my $cloudmin = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/?cloudmin';
            print "Location: $cloudmin\n\n";
        }
        elsif ( $t_uri_dashboard != -1 ) {
            my $dashboard = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/?dashboard';
            print "Location: $dashboard\n\n";
        }
        else {
            my $webmin = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/';
            print "Location: $webmin\n\n";
        }
    }

    # Force regular user to be in Virtualmin
    if (   $get_user_level eq '2'
        && $t_uri__i ne '/?virtualmin' )
    {
        my $virtualmin = ( get_env('https') ? 'https://' : 'http://' ) . get_env('http_host') . '/?virtualmin';
        print "Location: $virtualmin\n\n";
    }

    # Make ConfigServer Security Firewall look as we need
    if ( -r '/usr/local/csf/lib/webmin/csf/index.cgi' ) {
        open( my $FILE, "<", "/usr/local/csf/lib/webmin/csf/index.cgi" );
        my @l = <$FILE>;
        close($FILE);

        if ( grep {/data-replaced/} @l ) {
            return;
        }

        my @n;
        foreach (@l) {
            $_ =~ s/%in\);/%in, \$current_theme);/g;
            $_ =~ s/<HTML>/<HTML style="background-color: $__settings{'settings_background_color'}">/g;
            $_ =~ s/<BODY>//g;
            $_
                =~ s/^(?!<<)EOF/EOF\nif (\$current_theme eq 'authentic-theme') {print "<BODY style=\\"opacity: 0; overflow: hidden; pointer-events: none;\\">\\n";} else {print "<BODY data-replaced=\\"true\\">\\n";}/g;
            push( @n, $_ );
        }

        open( $FILE, ">", "/usr/local/csf/lib/webmin/csf/index.cgi" );
        print $FILE @n;
        close($FILE);
    }

}

sub content {

    # Wrapper
    print '<div id="wrapper" data-product="'
        . &get_product_name()
        . '" data-virtual-server="'
        . $t_uri_virtualmin
        . '" data-virtual-server-license="'
        . licenses('vm')
        . '" data-server-manager="'
        . $t_uri_cloudmin
        . '" data-server-manager-license="'
        . licenses('cm')
        . '" data-webmail="'
        . $t_uri_webmail
        . '" data-dashboard="'
        . $t_uri_dashboard
        . '" data-access-level="'
        . $get_user_level
        . '" data-hostname="'
        . &get_display_hostname()
        . '" class="index">' . "\n";

    # Mobile toggle
    print '<div class="visible-xs mobile-menu-toggler" style="position: fixed; ' . get_filters('navigation') . '">';
    print
        '<button type="button" class="btn btn-primary btn-menu-toggler" style="padding-left: 6px; padding-right: 5px;">'
        . "\n";
    print '<i class="fa fa-fw fa-lg fa-bars"></i>' . "\n";
    print '</button>' . "\n";
    print '</div>' . "\n";

    #### Left
    print '<aside style="z-index:10; ' . get_filters('navigation') . '" id="sidebar" class="hidden-xs">' . "\n" . "\n";

    &print_switch();

    # Navigation
    print '<ul class="navigation">' . "\n";
    do "authentic-theme/navigation.pm";
    print '</ul>' . "\n";

    # Buttons
    print '<br><br><ul class="user-links">';
    do "authentic-theme/buttons.pm";
    print '</ul>';

    # Custom text
    print '<ul class="user-html"><li class="user-html-string">'
        . (
        (          $__settings{'settings_leftmenu_user_html_only_for_administrator'} ne 'true'
                || $__settings{'settings_leftmenu_user_html_only_for_administrator'} eq 'true'
                && $get_user_level eq '0'
        ) ? $__settings{'settings_leftmenu_user_html'} : undef
        ) . '</li></ul>';

    print '</aside>' . "\n";

    # Authenticated logo
    embed_logo();

    # Favorites menu
    print_favorites();

    # Right
    print '<div id="content" class="__page">' . "\n";
    print '<div class="loader-container">' . "\n";
    print '<div class="loader"><span class="loading"><svg style="'
        . get_filters('content')
        . '" class="loading-container" viewBox="0 0 44 44" data-reactid=".0.0.0"><circle class="loading-path" cx="22" cy="22" r="20" fill="none" stroke-width="0.4" data-reactid=".0.0.0.0"></circle></svg></span></div>'
        . "\n";
    print '</div>' . "\n";
    print '<script>__lrs()</script>';
    print '<iframe name="page" id="iframe" src="'
        . $gconfig{'webprefix'}
        . (
        (          -f $root_directory . '/authentic-theme/update'
                && $t_uri_dashboard == -1
                && $get_user_level ne '1'
                && $get_user_level ne '2'
                && $get_user_level ne '3'
                && $get_user_level ne '4'
        )
        ? '/sysinfo.cgi'
        : $t_goto
        ) . '">' . "\n";
    print '</iframe>' . "\n";
    print '</div>' . "\n";
}

sub get_cookies {

    my @r = split /; /, get_env('http_cookie');
    my %c;

    foreach (@r) {
        my ( $k, $v ) = split /=/, $_;
        $c{$k} = $v;
    }

    return %c;
}

sub get_access_data {
    my ($key) = @_;
    if ($key) {
        if ( $key eq 'root' && $gaccess{'root'} eq '/' ) {
            return undef;
        }
        else {
            return $gaccess{$key};
        }
    }
    else {
        return %gaccess;
    }
}

sub get_available_modules {
    my ($json) = @_;
    my @mods;
    foreach my $x ( get_all_module_infos() ) {
        if ( $x->{'dir'} ne undef ) {
            push @mods, $x->{'dir'};
        }
    }
    if ( $json eq 'json' ) {

        if (@mods) {
            return JSON->new->latin1->encode( \@mods );
        }
        else {
            return JSON->new->latin1->encode( {} );
        }
    }
    else {
        return @mods;
    }

}

sub get_theme_language {

    my %text = &load_language($current_theme);

    my %s;
    foreach my $key ( keys %text ) {
        if ( index( $key, '_xhred_' ) == -1 ) {next}
        $s{$key} .= $Atext{$key};
    }

    if (%s) {
        return JSON->new->latin1->encode( \%s );
    }
    else {
        return JSON->new->latin1->encode( {} );
    }

}

sub get_module_config_data {
    my ( $module, $key ) = @_;

    if ( -r $config_directory . '/' . $module . '/config' ) {

        my $config = &read_file_contents( $config_directory . '/' . $module . '/config' );
        my %config = $config =~ /(.*?)=(.*)/g;

        if ($key) {
            return $config{$key};
        }
        else {
            return %config;
        }
    }
    else {
        return undef;
    }

}

sub replace {
    my ( $from, $to, $string ) = @_;
    $string =~ s/$from/$to/ig;

    return $string;
}

1;
