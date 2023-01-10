-- Second Class on ORDBMS

CREATE OR REPLACE TYPE Department_T AS OBJECT (
    dept_name varchar2(20),
    dept_phone varchar2(20),
    dept_room NUMBER
)
/

CREATE OR REPLACE TYPE Course_T AS OBJECT (
    course_id varchar2(6),
    title varchar2(20),
    course_dept Department_T,
    credits number
)
/

-- creating a table solely based on Type

CREATE TABLE Department OF Department_T (
    primary key (dept_name),
    dept_room NOT NULL
)
/

CREATE TABLE Course of Course_T (
    primary key (course_id),
    CHECK (credits >= 3 AND credits <= 4)
)
/

DESC Course

DESC Department

INSERT INTO Department VALUES ('CSE','018',640);
INSERT INTO Department VALUES ('EEE','018',640);

INSERT INTO Course VALUES ('CSE464','Advanced DB', new Department_T('CSE', '019', 540), 3);

SELECT C.course_id, C.title, C.course_dept.dept_name, C.credits
FROM Course C;

-- Association Relationship
-- Course (Many) ----- Department (One)
-- Implementation of Association using REF keyword


CREATE OR REPLACE TYPE Course1_T AS OBJECT (
    course_id varchar2(6),
    title varchar2(20),
    course_dept REF Department_T,
    credits number
)
/

CREATE TABLE Course1 OF Course1_T (
    primary key (course_id),
    CHECK (credits >= 3 AND credits <= 4)
)
/

INSERT INTO Course1 VALUES ('CSE464','Advanced DB', 
                            (SELECT REF(d) FROM Department d WHERE d.dept_name = 'CSE'), 3);


SELECT C.course_id, C.title, C.credits, C.course_dept.dept_name FROM Course1 C;

-- Inheritance
--       Employee
--        /    \
--       /      \
--    Manager   Worker

CREATE OR REPLACE TYPE Employee_T AS OBJECT (
    empId varchar2(20),
    empName varchar2(20),
    empAddress varchar2(20),
    empSalary NUMBER
) NOT FINAL
/

CREATE OR REPLACE TYPE Manager_T UNDER Employee_T (
    annual_salary NUMBER
)
/

CREATE OR REPLACE TYPE Worker_T UNDER Employee_T (
    weekly_wage NUMBER
)
/

CREATE TABLE Employee OF Employee_T (
    primary key (empId),
    CHECK (empSalary >= 15000)
)
/

CREATE TABLE Manager OF Manager_T (
    primary key (empId),
    foreign key (empId) REFERENCES Employee
)
/

CREATE TABLE Worker OF Worker_T (
    primary key (empId),
    foreign key (empId) REFERENCES Employee
)
/

INSERT INTO Employee VALUES ('E-1','Alice','DHK',45000);

SELECT * FROM Employee;

INSERT INTO Manager VALUES ('E-1','Alice','DHK',45000, 1450000);

INSERT INTO Manager VALUES ('E-2','Bob','DHK',45000, 1450000);
--it wont work as E-2 is not listed in employee table. 


SELECT * FROM Manager;
---eto tukue

-- Aggregation 
-- part - whole
-- First create type for each part

CREATE OR REPLACE TYPE Computer_T AS OBJECT (
    id varchar2(20),
    description varchar2(20)
)
/

CREATE OR REPLACE TYPE Printer_T AS OBJECT (
    id varchar2(20),
    description varchar2(20)
)
/
CREATE OR REPLACE TYPE Scanner_T AS OBJECT (
    id varchar2(20),
    description varchar2(20)
)
/

CREATE OR REPLACE TYPE Computer_Tab IS TABLE OF Computer_T
/
CREATE OR REPLACE TYPE Printer_Tab IS TABLE OF Printer_T
/
CREATE OR REPLACE TYPE Scanner_Tab IS TABLE OF Scanner_T
/

CREATE TABLE LAB (
    lab_id varchar2(20),
    location NUMBER,
    computers Computer_Tab,
    printers Printer_Tab,
    scanners Scanner_Tab,
    primary key (lab_id)
)
NESTED TABLE computers STORE AS lab_computers_table, 
NESTED TABLE printers STORE AS lab_printers_table,
NESTED TABLE scanners STORE AS lab_scanners_table
/

INSERT INTO LAB values ('Lab-01',630, new Computer_Tab ( new Computer_T ('PC01','HP'), new Computer_T ('PC02','Dell')),
                                      new Printer_Tab (new Printer_T ('P-001','Color'), new Printer_T ('P-002', 'Laser')),
                                      new Scanner_Tab (new Scanner_T ('SC001', 'HP'), new Scanner_T ('SC002', 'HP'))
                       );

DELETE FROM Lab;

SELECT L.lab_id, L.location, C.id, P.id, S.id
FROM Lab L, table(L.computers) C, table(L.printers) P, table (L.scanners) S;

