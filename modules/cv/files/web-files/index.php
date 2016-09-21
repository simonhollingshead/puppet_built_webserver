<!DOCTYPE html>
<html class="fullscreenbody" lang="en">
    <head>
    	<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Simon Hollingshead &middot; CV</title>
        
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
		<div id="subdomain-leader" class="leader-text"><span class="fa-stack fa-1x"><i class="fa fa-file-o fa-stack-2x"></i>
<i class="fa fa-user fa-stack-1x" style="margin-top:40%;margin-left:40%;text-shadow:-2px -2px 0 #f8f8f8,2px -2px 0 #f8f8f8,-2px 2px 0 #f8f8f8,2px 2px 0 #f8f8f8"></i>
<strong class="fa-stack-1x" style="font-size:0.9em; margin-top:9%;margin-left:0%">CV</strong>
</span><br />Curriculum Vitae</div>
		<hr class="separator"/>
<div class="runner-text"><a href="cv_bw.pdf"><i class="fa fa-file-pdf-o"></i><span class="nolink">&nbsp;</span>View CV</a></div>
<div class="mini-text">(last update: <span class="hidden-xs"><?php $filemtime=filemtime("cv_bw.pdf"); echo date('j<\s\up>S</\s\up> \of F, Y',$filemtime); ?></span><span class="visible-xs-inline"><?php echo date('j<\s\up>S</\s\up> M \'y',$filemtime)?></span>)</div>
		<hr class="separator" />
		<div class="runner-text"><a href="./grades.htm"><i class="fa fa-pencil"></i><span class="nolink">&nbsp;</span>Full Examination Results</a></div>
		&nbsp;
		<div class="runner-text"><a href="./recruiters.htm"><i class="fa fa-black-tie"></i><span class="nolink">&nbsp;</span>Information for Recruiters</a></div>
		&nbsp;
		<div class="runner-text"><a href="https://uk.linkedin.com/in/shollingshead" target="_blank"><i class="fa fa-linkedin-square"></i><span class="nolink">&nbsp;</span>LinkedIn</a></div>
		<hr class="separator" />
	</div>
</div>
</body>
</html>
