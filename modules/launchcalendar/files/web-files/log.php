<?php

header("Content-Type: text/plain", true);

echo file_get_contents("/var/log/launchcalendar/result.log");

?>
