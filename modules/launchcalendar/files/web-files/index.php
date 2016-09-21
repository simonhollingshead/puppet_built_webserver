<!DOCTYPE html>
<html class="fullscreenbody" lang="en">
    <head>
    	<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Simon Hollingshead &middot; Launch Calendar</title>
        
        <link href="/media/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="/media/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
        <link href="/media/font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link href="/media/simonhollingshead.css" rel="stylesheet">
    </head>
<body class="fullscreenbody"><?php
$domain = explode("\.",$_SERVER["HTTP_HOST"]);                                                                          
array_shift($domain);                                                                                                 
$mydomain = implode(".",$domain);
?><div id="homediv" class="runner-text"><a href="http://<?=$mydomain?>/"><i class="fa fa-chevron-left fa-2x"></i><i class="fa fa-home fa-2x"></i></a></div>
<div class="verticalcenter">
	<div class="text-center col-xs-10 col-xs-offset-1">
		<div id="subdomain-leader" class="leader-text"><i class="fa fa-rocket fa-2x"></i><br />Launch Calendar</div>
		<hr class="separator"/>
		<div class="runner-text"><a href="about.htm"><i class="fa fa-info-circle"></i><span class="nolink">&nbsp;</span>About/Credits</a></div>
		&nbsp;
		<div class="runner-text"><a href="./launchcal.ics"><i class="fa fa-download"></i><span class="nolink">&nbsp;</span>Download</a></div>
		&nbsp;
		<div class="runner-text"><a href="https://calendar.google.com/calendar/render?cid=http://<?=$_SERVER['HTTP_HOST']; ?>/launchcal.ics" target="_blank"><i class="fa fa-calendar-plus-o"></i><span class="nolink">&nbsp;</span>Subscribe in Google Calendar</a></div>
		<hr class="separator" />
		<div class="mini-text">Latest run: <?php if(file_exists('launchcal.ics')){
$date = explode('+',file('launchcal.ics')[1])[1];
echo substr($date, 8, 2).":00 on ".substr($date, 0, 4)."-".substr($date, 4, 2)."-".substr($date, 6, 2);
} else {
echo "Not available - please wait an hour.";
}?></div>
	</div>
</div>
</body>
</html>
