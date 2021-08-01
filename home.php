<?php
session_start();
require_once('connect.php');
require_once('utils.php');
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">   
        <title>Swans</title>
        
		<link href = "css/bootstrap.css" rel = "stylesheet">
        <link href = "css/style.css" rel = "stylesheet"> 
		<link href = "css/carousel.css" rel = "stylesheet">
		<link href="https://fonts.googleapis.com/css?family=Catamaran" rel="stylesheet">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
   </head>
    <body>

    <?php include('nav.php'); ?>
	
        <!--Container-->
        <main role="main" class="container">
        <div class="col-12" style='text-align: center;'>
        </div>
    </main>

	<!--Carousel-->
        <div id="carousel" class="carousel slide carousel-fade" data-ride="carousel" data-interval="6000">
            <ol class="carousel-indicators">
                <li data-target="#carousel" data-slide-to="0" class="active"></li>
                <li data-target="#carousel" data-slide-to="1"></li>
                <li data-target="#carousel" data-slide-to="2"></li>
            </ol>
            <!-- Carousel 1 -->
            <div class="carousel-inner" role="listbox">
                <div class="carousel-item active">
                    <a href="change-routes.php">
                        <picture>
                        <source srcset="images/mac_cheese_present.png" media="(min-width: 1400px)">
                        <source srcset="images/mac_cheese_present.png" media="(min-width: 769px)">
                        <source srcset="images/mac_cheese_present.png" media="(min-width: 577px)">
                        <img src="images/mac_cheese_present.png" alt="mac_cheese" class="d-block img-fluid">
                        </picture>

                        <div class="carousel-caption">
                            <div>
                                <h2>Comfort Foods</h2>
                                <p>For when you want to relax</p>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Carousel 2 -->
                <div class="carousel-item">
                    <a href="change-routes.php">
                        <picture>
                        <source srcset="images/steak_present.png" media="(min-width: 1400px)">
                        <source srcset="images/steak_present.png" media="(min-width: 769px)">
                        <source srcset="images/steak_present.png" media="(min-width: 577px)">
                        <img src="images/steak_present.png" alt="steak" class="d-block img-fluid">
                        </picture>

                        <div class="carousel-caption justify-content-center align-items-center">
                            <div>
                                <h2>Savory Meats</h2>
                                <p>Delicous enough to eat alone</p>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Carousel 3 -->
                <div class="carousel-item">
                    <a href="change-routes.php">
                        <picture>
                        <source srcset="images/strawberry_present.png" media="(min-width: 1400px)">
                        <source srcset="images/strawberry_present.png" media="(min-width: 769px)">
                        <source srcset="images/strawberry_presen.png" media="(min-width: 577px)">
                        <img src="images/strawberry_present.png" alt="strawberries" class="d-block img-fluid">
                        </picture>

                        <div class="carousel-caption justify-content-center align-items-center">
                            <div>
                                <h2>Fresh Fruits & Veggies</h2>
                                <p>Ripe and ready to eat</p>
                            </div>
                        </div>
                    </a>
                </div>
                <!-- /.carousel-item -->
            </div>
            <!-- /.carousel-inner -->
            <a class="carousel-control-prev" href="#carousel" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#carousel" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>


        <?php include('footer.php'); ?>
		<script src="js/jquery-3.3.1.slim.min.js"></script>
		<script src="js/bootstrap.js"></script>
    </body>
</html>
