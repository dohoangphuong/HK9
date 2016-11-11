/*!
 * Authentic Theme 18.10 (https://github.com/qooob/authentic-theme)
 * Copyright 2014-2016 Ilia Rostovtsev <programming@rostovtsev.ru>
 * Licensed under MIT (https://github.com/qooob/authentic-theme/blob/master/LICENSE)
 */
;
$(".table.table-striped.table-hover.table-condensed").on("change", 'input[type="checkbox"]', function(a) {
    db_check_selected()
});
$(".select_all, .select_invert").on("click", function(a) {
    db_check_selected()
});

function db_check_selected() {
    var b = $('.table.table-striped.table-hover.table-condensed input[type="checkbox"]:checked').length;
    if (b === 0) {
        $("button#edit, button#delete, button#deleteClone, input#delete").prop("disabled", true)
    } else {
        $("button#edit, button#delete, button#deleteClone, input#delete").prop("disabled", false)
    }
    var c = $("button#edit span"),
        a = $("button#delete span"),
        d = $("button#deleteClone span");
    if ($current_page_full == $_____link_full + "/mysql/edit_dbase.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_dbase.cgi") {
        if (b > 1) {
            d.text(lang("theme_xhred_database_objects_selected_delete"))
        } else {
            d.text(lang("theme_xhred_database_object_selected_delete"))
        }
    } else {
        if ($current_page_full == $_____link_full + "/mysql/edit_table.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_table.cgi") {
            if (b > 1) {
                d.text(lang("theme_xhred_database_delete_selected_fields"))
            } else {
                d.text(lang("theme_xhred_database_delete_selected_field"))
            }
        } else {
            if ($current_page_full == $_____link_full + "/mysql/" || $current_page_full == $_____link_full + "/postgresql/" || $current_page_full == $_____link_full + "/mysql/index.cgi" || $current_page_full == $_____link_full + "/postgresql/index.cgi") {
                if (b > 1) {
                    d.text(lang("theme_xhred_database_dbs_selected_drop"))
                } else {
                    d.text(lang("theme_xhred_database_db_selected_drop"))
                }
            } else {
                if ($__source_file != "list_users.cgi" && $__source_file != "list_dbs.cgi" && $__source_file != "list_tprivs.cgi" && $__source_file != "list_cprivs.cgi") {
                    if (b > 1) {
                        c.text(lang("theme_xhred_database_edit_selected_rows"));
                        a.text(lang("theme_xhred_database_delete_selected_rows"))
                    } else {
                        c.text(lang("theme_xhred_database_edit_selected_row"));
                        a.text(lang("theme_xhred_database_delete_selected_row"))
                    }
                }
            }
        }
    }
}
if (!$__source_file || $__source_file == "list_users.cgi" || $__source_file == "list_dbs.cgi" || $__source_file == "list_tprivs.cgi" || $__source_file == "list_cprivs.cgi") {
    db_check_selected();
    __init_dt_($(".table.table-striped.table-hover.table-condensed"));
    f__mgk_fi();
    if ($__source_file == "list_dbs.cgi" || $__source_file == "list_tprivs.cgi" || $__source_file == "list_cprivs.cgi") {
        $(".fa-user-times").addClass("fa-times-circle").removeClass("fa-user-times")
    }
}
if ($current_page_full == $_____link_full + "/mysql/drop_dbases.cgi" || $current_page_full == $_____link_full + "/postgresql/drop_dbases.cgi" || $current_page_full == $_____link_full + "/mysql/drop_tables.cgi" || $current_page_full == $_____link_full + "/postgresql/drop_tables.cgi") {
    setTimeout(function() {
        $(".btn.btn-default").removeClass("heighter-28 btn-default").addClass("heighter-34 btn-danger")
    }, 10)
}
if ($current_page_full == $_____link_full + "/mysql/" || $current_page_full == $_____link_full + "/postgresql/" || $current_page_full == $_____link_full + "/mysql/index.cgi" || $current_page_full == $_____link_full + "/postgresql/index.cgi") {
    setTimeout(function() {
        $('.panel-body .table-hardcoded tr td[align="right"]:last-child').find("a").addClass("btn btn-tiny btn-inverse").prepend('<i class="fa fa-fw fa-minus-square-o"></i>&nbsp;&nbsp;');
        if ($(".ui_select.heighter-34").length) {
            $('a[href="newdb_form.cgi"]').addClass("btn btn-success").text($('a[href="newdb_form.cgi"]').text().replace(".", "")).prepend('<i class="fa fa-fw fa-plus"></i>&nbsp;&nbsp;')
        }
    }, 10);
    $("body").on("click", "#newClone, #deleteClone", function(a) {
        a.preventDefault();
        $("#" + ($(this).attr("id").replace("Clone", ""))).trigger("click")
    })
}
if (!settings_thirdparty_xsql_fit_content_screen_height) {
    $('<style type="text/css">.long-table-scroll {max-height: 100% !important;}</style>').appendTo("head")
}
if ($current_page_full == $_____link_full + "/mysql/edit_dbase.cgi" || $current_page_full == $_____link_full + "/mysql/edit_table.cgi" || $current_page_full == $_____link_full + "/mysql/view_table.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_dbase.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_table.cgi" || $current_page_full == $_____link_full + "/postgresql/view_table.cgi") {
    setTimeout(function() {
        $('.panel-body .table-hardcoded tr td[align="right"]:last-child').find("a").addClass("btn btn-tiny btn-inverse").prepend('<i class="fa fa-fw fa-minus-square-o"></i>&nbsp;&nbsp;')
    }, 10);
    if ($current_page_full == $_____link_full + "/mysql/view_table.cgi" || $current_page_full == $_____link_full + "/postgresql/view_table.cgi") {
        var magic_form_save_button_spinner = '<span class="cspinner_container" style=" width: 19px; height: 14px; display: inline-block;"><span class="cspinner" style="margin-top: -4px; margin-left: -11px;"><span class="cspinner-icon white small"></span></span></span>';
        $("#delete").remove();
        $("#edit").length && $("#new").addClass("hidden");
        $("#edit").replaceWith('				<div class="btn-group">					<button class="btn btn-default" type="submit" name="edit" id="edit" disabled><i class="fa fa-fw fa-i-cursor">&nbsp;&nbsp;</i><span>' + lang("theme_xhred_database_edit_selected_row") + '</span></button>					<button class="btn btn-success" type="submit" name="newClone" id="newClone"><i class="fa fa-fw fa-plus-circle">&nbsp;&nbsp;</i><span>' + lang("theme_xhred_database_add_new_row") + '</span></button>					<button class="btn btn-warning" type="submit" name="delete" id="delete" disabled><i class="fa fa-fw fa-trash">&nbsp;&nbsp;</i><span>' + lang("theme_xhred_database_delete_selected_row") + "</span></button>				</div>			");
        $("body").on("click", "#newClone, #deleteClone", function(a) {
            a.preventDefault();
            $("#" + ($(this).attr("id").replace("Clone", ""))).trigger("click")
        })
    }
    $(function() {
        $(".table.table-striped.table-hover.table-condensed").css({
            width: "99.7%"
        }).wrap('<div class="long-table-wrapper"><div class="long-table-scroll"></div></div>');
        $("body").on("click", 'td > label[for^="row_"], td.td_tag.selectable', function(a) {
            a.preventDefault();
            a.stopPropagation();
            $(this).selectText()
        });
        $("body").on("dblclick", 'td > label[for^="row_"], td.td_tag.selectable', function(a) {
            a.preventDefault();
            a.stopPropagation()
        });
        $("body").on("click", ".long-table-wrapper div.thead", function(a) {
            if ($("#savenew").length) {
                return
            }
            if ($(this).find("i").hasClass("fa-plus-square")) {
                $(this).find("i").removeClass("fa-plus-square").addClass("fa-minus-square");
                $(this).find("i").parent().next(".long-table-scroll").find(".table-hardcoded").removeClass("hidden")
            } else {
                $(this).find("i").addClass("fa-plus-square").removeClass("fa-minus-square");
                $(this).find("i").parent().next(".long-table-scroll").find(".table-hardcoded").addClass("hidden")
            }
            $(t___wi).trigger("resize")
        });
        $.each($(".table.table-striped.table-hover.table-condensed").find("thead th, tbody td:last-child"), function(b, a) {
            if ($(this).is("th")) {
                $(this).html("<em>" + $(this).text() + "</em>")
            }
            if ($(this).is(":last-child") && !$(this).parents(".table-hardcoded").length) {
                $(this).css("border-right", "1px solid #eee")
            }
        }).promise().done(function() {
            $.each($(".table.table-striped.table-hover.table-condensed").find("tbody tr td"), function(b, a) {
                if ($current_page_full == $_____link_full + "/mysql/view_table.cgi" || $current_page_full == $_____link_full + "/postgresql/view_table.cgi") {
                    $(this).parent("tr").addClass("selectable");
                    $(this).addClass("selectable")
                }!$(this).find("table").length && $(this).attr("title", $.trim($(this).text()))
            }).promise().done(function() {
                var h = '<i class="fa fa-fw fa-floppy-o">&nbsp;&nbsp;</i>',
                    g = '<i class="fa fa-fw fa-check-circle-o">&nbsp;&nbsp;</i>',
                    o = '<i class="fa fa-fw fa-trash-o">&nbsp;&nbsp;</i>',
                    n = '<span class="cspinner_container" style=" width: 18px; height: 14px; display: inline-block;"><span class="cspinner" style="margin-top: 1px; margin-left: -11px;"><span class="cspinner-icon white small"></span></span></span>',
                    l = '<span class="cspinner_container" style=" width: 18px; height: 14px; display: inline-block;"><span class="cspinner" style="margin-top: 1px; margin-left: -11px;"><span class="cspinner-icon dark small"></span></span></span>';
                var c = false;
                if ($current_page_full == $_____link_full + "/mysql/view_table.cgi" || $current_page_full == $_____link_full + "/postgresql/view_table.cgi") {
                    var p = parseInt($(".ui_form > .long-table-wrapper .long-table-scroll").width()),
                        a = parseInt($(".ui_form > .long-table-wrapper .long-table-scroll > table").width()),
                        c = (a > p ? true : false)
                }
                if (!c) {
                    $("body").addClass("__non_res__")
                }
                if (($current_page_full == $_____link_full + "/mysql/view_table.cgi" || $current_page_full == $_____link_full + "/postgresql/view_table.cgi") && $("#save, #savenew").length && $("#cancel").length) {
                    if ($("#save").length && $("#cancel").length) {
                        $("#cancel").remove();
                        $("#save").replaceWith('								<div class="btn-group">									<button class="btn btn-success" type="submit" name="save" id="save">' + h + "" + lang("theme_xhred_global_update") + '</button>									<button class="btn btn-default" type="submit" name="save-close" id="save-close">' + g + "" + lang("theme_xhred_global_update_and_close") + '</button>									<button class="btn btn-default" type="submit" name="cancel" id="cancel"><i class="fa fa-fw fa-undo">&nbsp;&nbsp;</i>' + lang("theme_xhred_global_back") + "</button>								</div>							")
                    }
                    if ($("#savenew").length && $("#cancel").length) {
                        $("#cancel").remove();
                        $("#savenew").replaceWith('								<div class="btn-group">									<button class="btn btn-success" type="submit" name="savenew" id="savenew">' + h + "" + lang("theme_xhred_global_save") + '</button>									<button class="btn btn-default" type="submit" name="savenew-close" id="savenew-close">' + g + "" + lang("theme_xhred_global_save_and_close") + '</button>									<button class="btn btn-default" type="submit" name="cancel" id="cancel"><i class="fa fa-fw fa-undo">&nbsp;&nbsp;</i>' + lang("theme_xhred_global_cancel") + "</button>								</div>							")
                    }
                    var b = $("td.td_tag .table-hardcoded"),
                        m = parseInt($(".ui_form > .long-table-wrapper .long-table-scroll").width()),
                        j = ($(".table.table-striped.table-hover.table-condensed").find("thead th").filter(function(q) {
                            return $(this).position().left + $(this).width() < m
                        }).length + 1),
                        e = $(".table.table-striped.table-hover.table-condensed").find("thead th").length,
                        k = (e - j);
                    var i = 0,
                        f = 0,
                        d = 0;
                    if (navigator.userAgent.toLowerCase().indexOf("firefox") > -1) {
                        i = 25;
                        f = 13;
                        d = 20
                    } else {
                        i = 19;
                        f = 10;
                        d = 15
                    }
                    b.find('input[type="text"], textarea').addClass("input-sm");
                    b.wrap('<div class="long-table-wrapper"><div class="long-table-scroll container-resizeable-scroll" style="width: ' + (parseInt(m - i + 6) + "px") + '; max-height: 28vh;"></div></div>').addClass("container-resizeable-table").css({
                        width: "99%",
                        "margin-top": "-1px"
                    }).parent().parent().parent("td").removeClass("selectable").addClass("col-no-styling container-resizeable-col").attr({
                        colspan: j,
                        style: "padding: 0 !important;"
                    }).find(".long-table-wrapper").attr({
                        style: "margin: 0 !important"
                    }).find(".table-hardcoded tr.thead").attr({
                        style: "border: 0 !important"
                    }).addClass("hidden").next("tr").find("td:first-child").css({
                        width: "20%",
                        "text-align": "left",
                        "padding-left": "10%"
                    }).parent("tr").find("td:last-child").css({
                        width: "80%",
                        "text-align": "left",
                        "padding-left": "10%"
                    });
                    setTimeout(function() {
                        $.each(b.parent(".long-table-scroll").parent(".long-table-wrapper"), function() {
                            var s = $(this).find(".table-hardcoded").find("tbody tr:nth-child(2) td:last-child"),
                                s = (s.find('input[type="text"]').val() ? s.find('input[type="text"]').val() : s.text());
                            $(this).prepend('					 				  <div class="thead container-resizeable-head" style="width: ' + (parseInt(m - i + 12 + f) + "px") + '; height: 23px; background: rgba(233, 242, 255, 0.7); border-top: 1px solid #e6e6e6; border-right: 1px solid #eee; z-index: 999998;">					 				  	<i class="fa fa-fw fa-minus-square text-light pull-right db_editor_collapse' + ($("#savenew").length ? " invisible" : "") + '" style="cursor: default; margin-top: 5px; position: relative; z-index: 999999; margin-right: ' + d + 'px; margin-bottom: -5px;"></i>					 				  	<span class="col-xs-2 text-left pull-left" style="padding-top: 1px; padding-left: 7px;"><em style="font-weight: 500">' + ($("#savenew").length ? "" : s) + '</em></span>					 				  	<span class="col-xs-10 text-left pull-left" style="padding-top: 0; padding-left: 4%; font-size: 14px; font-weight: 500; font-style: italic;">' + ($("#savenew").length ? lang("theme_xhred_database_adding_new_row_data") : "") + "</span>					 				  </div>								")
                        });
                        $(".col-no-styling").parent("tr").addClass("row-no-styling");
                        $(".table.table-striped.table-hover.table-condensed > thead > tr, .table.table-striped.table-hover.table-condensed > tbody > tr:not(.row-no-styling)").addClass("opacity-0_5");
                        var r = ($(".container-resizeable-head").length > 1 ? "s" : ""),
                            q = ($("#savenew").length ? lang("theme_xhred_database_adding_new_row") : lang(("theme_xhred_database_editing_row" + r)));
                        $(".panel-body > center").remove();
                        $(".panel-body").prepend('<center><span class="h4">' + q + "</span></center>");
                        hSB = $(".ui_form > .long-table-wrapper .long-table-scroll").hasScrollBar();
                        if (hSB) {
                            if ($("#savenew").length) {
                                $(".long-table-scroll").scrollTop($(".long-table-scroll")[0].scrollHeight)
                            } else {
                                $(".container-resizeable-head:last").scrollIntoView({
                                    duration: 200,
                                    direction: "vertical",
                                    complete: function() {}
                                })
                            }
                        }
                        $("body").on("keydown", ".container-resizeable-table input, .container-resizeable-table textarea", function() {
                            $("button.btn-success").removeClass("btn-success").addClass("btn-warning").attr("data-form-onbeforeunload", "1").attr("data-form-onbeforeunload-tabledata", "1")
                        })
                    }, 10);
                    $(t___wi).resize(function() {
                        var t = 0,
                            r = 0,
                            s = 0,
                            u = 0,
                            q = 0;
                        setTimeout(function() {
                            if (navigator.userAgent.toLowerCase().indexOf("firefox") > -1) {
                                q = 25;
                                u = 18
                            } else {
                                q = 19;
                                u = 5
                            }
                            s = $(".ui_form > .long-table-wrapper .long-table-scroll").hasScrollBar();
                            t = parseInt($(".ui_form > .long-table-wrapper .long-table-scroll").width());
                            r = $(".table.table-striped.table-hover.table-condensed").find("thead th").filter(function(v) {
                                return $(this).position().left + $(this).width() < t
                            }).length + 1
                        }, 2);
                        setTimeout(function() {
                            $("body").find(".container-resizeable-col").attr("colspan", r);
                            $("body").find(".container-resizeable-scroll").width(t - q + 6 + parseInt(s ? 0 : u));
                            $("body").find(".container-resizeable-head").width(t - q + 12 + parseInt(s ? 0 : u))
                        }, 3)
                    });
                    setTimeout(function() {
                        $(t___wi).trigger("resize");
                        $('form[action="view_table.cgi"]').nextAll(":not(script)").remove()
                    }, 11);
                    $("#save, #save-close, #savenew, #savenew-close").click(function(r) {
                        r.preventDefault();
                        var t = $(this),
                            q = t.attr("id"),
                            s = (q == "save-close" ? "save" : (q == "savenew-close" ? "savenew" : q));
                        if (q == "save" || q == "savenew") {
                            $("button").find(".fa.fa-floppy-o").replaceWith(n)
                        } else {
                            if (q == "save-close" || q == "savenew-close") {
                                $("button").find(".fa.fa-check-circle-o").replaceWith(l)
                            }
                        }
                        setTimeout(function() {
                            $.ajax({
                                type: "POST",
                                url: ($current_page_full + "?xhr&" + s + "=1&stripped=1"),
                                data: t.parents("form").serialize(),
                                dataType: "text",
                                success: function(u) {
                                    $("button").find(".cspinner_container").replaceWith((q == "save" || q == "savenew") ? h : g);
                                    if (!$(u).find(".ui_form").length) {
                                        messenger('<i class="fa fa-fw fa-exclamation-triangle"></i>&nbsp;&nbsp;&nbsp;' + $(u).find(".panel-body h3").find("tt:last-child").html(), 10, "error")
                                    } else {
                                        $("button.btn-warning").removeClass("btn-warning").addClass("btn-success").attr("data-form-onbeforeunload", 0);
                                        if (q == "save" || q == "save-close") {
                                            var w = ($(".container-resizeable-head").length > 1 ? "theme_xhred_database_edit_rows_successful" : "theme_xhred_database_edit_row_successful");
                                            messenger('<i class="fa fa-fw fa-check-circle"></i>&nbsp;&nbsp;&nbsp;' + lang(w) + "", 3, "success");
                                            if (q == "save-close") {
                                                $("#cancel").trigger("click")
                                            }
                                        }
                                        if (q == "savenew" || q == "savenew-close") {
                                            messenger('<i class="fa fa-fw fa-check-circle"></i>&nbsp;&nbsp;&nbsp;' + lang("theme_xhred_database_add_row_successful") + "", 3, "success");
                                            if (q == "savenew-close") {
                                                $("#cancel").trigger("click")
                                            }
                                            var v = "";
                                            $.each($("tr.row-no-styling"), function() {
                                                var x = $(this);
                                                v += '<tr class="tr_tag selectable opacity-0_5">';
                                                $.each(x.find("table tbody tr:not(.thead) td:last-child"), function() {
                                                    var y = $(this).find('input[type="text"], textarea').val();
                                                    v += "<td>" + (y ? y : "") + "</td>"
                                                });
                                                v += "</tr>"
                                            }).promise().done(function() {
                                                $(".long-table-wrapper > .long-table-scroll > .table.table-striped.table-hover.table-condensed tbody tr.row-no-styling").before(v);
                                                $.each($(".table.table-striped.table-hover.table-condensed").find("thead th, tbody td:last-child"), function(y, x) {
                                                    if ($(this).is("th")) {
                                                        $(this).html("<em>" + $(this).text() + "</em>")
                                                    }
                                                    if ($(this).is(":last-child") && !$(this).parents(".table-hardcoded").length) {
                                                        $(this).css("border-right", "1px solid #eee")
                                                    }
                                                })
                                            })
                                        }
                                    }
                                },
                                error: function(u) {}
                            })
                        }, 100)
                    })
                } else {
                    __init_dt_($(".table.table-striped.table-hover.table-condensed"), false, c);
                    $(".table.table-striped.table-hover.table-condensed").prev(".dataTables_filter").attr("style", "margin-top: -25px !important; margin-right: 1px;");
                    $(".dataTable.no-footer").find("thead th:first-child").addClass("pointer-events-none opacity-0");
                    $.each($(".dataTables_filter"), function() {
                        var r = $(this).parents(".long-table-wrapper"),
                            s = r.find(".table.table-striped.table-hover.table-condensed"),
                            q = -Infinity;
                        s.find("tr").each(function(t, u) {
                            q = Math.max(q, parseFloat(t))
                        });
                        if (q < 10) {
                            s.parents(".dataTables_wrapper").find(".dataTables_filter").remove()
                        } else {
                            $(this).detach().insertBefore(r).css({
                                "float": "right",
                                "margin-top": "-30px"
                            })
                        }
                    }).promise().done(function() {
                        f__mgk_fi()
                    });
                    if ($current_page_full == $_____link_full + "/mysql/edit_dbase.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_dbase.cgi") {
                        $('.table-hardcoded[width="100%"]').nextAll(".select_all, .select_invert").attr("style", "margin-top: 4px !important");
                        $("#delete").addClass("hidden").after('<button class="btn btn-danger" type="submit" name="deleteClone" id="deleteClone" disabled><i class="fa fa-fw fa-trash-o">&nbsp;&nbsp;</i><span>' + lang("theme_xhred_database_object_selected_delete") + "</span></button>");
                        $("#fields").addClass("heighter-34");
                        $(".ui_form_end_submit").parent().find(".ui_form_end_submit:not(:first), .ui_form_end_submit:not(:first) + input").wrapAll('<div class="btn-group end_submits"></div>');
                        $(".btn-group.end_submits .btn").addClass("heighter-34 heighter-34-force")
                    }
                    if ($current_page_full == $_____link_full + "/mysql/edit_table.cgi" || $current_page_full == $_____link_full + "/postgresql/edit_table.cgi") {
                        $("#delete").addClass("hidden").after('<button class="btn btn-warning" type="submit" name="deleteClone" id="deleteClone" data-clone-allowed="1" disabled>' + o + "<span>" + lang("theme_xhred_database_delete_selected_field") + "</span></button>")
                    }
                    $('button#delete, button#deleteClone[data-clone-allowed="1"]').confirmation({}, function() {
                        if ($__source_file != "edit_table.cgi" && $__source_file != "view_table.cgi") {
                            return
                        }
                        var q = $(this);
                        setTimeout(function() {
                            q.addClass("btn-danger");
                            q.find(".fa.fa-trash, .fa.fa-trash-o").replaceWith(n)
                        }, 0);
                        $.ajax({
                            type: "POST",
                            url: ($_____link_full + "/" + $g__m__name + "/" + q.parents("form").attr("action") + "?xhr&" + q.attr("id") + "=1&stripped=1"),
                            data: q.parents("form").serialize(),
                            dataType: "text",
                            success: function(r) {
                                if (!$(r).find(".ui_form").length) {
                                    messenger('<i class="fa fa-fw fa-exclamation-triangle"></i>&nbsp;&nbsp;&nbsp;' + $(r).find(".panel-body h3").html(), 10, "error")
                                } else {
                                    var t = $('.table.table-striped.table-hover.table-condensed tr td:first-child input[type="checkbox"]:checked').parents("tr"),
                                        v = t.length;
                                    $.each(t, function() {
                                        $(".table.table-striped.table-hover.table-condensed").DataTable().row($(this)).remove().draw()
                                    });
                                    var s = ($__source_file == "edit_table.cgi" ? "field" : "row"),
                                        u = (v > 1 ? ("theme_xhred_database_edit_" + s + "s_delete_successful") : ("theme_xhred_database_edit_" + s + "_delete_successful"));
                                    messenger('<i class="fa fa-fw fa-check-circle"></i>&nbsp;&nbsp;&nbsp;' + lang(u).replace("%n", v) + "", 3, "info");
                                    q.prop("disabled", true)
                                }
                                $("button").find(".cspinner_container").replaceWith(o);
                                q.removeClass("btn-danger")
                            },
                            error: function(r) {}
                        })
                    })
                }
            });
            db_check_selected()
        })
    })
};