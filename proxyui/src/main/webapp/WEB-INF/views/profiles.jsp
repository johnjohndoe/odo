<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page session="false" %>
<html>
    <head>
        <%@ include file="/resources/js/webjars.include" %>

        <title>API Profiles</title>
        <script type="text/javascript">

        //makes the specific profile active, goes to the database column
        function makeActive(profile_id){
            $.ajax({
                type: "POST",
                url: '<c:url value="/api/profile/' + profile_id + '/clients/-1"/>',
                data: "active=" + 'true',
                success: function(data) {
                    jQuery("#profilelist").trigger("reloadGrid");
                }
            });
        }

        //for now just opens up a new window. dont know if we will want more in the future
        function editProfile(profile_id){
            window.location = "edit/" + profile_id;
        }

        function navigateConfiguration() {
            window.location ='<c:url value = '/configuration' />';
        }

        var currentProfileId = -1;
        // this just sets the current profile ID so that other formatters can use it
        function idFormatter( cellvalue, options, rowObject ) {
            currentProfileId = cellvalue;
            return cellvalue;
        }

        // formater for the name column
        function nameFormatter( cellvalue, options, rowObject ) {
            var cellContents = '<div class="ui-state-default ui-corner-all" style="float:right" title="Edit Profile" onClick="editProfile(' + currentProfileId + ')">';
            cellContents +=	'<span class="ui-icon ui-icon-carat-1-e"></span></div>';
            cellContents += '<div>' + cellvalue + '</div>';
            return cellContents;
        }

        // formats the active check box
        function activeFormatter( cellvalue, options, rowObject ) {
            var checkedValue = 0;
            if (cellvalue == true) {
                checkedValue = 1;
            }

            var newCellValue = '<input id="active_' + currentProfileId + '" onChange="makeActive(' + currentProfileId + ')" type="checkbox" offval="0" value="' + checkedValue + '"';

            if (checkedValue == 1) {
                newCellValue += 'checked="checked"';
            }

            newCellValue += '>';

            return newCellValue;
        }

        // formatter for the options column
        function optionsFormatter( cellvalue, options, rowObject ) {
            return '<div class="ui-state-default ui-corner-all"><span class="ui-icon ui-icon-folder-open" title="Edit Groups"></span></div>';
        }

        $(document).ready(function () {

            var profileList = jQuery("#profilelist");
            profileList
            .jqGrid({
                url : '<c:url value="/api/profile"/>',
                autowidth : false,
                rowList : [], // disable page size dropdown
                pgbuttons : false, // disable page control like next, back button
                pgtext : null,
                cellEdit : true,
                datatype : "json",
                colNames : [ 'ID', 'Profile Name', 'Name'],
                colModel : [ {
                    name : 'id',
                    index : 'id',
                    width : 55,
                    hidden : true,
                    formatter: idFormatter
                }, {
                    // we have this hidden one so the form Add works properly
                    name : 'name',
                    index : 'name',
                    width : 55,
                    editable: true,
                    hidden : true
                }, {
                    name : 'name',
                    index : 'displayProfileName',
                    width : 400,
                    editable : false,
                    formatter: nameFormatter
                }],
                jsonReader : {
                    page : "page",
                    total : "total",
                    records : "records",
                    root : 'profiles',
                    repeatitems : false
                },
                cellurl : '/testproxy/edit/api/server',
                rowList : [],
                pager : '#profilenavGrid',
                sortname : 'id',
                viewrecords : true,
                sortorder : "desc",
                caption : '<font size="5">Profiles</font>'
            });
            profileList.jqGrid('navGrid', '#profilenavGrid', {
                edit : false,
                add : true,
                del : true
            },
            {},
            {
                jqModal:true,
                url: '<c:url value="/api/profile"/>',
                beforeShowForm: function(form) {
                    $('#tr_name', form).show();
                },
                reloadAfterSubmit: true,
                width: 400
            },
            {
                url: '<c:url value="/api/profile/"/>',
                mtype: 'DELETE',
                reloadAfterSubmit:true,
                onclickSubmit: function(rp_ge, postdata) {
                      rp_ge.url = '<c:url value="/api/profile/"/>' +
                                  $('#profilelist').getCell (postdata, 'id');
                  }
            });
        });

        </script>

    </head>

    <body>

        <div style="width:400px;">
            <div  class="ui-widget-content ui-corner-all" >
                Odo Version: <c:out value = "${version}"/><br>
            </div>
            <table id="profilelist"></table>
            <div id="profilenavGrid"></div>
        </div>
    </body>
</html>