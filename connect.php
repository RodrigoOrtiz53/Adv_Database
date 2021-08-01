<?php
$db=pg_connect("host=localhost dbname=rortiz user=rortiz password=schwans");
if(!$db)
{
	echo "connection failed";
}
?>