<?php
session_start();
require_once('utils.php');
require_once('connect.php');

// Sanitizes form fields
function sani($var)
{
    return(htmlspecialchars(strip_tags(trim($var))));
}
if ($_POST['action'])
{
	if ($_POST['action'] == 'Add Stop')
	{
		$Stop_Address = $_POST['Stop_Address'];
		$Stop_Address = sani($Stop_Address);
		settype($Stop_Address, "integer");

		$Stop_Path = $_POST['Stop_Path'];
		$Stop_Path = sani($Stop_Path);
		settype($Stop_Path, "integer");
		//echo"<br><br> SOOOOP PAAAATH";
		//var_dump($Stop_Path);
		
		$Stop_ID = $_POST['Stop_ID'];
		$Stop_ID = sani($Stop_ID);
		settype($Stop_ID, "integer");
	//	echo"<br><br>                 stop id / loc id";
	//	var_dump($Stop_ID);
		
		$Street = $_POST['Street'];
		$Street = sani($Street);
		//echo"<br><br>";
		//var_dump($Street);
		
		$City = $_POST['City'];
		$City = sani($City);
		//echo"<br><br>";
		//var_dump($City);
		
		$State = $_POST['State'];
		$State = sani($State);
		//echo"<br><br>";
		//var_dump($State);
		
		$Zip_Code = $_POST['Zip_Code'];
		$Zip_Code = sani($Zip_Code);
		settype($Zip_Code, "integer");
		//echo"<br><br>";
		//var_dump($Zip_Code);
		
		$Longitude = $_POST['Longitude'];
		$Longitude = sani($Longitude);
		//settype($Longitude, "integer");
		// echo"<br><br>";
		// var_dump($Longitude);
		
		$Latitude = $_POST['Latitude'];
		$Latitude = sani($Latitude);
		//settype($Latitude, "integer");
		// echo"<br><br>";
		// var_dump($Latitude);
		
		$Frequency = $_POST['Frequency'];
		$Frequency = sani($Frequency);
		settype($Frequency, "integer");
		// echo"<br><br>";
		// var_dump($Frequency);
		
		$Client_ID = $_POST['client_full_name'];
		$Client_ID = sani($Client_ID);
		settype($Client_ID, "integer");
		// echo"<br><br>client_ID / client_full_name  ";
		// var_dump($Client_ID);	
		
		
		
		$query = "INSERT INTO locations (street, city_name, state, zip_code, longitude, latitude)			
				VALUES ('$Street', '$City', '$State', '$Zip_Code', '$Longitude', '$Latitude')";			
		$res = pg_query($db, $query);
		
		$query = "INSERT INTO contracts (frequency, start_date, end_date, Client_ID) 
		VALUES ('$Frequency', '02/27/19', '02/27/19', '$Client_ID')";
		$res = pg_query($db, $query);
	
		
		$query = "INSERT INTO stops (stop_path, stop_address) 
				  VALUES ('$Stop_Path', '$Stop_Address')";
		$res = pg_query($db, $query);


	}
		  
  if ($_POST['action'] == 'Insert Route')
	{
		$Path_Name = $_POST['Path_Name'];
		$Path_Name = sani($Path_Name);
		//echo"<br><br>";
		//var_dump($Path_Name);
		
		$employee_name = $_POST['employee_name'];
		$employee_name = sani($employee_name);
		//echo"<br><br>";
		//var_dump($employee_name);
		settype($employee_name, "integer"); 
		//var_dump($employee_name);
		$Employee_ID = $employee_name;
		
		$Vehicle_Num = $_POST['Vehicle_Num'];
		$Vehicle_Num = sani($Vehicle_Num);
		settype($Vehicle_Num, "integer");
		//echo"<br><br>";
		//var_dump($Vehicle_Num);
		
		$query = "INSERT INTO routes (Path_Name, Vehicle_Num, Employee_ID)
					VALUES ('$Path_Name', '$Vehicle_Num', '$Employee_ID')";
					
		$res = pg_query($db, $query);
	}
}
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">   
        <title>Swans</title>

        <link href = "css/bootstrap.css" rel = "stylesheet">
        <link href = "css/style.css" rel = "stylesheet"> 
        <link href="https://fonts.googleapis.com/css?family=Catamaran" rel="stylesheet">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
    </head>
    <body>
    <?php include('nav.php'); ?>

        <!--MAIN CONTENT-->
        <div id="content" class="bg-white position-relative">
            <section class="bg-white padding-bottom-50">
                <div class="container">
				
				
                    <!--Begin form-->
                    <div class="col-12 padding-top-50">
                        <div class="row justify-content-md-center">

						
                                <!--Choose Driver-->
                                <div class="col-6 col-sm-4 margin-bottom-30">
                                    <h2 class="h2-heading-dark margin-bottom-30">Choose a Driver</h2>
                                    <div class="card">
                                        <div class="card-body">
                                            <form action ="change-routes.php" method ="post">
                                                <div class="form-group">
													  <label for="sel1">Select driver</label>
													  <select class="form-control" name="employee_name">
													  <?php // Performing SQL query
												
														$result = pg_query($db, "SELECT * FROM drivers");
														if (!$result) 
														{
															echo "Failed query.\n";
															exit;
														}

														while ($row = pg_fetch_assoc($result))
														{
															//$employee_name = $row['full_name'];
															//$employee_id = $row['Employee_ID'];						
																echo '<option value="'.$row['full_name'].'">'.$row['full_name'].'</option>';
														}
														$employee_name = $_POST['employee_name'];
														?>
													  </select>													
													<div class="text-center">
														<br>
														<input type="submit" class="btn btn-primary" name="action" value="Choose Driver">
													</div>
												</div>
                                            </form>
                                        </div>
                                    </div>
                                </div> <!--End choose driver-->
						</div>
						
						
						<!--Route Table-->
						<div class="col-12 col-sm-12 margin-bottom-30">
							<br>						
							<?php
								// Validate form 
								if (isset($_POST['action']))
								{
									if ($_POST['action'] == 'Choose Driver')
									{
							?>
							<!-- Employees Routes-->
							<p class="lead text-center"><strong><?php echo $employee_name; ?>'s Routes</strong></p>
							<br>
							<table class="table table-hover" id="mydata">
								<thead>
									<tr>
										<th scope="col">Driver</th>
										<th scope="col">Route Name</th>
										<th scope="col">Vehicle</th>
									</tr>
								</thead>
								<tbody>
								<?php														
									// Performing SQL query
									$result = pg_query_params($db, 'SELECT full_name, Path_Name, Vehicle_Num FROM
																	driversRoutes WHERE full_name = $1',
																	array("$employee_name"));

									while ($line = pg_fetch_array($result, null, PGSQL_ASSOC))
									{
										echo "<tr>";

										
										foreach ($line as $col_value)
										{	
											echo "<td>$col_value</td>";
										}
										echo "</tr>";
									}
									pg_free_result($result);

								?>
								</tbody>
							</table>
						</div>
						
							<!-- Add A Route -->
						<div class="form-row">
						<div class="form-group col-sm-4">							
							<form action='change-routes.php' method='POST'>
										
								<label for="Driver">Driver</label>
									<select class="form-control" name="employee_name">
									<?php // Performing SQL query
										$result = pg_query($db, "SELECT full_name, Employee_ID FROM drivers");

										while ($row = pg_fetch_row($result))
										{						
											echo '<option value="'.$row['1'].'">'.$row['0'].'</option>';
											
											$Employee_ID = $_POST['Employee_ID'];
										}
										//$Employee_ID = $_POST['Employee_ID'];
										pg_free_result($result);
									?>
									</select>	
						</div>
								<!-- End Driver -->	
							<div class="form-group col-sm-5">
							  <label for="Route Name">Route Name</label>
							  <input type="text" class="form-control" name="Path_Name" required>
							   <?php // Performing SQL query
									
								?>
							  </div>
							<div class="form-group col-sm-3">			
								<label for="Vehicle">Vehicle</label>
													  <select class="form-control" name="Vehicle_Num">
													  <?php // Performing SQL query
														$result = pg_query($db, "SELECT Vehicle_Num FROM driversRoutes");

														while ($row = pg_fetch_row($result))
														{
															//$employee_name = $row['full_name'];
															//$employee_id = $row['Employee_ID'];						
																//echo '<option value="'.$row['Vehicle_Num'].'">'.$row['Vehicle_Num'].'</option>';
																echo '<option value='.$row['0'].'>'.$row['0'].'</option>';
														}
														$Vehicle_Num = $_POST['Vehicle_Num'];
														?>
													  </select>	
							 <!-- End Driver -->
							</div>	
													
							<div class ="padding-left-50">
							  <button type="submit" class="btn btn-primary" name="action" value="Insert Route">Insert Route</button>
							</div>
							</form> 	
						</div>	
						
						<!-- Edit Route -->
						<div class="row justify-content-md-center">
                            <div class="col-6 col-sm-4 margin-bottom-30">
                                <h2 class="h2-heading-dark margin-bottom-30">Edit a Route</h2>
                                <div class="card">
                                    <div class="card-body">
                                        <form action='change-routes.php' method='POST'>
                                            <div class="form-group">												
											<label for="Route">Route Name</label>
											<select class="form-control" name="Path_Name">
											<?php // Performing SQL query
												$result = pg_query_params($db, 'SELECT full_name, Path_Name, Vehicle_Num FROM
																			driversRoutes WHERE full_name = $1',
																			array("$employee_name"));

												while ($row = pg_fetch_row($result))
												{						
													echo '<option value="'.$row['1'].'">'.$row['1'].'</option>';
													
													$Path_Name = $_POST['Path_Name'];
												}
												pg_free_result($result);
											?>
											</select>												
												<div class="text-center">
													<br>
													<input type="submit" class="btn btn-primary" name="action" value="Edit Route">
												</div>
											</div>
                                        </form>
                                    </div>
                                </div>
                            </div>
						</div>
								<!-- End Driver -->	
						
							
												
					</div> <!-- End Form-->
				</div> <!--End Route Table-->					
								<?php																
									}
									else if ($_POST['action'] == 'Edit Route')
									{		
										$Path_Name = $_POST['Path_Name'];
										$Path_Name = sani($Path_Name);
										?>
										
										<!--Stops/Route Table-->
										<div class="row justify-content-md-center">
										<div class="col-12 col-sm-12 margin-bottom-30">											
											<p class="lead text-center"><strong><?php echo $Path_Name; ?>'s Stops</strong></p>
											<br>
											<table class="table table-hover" id="mydata">
												<thead>
													<tr>
														<th scope="col">Stop</th>
														<th scope="col">Stop Path</th>
														<th scope="col">Street</th>
														<th scope="col">City</th>
														<th scope="col">State</th>
														<th scope="col">Zip Code</th>
														<th scope="col">Long</th>
														<th scope="col">Lat</th>
														<th scope="col">Frequency</th>
														<th scope="col">Client</th>
													</tr>
												</thead>
												<tbody>
												<?php														
													// Performing SQL query

													$result = pg_query_params($db, 'SELECT stop_address, stop_path,
																				street, city_name, state, zip_code, longitude,
																				latitude, frequency, 
																				client_full_name FROM routeMan
																				WHERE path_name = $1',
																					array("$Path_Name"));

													while ($line = pg_fetch_array($result, null, PGSQL_ASSOC))
													{
														echo "<tr>";

														
														foreach ($line as $col_value)
														{	
															echo "<td>$col_value</td>";
														}
														echo "</tr>";
													}
													pg_free_result($result);
													
													?>
												
												</tbody>
											</table>
										</div>
									
									<!-- Add A Stop -->
							<br><br><br><br><br><br>
						<form action='change-routes.php' method='POST'>
						<div class="form-row">
							<div class="form-group col-sm-3">
								  <label for="Stop">Stop</label>
								  <input type="text" class="form-control" name="Stop_Address" required>
							</div>
							<div class="form-group col-sm-3">										
								<label for="Stop_Path">Stop Path</label>
									<select class="form-control" name="Stop_Path">
										<?php // Performing SQL query
											$result = pg_query_params($db, 'SELECT Distinct Path_ID FROM routes
																	WHERE path_name = $1',
																	array("$Path_Name"));
											if (!$result) 
											{
												echo "Failed query.\n";
												exit;
											}
											
											while ($row = pg_fetch_row($result))
											{						
												echo '<option value="'.$row['0'].'">'.$row['0'].'</option>';
												
												$Stop_Path = $_POST['Stop_Path'];
											}
											pg_free_result($result);
										?>
									</select>		
							</div> 
							<div class="form-group col-sm-5">
								  <label for="Street">Street</label>
								  <input type="text" class="form-control" name="Street" value="123 ABC St" required>
							</div>
							<div class="form-group col-sm-4">
								  <label for="City">City</label>
								  <input type="text" class="form-control" name="City" value="Bakersfield" required>
							</div>
							<div class="form-group col-sm-4">
								  <label for="State">State</label>
								  <input type="text" class="form-control" name="State" value="California" required>
							</div>
							<div class="form-group col-sm-2">
								  <label for="Zip Code">Zip Code</label>
								  <input type="text" class="form-control" name="Zip_Code" value="38576" required>
							</div>
							<div class="form-group col-sm-4">
								  <label for="Longitude">Longitude</label>
								  <input type="text" class="form-control" name="Longitude" value="-87.654321" required>
							</div>
							<div class="form-group col-sm-4">
								  <label for="Latitude">Latitude</label>
								  <input type="text" class="form-control" name="Latitude" value="123.45678" required>
							</div>
							<div class="form-group col-sm-2">
								  <label for="Frequency">Frequency</label>
								  <input type="text" class="form-control" name="Frequency" value="7" required>
							</div>
							<div class="form-group col-sm-3">										
								<label for="client">Client</label>
									<select class="form-control" name="client_full_name">
										<?php // Performing SQL query
											$result = pg_query($db, "SELECT client_full_name, Client_ID FROM conInfo");
											if (!$result) 
											{
												echo "Failed query.\n";
												exit;
											}
											
											while ($row = pg_fetch_row($result))
											{						
												echo '<option value="'.$row['1'].'">'.$row['0'].'</option>';
												
												$Client_ID = $_POST['Client_ID'];
											}
											pg_free_result($result);
										?>
									</select>		
							</div> 	
						
							</div>	
							</div>
		</div>							
							<div class ="padding-left-50">
							  <button type="submit" class="btn btn-primary" name="action" value="Add Stop">Add Stop</button>
							</div>
							</form> 
							<BR>
									
										<div class ="padding-left-50">
											<button type="submit" class="btn btn-primary">Create PDF</button>
										</div>
									</form>
							<div class="pagination-container">
								<ul class="pagination">
								</ul> 
							</div>						
					</div> <!-- End Form-->
				</div> <!--End Route Table-->	
									
										
								<?php		
								
									}										
								}
								
								?>
			</section>
		</div>  
		<br><br><br><br><br><br>
        <!--END MAIN CONTENT-->
        <?php include('footer.php'); ?> 
	</body>
</html>