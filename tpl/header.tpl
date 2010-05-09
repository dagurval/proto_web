<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
[% USE HTML %]
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <head>
	<link rel="stylesheet" type="text/css" href="ext/resources/css/ext-all.css">
	<script type="text/javascript" src="ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="ext/ext-all-debug.js"></script>
	<script type="text/javascript" src="ext/examples/ux/BufferView.js"></script>
        <title>Proto Project List</title>
	<script type="text/javascript">

Ext.onReady(function(){

	var store = new Ext.data.JsonStore({
		url: 'api.pl?getProjects',
		storeId: 'projectStore',
		autoLoad : true,
		root: 'projects',
		idProperty: 'name',
		fields: ['project_name', 'description', 'owner', 'url', 'homepage', 'has_wiki' ],
		listeners : {
			exception : function() {
				Ext.Msg.alert('Error', 'Unable to fetch project list');
			}
		},
		sortInfo : {
			field : 'project_name',
			direction : 'ASC'
		}
	});

    var grid = new Ext.grid.GridPanel({
        renderTo: 'project_list',
        width:900,
        height: 600,
        frame:true,
        title:'Proto Project List',
        trackMouseOver:false,
	autoExpandColumn: 'description',
        store: store,
	stripeRows : true,

        columns: [
		{
			id : 'project_name',
			header : 'Module',
			dataIndex : 'project_name',
			width : 120,
			sortable : true,
			renderer : function(val, meta, r) {
				if (!r.get('url'))
					return val;
				return '<a href="' + r.get('url') + '">' + val + '</a>';
			}
		},
		{
			id : 'description',
			header : 'Description',
			width : 400,
			sortable : true
		},
		{ 
			id : 'owner',
			header : 'Owner',
			width : 100,
			sortable : true
		},
		{
			id : 'extras',
			header : 'Extras',
			width : 100,
			renderer : function(val, meta, record) {
				var html = '';
			
				/*if (record.get('has_wiki')) {
					html += "wiki";
				}*/
				if (record.get('homepage')) {
					if (html) html += " | ";
					html += "<a href=" + record.get('homepage') + ">home</a>";
				}
				return html;

			},
			dataIndex : 'project_name'
		}
	],
        
	    bbar: new Ext.PagingToolbar({
		    store: store,
		    pageSize:500,
		    displayInfo:true
	    }),

	    view: new Ext.ux.grid.BufferView({
		    rowHeight: 40,
		    // render rows as they come into viewable area.
		    scrollDelay: false
	    })
    });

/*
    // render functions
    function renderTopic(value, p, record){
        return String.format(
                '<b><a href="http://extjs.com/forum/showthread.php?t={2}" target="_blank">{0}</a></b><a href="http://extjs.com/forum/forumdisplay.php?f={3}" target="_blank">{1} Forum</a>',
                value, record.data.forumtitle, record.id, record.data.forumid);
    }
    function renderLast(value, p, r){
        return String.format('{0}<br/>by {1}', value.dateFormat('M j, Y, g:i a'), r.data['lastposter']);
    }
*/
});


	</script>

	<style type="text/css">
body, div, h1, h2, h3, h4, h5, h6, p, ul, li, dd, dt {
    font-family: verdana, sans-serif;
    margin: 0;
    padding: 0;
}

h1, h2, h3, h4 {
    font-family: Tahoma;
}

body {
    font-size: 80%;
    padding: 1em 3em;
    background : url('anisbg.png'); 
    background-repeat: repeat-x;
}

a:link {
color: #006FFA;
       text-decoration: none;
  }

a:visited {
color: #006FFA;
       text-decoration: none;
  }

a:hover {
color: #33CFFF;
       text-decoration: none;
  }

a:active {
color: #006FFA;
       text-decoration: none;
  }


	</style>
</head>
