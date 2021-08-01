<?php
function redirectHome()
{
    header("Location: home.php");
    exit;
}

function redirectLogin() 
{
    header("Location: login.php");
    exit;
}
?>