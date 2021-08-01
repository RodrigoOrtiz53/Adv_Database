-- Procedure 1 - Add an employee
CREATE OR REPLACE PROCEDURE addEmployee(
	empID        Integer,
	first        VARCHAR,
	minit        VARCHAR,
	last         VARCHAR,
	addressID    Integer,
	phone        Float,
	dob          Date,
	salary       Integer,
	SSN          VARCHAR,
	depNo        Integer)
LANGUAGE plpgsql
AS $$
BEGIN
	SET Transaction READ WRITE;
		insert into employee values(empID, first, minit, last, addressID,
			phone, dob, salary, SSN);
		insert into works_for values(depNo, empID, CURRENT_DATE, NULL);
EXCEPTION
	WHEN others THEN
	raise 'addEmployee() failed due to %', SQLERRM;
END;
$$;

-- Sample usage, requires a lot of typecasting
-- CALL addEmployee(100, CAST('Billy' as VARCHAR), CAST('B' as VARCHAR), CAST('Joe' as VARCHAR), 30,
--	  CAST(6619894453 as FLOAT), to_date('2/25/1990', 'mm/dd/yyyy'), 250000, CAST('620856130' as VARCHAR), 10);

/*
-- Procedure 2 - Remove a purchase_order (employee filed wrong order)
CREATE OR REPLACE PROCEDURE removePOrder(INT)
LANGUAGE plpgsql
AS $$
BEGIN
	delete from creates where Order_ID = $1;
	delete from purchase_order where Order_ID = $1;
EXCEPTION
	WHEN others THEN
	RAISE 'Deleting purchase order % failed due to %', $1, SQLERRM;
END;
$$;

-- Sample usage, rather straightforward
-- CALL removePOrder(5);

-- Procedure 3 - Average Lowest Salaries
CREATE OR REPLACE FUNCTION lowestAvgSalary(Integer)
RETURNS FLOAT AS $body$
DECLARE
	avgSal FLOAT;
BEGIN
	SELECT AVG(Salary)
	INTO avgSal
	FROM (SELECT * FROM employee ORDER BY Salary DESC) AS lowSalaries
	LIMIT $1;
	RETURN avgSal;
EXCEPTION
	WHEN others THEN
		RAISE 'lowestAvgSalary of % salaries failed due to %', $1, SQLERRM;
END;
$body$ LANGUAGE plpgsql;

*/


-- Sample usage
-- SELECT * FROM lowestAvgSalary(5);

/*
-- Trigger 1
CREATE OR REPLACE FUNCTION update_add()
RETURNS trigger AS
$body$
BEGIN
	UPDATE routes
		SET Next_Address = NEW.Loc_ID
		WHERE Next_Address = OLD.Loc_ID;
	RETURN NEW;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER update_nextAdd
BEFORE UPDATE OF Loc_ID
ON provisioned
FOR EACH ROW
EXECUTE FUNCTION update_add();
*/


-- Sample Usage
-- UPDATE provisioned SET Loc_ID = 7 WHERE Loc_ID = 4;

/*
-- Trigger 2
CREATE OR REPLACE FUNCTION fun_delete_client()
RETURNS trigger
AS $body$
BEGIN
	DELETE FROM provisioned
	WHERE Contract_ID = (SELECT contract_id FROM contracts c
		WHERE c.Client_ID = OLD.Client_ID);
	DELETE FROM contains
	WHERE Contract_ID = (SELECT contract_id FROM contracts c
		WHERE c.Client_ID = OLD.Client_ID);
	DELETE FROM contracts
	WHERE Client_ID = OLD.client_id;
	RETURN OLD;
END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER delete_client
BEFORE DELETE
ON clients
FOR EACH ROW
EXECUTE FUNCTION fun_delete_client();

-- Sample Usage
-- DELETE FROM clients where client_id = 5;

-- Trigger 3 -
CREATE OR REPLACE FUNCTION insert_contract_location()
	RETURNS trigger AS
$func$
BEGIN
	UPDATE provisioned
		SET Loc_ID = NEW.Loc_ID
		WHERE Loc_ID = OLD.Loc_ID;
	RETURN NEW;
END;
$func$ LANGUAGE plpgsql;

CREATE TRIGGER update_location
INSTEAD OF UPDATE on activeContracts
for each row
EXECUTE PROCEDURE insert_contract_location();


-- Sample usage
-- UPDATE activeContracts SET loc_id = 2 WHERE id = 1;
*/