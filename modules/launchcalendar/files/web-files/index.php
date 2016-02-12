<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
	<title>Simon Hollingshead &middot; Launch Calendar</title>
	    <link href="/media/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="/media/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
        <link href="/media/font-awesome/css/font-awesome.min.css" rel="stylesheet">
	<style type="text/css">
html,body{height:100%;width:100%;margin:0px;}
body{display:table;vertical-align:middle;text-align:center;background-color: #f8f8f8;color:#302c22}
.centreme{display:table-cell;vertical-align:middle;}
hr{border-top-color:#e1e1e1}
a:hover .nolink{text-decoration:none;display:inline-block}
	</style>
</head>
<body>
<div class="centreme">
<h1>Launch Calendar</a></h1>
&nbsp;
<h2><a href="about.htm"><i class="fa fa-info-circle"></i><span class="nolink">&nbsp;</span>About/Credits</a></h2>
&nbsp;
<h2><a href="./launchcal.ics"><i class="fa fa-download"></i><span class="nolink">&nbsp;</span>Download</a></h2>
&nbsp;
<h2><a href="https://calendar.google.com/calendar/render?cid=http://<?=$_SERVER['HTTP_HOST']; ?>/launchcal.ics" target="_blank"><i class="fa fa-calendar-plus-o"></i><span class="nolink">&nbsp;</span>Subscribe in Google Calendar</a></h2>
&nbsp;
<h4>Latest run: <?php
$date = explode('+',file('launchcal.ics')[1])[1];
echo substr($date, 8, 2).":00 on ".substr($date, 0, 4)."-".substr($date, 4, 2)."-".substr($date, 6, 2);?></h4>
</div>
</body>
</html>
