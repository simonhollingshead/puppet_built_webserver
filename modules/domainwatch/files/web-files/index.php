<?php
require __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

function is_domain($str) {
	return preg_match("|^(http://)?([a-z0-9-.]+)(/.*)?$|", strtolower($str));
}
?>
<!DOCTYPE html>
<html class="fullscreenbody" lang="en">
    <head>
    	<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Simon Hollingshead &middot; Domainwatch</title>
        
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
		<div id="subdomain-leader" class="leader-text"><i class="fa fa-globe fa-2x"></i><br />Domainwatch</div>
		<hr class="separator"/>
<?php if(!isset($_POST["domain"]) || !is_domain($_POST["domain"])) {?>
		<div class="col-xs-6 col-xs-offset-3">
<?php if(isset($_POST["domain"])) { ?>
		<div class="alert alert-danger">The domain was not considered valid.  Please try again.</div>
<?php } ?>
		<form id="domainInput" method="post">
			<div class="container-fluid">
			<div class="col-xs-12 col-sm-10"><input type="text" class="form-control" style="border: 0px solid #000000; border-bottom-width: 1px; background-color: transparent; box-shadow: none; -webkit-box-shadow: none;" placeholder="Enter a domain ." name="domain"<?php if(isset($_POST["domain"])){echo ' value="'.htmlspecialchars($_POST['domain']).'"';}?>/></div>
			<div class="col-xs-6 col-xs-offset-3 col-sm-2 col-sm-offset-0"><button type="submit" class="btn btn-default">Go <i class="fa fa-caret-right"></i></button></div>
			</div>
		</form>
		</div>
<?php } else { 
	$conn = new AMQPStreamConnection("127.0.0.1", "5672", "guest", "guest", "/");
	$ch = $conn->channel();

	$ch->set_ack_handler(
		function (AMQPMessage $message) {
			echo "Message acked with content " . $message->body . PHP_EOL;
		}
	);
	
	$ch->set_nack_handler(
		function (AMQPMessage $message) {
			echo "Message nacked with content " . $message->body . PHP_EOL;
		}
	);

	$ch->confirm_select();
	$ch->queue_declare('domains', false, true, false, false);
	$ch->basic_publish(new AMQPMessage($_POST["domain"], array('delivery_mode' => 2)), '', 'domains');
	$ch->wait_for_pending_acks_returns();
	$ch->close();
	$conn->close();
} ?>
	</div>
</body>
</script>
</html>
