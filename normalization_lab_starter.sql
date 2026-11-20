/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: ______________________________
   Date: ______________________________

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */

CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;
SHOW Databases;


/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE: The table breaks 1NF because it repeats the pets name in three different tables.
    Pet1_name, pet2_name, pet3_name are involved, this will cause redundancy when they want to add a fourth pet or more.


   Step 2  DESIGN:
   owner: owner_id, owner_name, owner_city
      PK: owner_id

   Pet: pet_id, pet_name, owner_id
     PK: pet_id
     FK: owner_id = owner(owner_id)


*/

/* Step 3  CREATE */

--cretae a table for owners 
CREATE TABLE owner(
   owner_id INT PRIMARY KEY,
   owner_name VARCHAR(50) NOT NULL,
   owner_city VARCHAR(50) NOT NULL
);

--create table for pet to later connect with their owners
CREATE TABLE pet(
   pet_id INT PRIMARY KEY,
   pet_name VARCHAR(50) NOT NULL,
   owner_id INT NOT NULL,
   FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

SHOW TABLES;
/* Step 4  INSERT */
-- inserts owner_id, name, and owner_city into the owner table
INSERT INTO owner(owner_id, owner_name, owner_city) VALUES 
(1,'Maria Lopez','Turlock'),
(2,'James Chen', 'Modesto'),
(3,'Priya Singh','Ceres');

--shows all the insert of the owners
SELECT * FROM owner;

--insert the pets to the pets table
INSERT INTO pet (pet_id, pet_name, owner_id) VALUES
(100, 'Bella', 1),
(101,'Max',1),
(102,'Luna',2),
(103,'Rocky',3),
(104,'Daisy',3),
(105,'Coco',3);

SELECT * FROM pet;

/* Step 5  JOIN */

--joins the owner and pet tables together 
SELECT o.owner_id, o.owner_name, o.owner_city, p.pet_name
FROM owner o 
JOIN pet p ON o.owner_id = p.owner_id; 

/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE: The table breaks 2NF because it has partial dependency.
   building name and building andress repeated and duplicates showing errors on the buildings.



   Step 2  DESIGN:
   building: building_id, building_name, building_address
      PK: building_id

   apartment_unit: building_id, unit_number, bedrooms, monthly_rent
         PK: (building_id,unit_number)
         FK: (building_id = building(building_id)

*/

/* Step 3  CREATE */
--creates the table for building
CREATE TABLE building(
   building_id VARCHAR(10) PRIMARY KEY,
   building_name VARCHAR(50) NOT NULL,
   building_address VARCHAR(100) NOT NULL
);

--create table apartment_unit
CREATE TABLE apartment_unit(
   building_id VARCHAR(10) NOT NULL,
   unit_number VARCHAR(10) NOT NULL,
   bedrooms INT NOT NULL,
   monthly_rent DECIMAL(8,2) NOT NULL,
   PRIMARY KEY (building_id, unit_number),
   FOREIGN KEY (building_id) REFERENCES building(building_id)
);

--shows the tables created
SHOW TABLES;

/* Step 4  INSERT */
--inserts the building id, building name and building address
INSERT INTO building(building_id, building_name,building_address) VALUES
('B1','Oak Terrance','100 Oak St'),
('B2','Canal Court','45 Canal Dr');

--shows the interts created in the building table
SELECT * FROM building;

--inserts apartment details into the apartment_unit 
INSERT INTO apartment_unit( building_id, unit_number, bedrooms, monthly_rent)VALUES 
('B1', '101', 1, 1250.00),
('B1', '102', 2, 1600.00),
('B2', '101', 2, 1550.00),
('B2', '102', 3, 1900.00);

--shows the inserts created in the apartment_unit
SELECT * FROM apartment_unit;
/* Step 5  JOIN */
--joins the building table and the aprtment_unit
SELECT u.building_id, u.unit_number, b.building_name, b.building_address, u.bedrooms, u.monthly_rent
FROM apartment_unit u 
JOIN building b ON u.building_id = b.building_id;

/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE: The table break the 3NF because it has a transitive dependency on em_id, dept_id, dept_name, dept_phone.
   it would require changing two rows:Linda Park and Carlos Vega.
   


   Step 2  DESIGN:

department: dept_id, dept_name, dept_phone
      PK: dept_id

employee: emp_id, emp_name, hire_year, dept_id
      PK:emp_id
      FK: dept_id = department(dept_id)

*/

/* Step 3  CREATE */

--creates table department
CREATE TABLE department(
   dept_id    VARCHAR(10) PRIMARY KEY,
   dept_name  VARCHAR(50) NOT NULL,
   dept_phone VARCHAR(20) NOT NULL
);

--creates table for employees
CREATE TABLE employee(
   emp_id VARCHAR(10) PRIMARY KEY,
   emp_name VARCHAR(50) NOT NULL,
   hire_year INT NOT NULL,
   dept_id VARCHAR(10) NOT NULL,
   FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

/* Step 4  INSERT */
-- inserts into the department table
INSERT INTO department (dept_id, dept_name, dept_phone) VALUES
    ('D10', 'Accounting', '209.555.0300'),
    ('D20', 'Marketing', '209.555.0400');

--insert into the employee table 
INSERT INTO employee (emp_id, emp_name, hire_year, dept_id) VALUES
    ('E01', 'Linda Park', 2019, 'D10'),
    ('E02', 'Raj Mehta', 2021, 'D20'),
    ('E03', 'Carlos Vega', 2022, 'D10'),
    ('E04', 'Emma Wilson', 2024, 'D20');

/* Step 5  JOIN */

--joins both tables: department and employees
SELECT e.emp_id, e.emp_name, e.hire_year, e.dept_id, d.dept_name, d.dept_phone
FROM employee e
JOIN department d ON e.dept_id = d.dept_id;


/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE: The table breaks Second Normal Form (2NF) and Third Normal Form (3NF) because it
   models a many-to-many relationship in a single table with transitive
   dependencies on the composite key (student_id, course_id).
   Student_name and student_major depend only on student_id (partial dependency),
   while course_name, course_description, and units depend only on course_id
   creating partial dependency.


   Step 2  DESIGN:
   student: student_id, student_name, student_major
     PK: student_id

   course: course_id, course_name, course_description, units
      PK: course_id

   enrollment: student_id, course_id, grade
      PK: (student_id, course_id)
      FK: student_id = student(student_id)
      FK: course_id = course(course_id)


*/

/* Step 3  CREATE */

--create the student table
CREATE TABLE student (
    student_id VARCHAR(10) PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    student_major VARCHAR(50) NOT NULL
);

--creates the course table 
CREATE TABLE course (
    course_id VARCHAR(15) PRIMARY KEY,
    course_name VARCHAR(60) NOT NULL,
    course_description VARCHAR(150) NOT NULL,
    units INT NOT NULL
);

--cretaes the enrollment table 
CREATE TABLE enrollment (
    student_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(15) NOT NULL,
    grade VARCHAR(2) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
);

/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */

--inserts into the student table 
INSERT INTO student (student_id, student_name, student_major) VALUES
    ('S100', 'Ana Torres', 'CIS'),
    ('S200', 'Ben Shah', 'Business'),
    ('S300', 'Chloe Nguyen', 'CIS');

--inserts into the course table 
INSERT INTO course (course_id, course_name, course_description, units) VALUES
    ('CIS4720', 'Database Mgmt', 'Relational design and SQL', 3),
    ('CIS2000', 'Intro to Python', 'Programming fundamentals in Python', 3);

--inserts into the enrollment table
INSERT INTO enrollment (student_id, course_id, grade) VALUES
    ('S100', 'CIS4720', 'A'),
    ('S100', 'CIS2000', 'B'),
    ('S200', 'CIS4720', 'B'),
    ('S300', 'CIS2000', 'A');

/* Step 5  JOIN  (three tables: student, enrollment, course) */

--joins the three tables together to be able to make changes and not destroy the structure of the tables
--joins tables: students, course, and enrollment
SELECT s.student_id, s.student_name, s.student_major,
       c.course_id, c.course_name, c.course_description, c.units,
       e.grade
FROM enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN course c ON e.course_id = c.course_id;