\c rortiz;

CREATE TABLE IF NOT EXISTS address (
	Address_ID integer primary key not null,
	Street varchar(50) default 'Old River Road',
	City_Name varchar(75) default 'Bakersfield',
	State char(50) default 'California',
	Zip_Code integer not null
);



CREATE SEQUENCE IF NOT EXISTS LocInc START 96;

CREATE TABLE IF NOT EXISTS locations (
	Loc_ID integer primary key not null DEFAULT nextval('LocInc'),
	Street varchar(50) default 'Old River Road',
	City_Name varchar(75) default 'Bakersfield',
	State varchar(50) default 'California',
	Zip_Code integer default 93311,
	Longitude numeric not null,
	Latitude numeric not null
);

CREATE TABLE IF NOT EXISTS employee (
	Employee_ID integer primary key not null,
	F_Name varchar(50) default 'John',
	M_Init varchar(1) default 'R',
	L_Name varchar(50) default 'Doe',
	Address_ID integer not null,
	Phone float not null,
	DOB Date not null,
	Salary int not null,
	SSN varchar(11) UNIQUE,
	CONSTRAINT fk_employee_address FOREIGN KEY (Address_ID) REFERENCES address(Address_ID)
);

CREATE TABLE IF NOT EXISTS vehicles (
	Vehicle_ID integer primary key not null
);



CREATE SEQUENCE IF NOT EXISTS pathInc START 16;

CREATE TABLE IF NOT EXISTS routes (
	Path_ID integer primary key not null DEFAULT nextval('pathInc'),
	Path_Name varchar(50) default 'Basic Route',
	Vehicle_Num integer not null,
	Employee_ID integer not null,
	CONSTRAINT fk_routes_vehicle FOREIGN KEY (Vehicle_Num) REFERENCES vehicles(Vehicle_ID),
	CONSTRAINT fk_routes_employee FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID)
);



CREATE SEQUENCE IF NOT EXISTS stopInc START 96;
CREATE SEQUENCE IF NOT EXISTS StopPathInc START 16;

CREATE TABLE IF NOT EXISTS stops (
	Stop_ID integer primary key not null DEFAULT nextval('stopInc'),
    Stop_Path integer not null DEFAULT nextval('StopPathInc'),
    Stop_Address integer not null,
	Next_Stop integer,
	Stop_Activity integer default 0,
    CONSTRAINT fk_stop_route FOREIGN KEY (Stop_Path) REFERENCES routes(Path_ID)
   -- CONSTRAINT fk_stop_current FOREIGN KEY (Stop_Address) REFERENCES locations(Loc_ID)
	--CONSTRAINT fk_stop_next FOREIGN KEY (Next_Stop) REFERENCES locations(Loc_ID)
);

CREATE TABLE IF NOT EXISTS department (
	Department_ID integer primary key not null,
	Name varchar(50) default 'Delivery',
	Description varchar(255) default null,
	Address_ID integer not null,
	CONSTRAINT fk_department_address FOREIGN KEY (Address_ID) REFERENCES address(Address_ID)
);

CREATE TABLE IF NOT EXISTS clients (
	Client_ID integer primary key not null,
	F_Name varchar(50) default 'John',
	M_Init varchar(1) default 'R',
	L_Name varchar(50) default 'Doe',
	Loc_ID integer not null,
	Phone bigint default 6618675309,
	DOB Date not null,
	Credit_Card bigint not null,
	E_Mail varchar(75),
	CONSTRAINT fk_client_address FOREIGN KEY (Loc_ID) REFERENCES locations(Loc_ID)
);

CREATE SEQUENCE IF NOT EXISTS ConLocInc START 96;
CREATE SEQUENCE IF NOT EXISTS contractInc START 196;

CREATE TABLE IF NOT EXISTS contracts (
	Contract_ID integer primary key not null DEFAULT nextval('contractInc'),
	Frequency integer default 7,
	Start_Date Date not null,
	End_Date Date not null,
	Delivery_Time integer default 1000,
	Client_ID integer not null,
	Loc_ID integer not null DEFAULT nextval('ConLocInc'),
	CONSTRAINT fk_contract_client FOREIGN KEY (Client_ID) REFERENCES clients(Client_ID),
	CONSTRAINT fk_contract_location FOREIGN KEY (Loc_ID) REFERENCES locations(Loc_ID),
	CONSTRAINT ck_frequency CHECK(Frequency > -1)
);

CREATE VIEW drivers AS
	SELECT 
	(e.F_Name || ' ' || e.M_Init || '. ' || e.L_Name) as full_name,
	e.Employee_ID
	FROM 
	(
		routes r 
		INNER JOIN
		employee e 
		ON r.Employee_ID = e.Employee_ID
	)
	GROUP BY full_name, e.Employee_ID
;	
	
CREATE VIEW driversRoutes AS
	SELECT 
	e.full_name, e.Employee_ID, r.Path_Name, r.Path_ID, r.Vehicle_Num
	FROM 
	(
		routes r 
		FULL OUTER JOIN
		drivers e 
		ON r.Employee_ID = e.Employee_ID
	)
;	

CREATE VIEW conInfo AS
	SELECT 
	o.*,
	(c.F_Name || ' ' || c.M_Init || '. ' || c.L_Name) as client_full_name
	FROM 
	(
		contracts o
		FULL OUTER JOIN
		clients c
		ON o.Client_ID = c.Client_ID
	)
	ORDER BY o.Delivery_Time
;	


CREATE VIEW routeMan AS
	SELECT 	
	l.Street, l.City_Name, l.State, l.Zip_Code, l.Longitude, l.Latitude, s.Stop_ID, s.Stop_Path, s.Stop_Address, 
	s.Next_Stop, s.Stop_Activity, l.Loc_ID,
	
	r.path_id, r.path_name, r.Employee_ID,
	
	
	con.Frequency, con.Start_Date, con.End_Date, con.Delivery_Time,
	(c.F_Name || ' ' || c.M_Init || '. ' || c.L_Name) as client_full_name

	FROM 
	(
		stops s INNER JOIN locations l ON s.Stop_ID = l.Loc_ID
		INNER JOIN routes r ON r.path_id = s.stop_path		
		INNER JOIN contracts con ON con.Loc_ID = l.Loc_ID
		INNER JOIN clients c ON c.Client_ID = con.Client_ID
		
	)
	ORDER BY s.Stop_Address
;





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE TABLE IF NOT EXISTS products (
	Product_ID integer primary key not null,
	Product_Name varchar(50) default 'Banana',
	Sale_Price numeric,
	Purchase_Price numeric,
	CONSTRAINT ck_price_check CHECK (Sale_Price > Purchase_Price),
	CONSTRAINT ck_sale_price CHECK (Sale_Price > 0),
	CONSTRAINT ck_purch_price CHECK (Purchase_Price > 0)
);

CREATE TABLE IF NOT EXISTS warehouse (
	Ware_ID integer primary key not null,
	Address_ID integer not null,
	CONSTRAINT fk_warehouse_address FOREIGN KEY (Address_ID) REFERENCES address(Address_ID),
	CONSTRAINT ck_ware_address UNIQUE (Address_ID)
);

CREATE TABLE IF NOT EXISTS supplier (
	S_ID integer primary key not null,
	S_Name varchar(75) default 'Walmart'
);

CREATE TABLE IF NOT EXISTS purchase_order (
	Order_ID integer primary key not null,
	Date_Submitted Date not null,
	Date_Fulfilled Date,
	S_ID integer not null,
	CONSTRAINT fk_purch_supp FOREIGN KEY (S_ID) REFERENCES supplier(S_ID),
	CONSTRAINT ck_purch_dates CHECK(Date_Submitted < Date_Fulfilled)
);

CREATE TABLE IF NOT EXISTS works_for (
	Department_ID integer not null,
	Employee_ID integer not null,
	Start_Date Date not null,
	End_Date Date,
	CONSTRAINT pk_works UNIQUE (Department_ID, Employee_ID, Start_Date),
	CONSTRAINT fk_works_employee FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT fk_works_depart FOREIGN KEY (Department_ID) REFERENCES department(Department_ID),
	CONSTRAINT ck_works_dates CHECK(Start_Date < End_Date)
);

CREATE TABLE IF NOT EXISTS works_ware (
	Ware_ID integer not null,
	Employee_ID integer not null,
	Start_Date Date default CURRENT_DATE,
	End_Date Date,
	CONSTRAINT pk_ware_work UNIQUE (Ware_ID, Employee_ID, Start_Date),
	CONSTRAINT fk_ware_employee FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT fk_works_ware FOREIGN KEY (Ware_ID) REFERENCES warehouse(Ware_ID),
	CONSTRAINT ck_ware_dates CHECK(Start_Date < End_Date)
);

CREATE TABLE IF NOT EXISTS manages (
	Department_ID integer not null,
	Employee_ID integer not null,
	Start_Date Date not null,
	End_Date Date,
	CONSTRAINT pk_manages UNIQUE (Employee_ID, Department_ID, Start_Date),
	CONSTRAINT fk_manages_employee FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT fk_manages_depart FOREIGN KEY (Department_ID) REFERENCES department(Department_ID),
	CONSTRAINT ck_manages_dates CHECK(Start_Date < End_Date)
);

CREATE TABLE IF NOT EXISTS supervises (
	Super_Emp_ID integer not null,
	Employee_ID integer not null,
	Start_Date Date not null,
	End_Date Date,
	CONSTRAINT pk_super UNIQUE (Super_Emp_ID, Employee_ID, Start_Date),
	CONSTRAINT fk_super_employee FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT fk_emp_super FOREIGN KEY (Super_Emp_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT ck_super_dates CHECK(Start_Date < End_Date)
);
/*
CREATE TABLE IF NOT EXISTS provisioned (
	Contract_ID integer not null,
	Loc_ID integer not null,
	CONSTRAINT pk_provision UNIQUE (Contract_ID, Loc_ID),
	CONSTRAINT fk_prov_contract FOREIGN KEY (Contract_ID) REFERENCES contracts(Contract_ID),
	CONSTRAINT fk_prov_loc FOREIGN KEY (Loc_ID) REFERENCES locations(Loc_ID)
);
*/
CREATE TABLE IF NOT EXISTS contains (
	Contract_ID integer not null,
	Product_ID integer not null,
	Quantity integer not null,
	CONSTRAINT pk_contains UNIQUE (Contract_ID, Product_ID),
	CONSTRAINT fk_contain_contract FOREIGN KEY (Contract_ID) REFERENCES contracts(Contract_ID),
	CONSTRAINT fk_contain_product FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
	CONSTRAINT ck_quant CHECK (quantity > 0)
);

CREATE TABLE IF NOT EXISTS distributed (
	Vehicle_ID integer not null,
	Product_ID integer not null,
	Ware_ID integer not null,
	Quantity integer,
	Dist_Date Date default CURRENT_DATE,
	CONSTRAINT pk_distribute UNIQUE (Vehicle_ID, Product_ID, Ware_ID),
	CONSTRAINT fk_distribute_ware FOREIGN KEY (Ware_ID) REFERENCES warehouse(Ware_ID),
	CONSTRAINT fk_distribute_vehicle FOREIGN KEY (Vehicle_ID) REFERENCES vehicles(Vehicle_ID),
	CONSTRAINT fk_distribute_product FOREIGN KEY (Product_ID) REFERENCES products(Product_ID)
);

CREATE TABLE IF NOT EXISTS stores (
	Ware_ID integer not null,
	Product_ID integer not null,
	Quantity integer not null,
	CONSTRAINT pk_stores UNIQUE (Ware_ID, Product_ID),
	CONSTRAINT fk_store_ware FOREIGN KEY (Ware_ID) REFERENCES warehouse(Ware_ID),
	CONSTRAINT fk_store_prod FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
	CONSTRAINT ck_prod_quant CHECK(Quantity >= 0)
);

CREATE TABLE IF NOT EXISTS supplies (
	S_ID integer not null,
	Ware_ID integer not null,
	Product_ID integer not null,
	Quantity integer not null,
	CONSTRAINT pk_supplies UNIQUE (S_ID, Ware_ID, Product_ID),
	CONSTRAINT fk_supply_supplier FOREIGN KEY (S_ID) REFERENCES supplier(S_ID),
	CONSTRAINT fk_supply_ware FOREIGN KEY (Ware_ID) REFERENCES warehouse(Ware_ID),
	CONSTRAINT fk_supply_product FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
	CONSTRAINT ck_supply_quantity CHECK(Quantity > 0)
);

CREATE TABLE IF NOT EXISTS creates (
	Employee_ID integer not null,
	Order_ID integer not null,
	CONSTRAINT pk_creates UNIQUE (Employee_ID, Order_ID),
	CONSTRAINT fk_create_emp FOREIGN KEY (Employee_ID) REFERENCES employee(Employee_ID),
	CONSTRAINT fk_create_order FOREIGN KEY (Order_ID) REFERENCES purchase_order(Order_ID)
);
/*
CREATE VIEW activeContracts AS
	SELECT c.Client_ID as id,
	c.F_Name || ' ' || c.M_Init || ' ' || c.L_Name as name,
	o.Contract_ID as contract,
	o.Frequency,
	o.Start_Date,
	l.City_Name || ', ' || l.State || ', ' || l.Zip_Code as location,
	l.Loc_ID
	FROM (clients c INNER JOIN contracts o ON c.Client_ID = o.Client_ID)
	INNER JOIN (locations l INNER JOIN provisioned p ON p.Loc_ID = l.Loc_ID)
	ON o.Contract_ID = p.Contract_ID
	ORDER BY id, contract;
*/
