\o query_output.txt

-- Query 1
SELECT e.Employee_ID, e.F_Name, e.L_Name FROM employee e INNER JOIN
    (SELECT Employee_ID FROM (routes r INNER JOIN locations l ON r.First_Address = l.Loc_ID) as p1
    INNER JOIN (provisioned d INNER JOIN contracts c ON d.Contract_ID = c.Contract_ID) as p2
    ON p1.Loc_ID = p2.Loc_ID) as o
    ON e.Employee_ID = o.Employee_ID
    GROUP BY e.Employee_ID HAVING count(e.Employee_ID) >= 15;

-- Query 2
SELECT e.Employee_ID, e.F_Name, e.L_Name FROM employee e INNER JOIN
    (SELECT Employee_ID FROM works_for natural join department) as d
    ON d.Employee_ID = e.Employee_ID
    GROUP BY e.Employee_ID HAVING count(e.Employee_ID) >= 15;

-- Query 3
SELECT s.S_ID, s.S_Name FROM supplier s INNER JOIN
    (SELECT S_ID FROM (warehouse w INNER JOIN supplies p ON w.Ware_ID = p.Ware_ID) as p1
    INNER JOIN products d ON d.Product_ID = p1.Product_ID AND d.Product_Name = 'Frozen Pizza') as out
    ON s.S_ID = out.S_ID ORDER BY s.S_ID;

-- Query 4
SELECT c.Client_ID, C.F_Name FROM clients c INNER JOIN
    (SELECT * FROM ((SELECT t.CONTRACT_ID, (DATE_PART('year', t.End_Date) - DATE_PART('year', t.Start_Date)) as Years
    FROM contracts t) as o
    NATURAL JOIN contracts) WHERE o.Years >= 1) as o1
    ON c.Client_ID = o1.Client_ID WHERE o1.Frequency >= 7
    ORDER BY c.Client_ID;

-- Query 5
SELECT e.Employee_ID, e.F_Name, e.L_Name FROM employee e NATURAL JOIN
    (SELECT m.Employee_ID FROM manages m GROUP BY m.Employee_ID HAVING count(m.Employee_ID) >= 2) as o
    ORDER BY e.Employee_ID;

-- Query 6
WITH T AS
    (SELECT Employee_ID FROM employee
    WHERE F_Name = 'John' AND L_Name = 'Doe')
SELECT Employee_ID, F_Name, L_Name FROM (SELECT Employee_ID FROM
    (SELECT First_Address FROM T NATURAL JOIN routes) as o
    NATURAL JOIN routes) as o2 NATURAL JOIN employee;

-- Query 7
SELECT s.s_id, S_Name, Product_Name FROM supplier s FULL OUTER JOIN
    (SELECT s_id, Product_Name FROM (supplies FULL OUTER JOIN
    (SELECT product_id, Purchase_Price, product_name FROM ((SELECT max(Purchase_Price)
    FROM products) as out INNER JOIN products ON out.max = products.Purchase_Price)) as o1
    on supplies.Product_ID = o1.product_ID) WHERE purchase_Price IS NOT NULL) as o2
    ON s.S_ID = o2.S_ID WHERE Product_Name IS NOT NULL;

-- Query 8
WITH T AS
    (SELECT * FROM (SELECT p1.product_id, DATE_PART('day', c.end_date)
    - (DATE_PART('day', CURRENT_DATE)) AS days FROM (products p1 natural join contracts c)) as o
    NATURAL JOIN products p2 WHERE o.days > 0)
SELECT p.product_id, p.product_name, p.sale_price FROM ((SELECT product_id FROM T
    WHERE Sale_Price IN (SELECT MIN(Sale_Price) FROM T WHERE Sale_Price NOT IN
    (SELECT MIN(Sale_Price) FROM T)) GROUP BY product_id) as out NATURAL JOIN products p);

-- Query 9
SELECT e.Employee_ID, e.F_Name, e.L_Name FROM employee e INNER JOIN
    (SELECT Employee_ID FROM creates natural join purchase_order
        natural join supplier) as s
    ON e.Employee_ID = s.Employee_ID
    GROUP BY e.Employee_ID HAVING count(e.Employee_ID) = 15;

-- Query 10
SELECT product_ID, product_name, min(Sale_Price) FROM products NATURAL JOIN
    (SELECT product_ID FROM contains NATURAL JOIN (SELECT * FROM contracts
    NATURAL JOIN (SELECT Client_ID FROM clients
    WHERE F_Name = 'John' AND L_Name = 'Doe') as o) as p) as q
    GROUP BY product_ID, product_name;

\o
