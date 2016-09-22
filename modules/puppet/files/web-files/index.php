<!DOCTYPE html>
<html class="fullscreenbody" lang="en">
    <head>
    	<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Simon Hollingshead &middot; Puppet</title>
        
        <link href="/media/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="/media/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
        <link href="/media/font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link href="/media/simonhollingshead.css" rel="stylesheet">
    </head>
<body class="fullscreenbody"><?php
$domain = explode(".",$_SERVER["HTTP_HOST"]);                                                                          
array_shift($domain);                                                                                                 
$mydomain = implode(".",$domain);
?><div id="homediv" class="runner-text"><a href="http://<?=$mydomain?>/"><i class="fa fa-chevron-left fa-2x"></i><i class="fa fa-home fa-2x"></i></a></div>
<div class="verticalcenter">
	<div class="text-center col-xs-10 col-xs-offset-1">
		<div id="subdomain-leader" class="leader-text"><i class="fa fa-flask fa-2x"></i><br />Puppet</div>
		<hr class="separator"/>
		<div class="runner-text"><a href="about.htm"><i class="fa fa-info-circle"></i><span class="nolink">&nbsp;</span>About</a></div>
		&nbsp;
		<div class="runner-text"><a href="./dependency_graph.pdf"><i class="fa fa-file-image-o"></i><span class="nolink">&nbsp;</span>Dependency Tree</a></div>
		&nbsp;
		<hr class="separator" />
	</div>
</div>
</body>
</html>
