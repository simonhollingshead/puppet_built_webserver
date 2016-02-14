<?php
require __DIR__ . '/vendor/autoload.php';

use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

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

$ch->basic_publish(new AMQPMessage('Hello World!', array('delivery_mode' => 2)), '', 'domains');

$ch->wait_for_pending_acks_returns();
$ch->close();
$conn->close();

?>
