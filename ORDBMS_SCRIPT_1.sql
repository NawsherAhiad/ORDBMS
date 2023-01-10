-- Creating a user-defined data type (similar concept like a Class)

CREATE OR REPLACE TYPE Name as OBJECT (
    firstName varchar2(20),
    middleName varchar2(20),
    lastName varchar2(20)
)
/

DESC name

CREATE OR REPLACE TYPE Address as OBJECT (
    street varchar2(20),
    city varchar2(20),
    zip number
)
/

CREATE TABLE Person (
    id NUMBER,
    name NAME,
    addr ADDRESS,
    annual_income NUMBER,
    dob DATE
)
/

INSERT INTO Person VALUES (1, new Name ('Alice','M.','Smith'), new Address ('Aftabnagar','Rampura',1212),
                           100000, '01-JAN-1998');
                           
INSERT INTO Person VALUES (2, new Name ('Bob','M.','Smith'), new Address ('Kazipara','Mirpur',1216),
                           200000, '02-JAN-1998');
                           
INSERT INTO Person VALUES (3, new Name ('Carol','M.','Smith'), new Address ('Dhanmondi 10','Dhanmondi',1212),
                           145000, '03-JAN-1998');
                           
SELECT * FROM PERSON;

-- Unnesting the tuple

SELECT id, P.name.firstName, P.name.lastName, P.addr.city, annual_income
FROM Person P
WHERE p.annual_income > 150000;

SELECT id, P.name.firstName, P.name.lastName, annual_income
FROM Person P
Where P.addr.city='Mirpur';

-- Creating a Collection Type 

CREATE OR REPLACE TYPE Address_Tab IS TABLE OF ADDRESS;
/

CREATE TABLE Person1 (
    id NUMBER,
    name NAME,
    addr ADDRESS_TAB,
    annual_income NUMBER,
    dob DATE
)
NESTED TABLE addr STORE as Person1_addresses
/

INSERT INTO Person1 VALUES (1001, new Name ('Alice','M.','Smith'), 
                                 new ADDRESS_TAB (
                                      new Address ('Aftabnagar','Rampura',1212),
                                      new Address ('Banasree', 'Rampura', 1213)
                                      ),
                           100000, '01-JAN-1998');
                           
INSERT INTO Person1 VALUES (1002, new Name ('Bob','M.','Smith'), 
                                 new ADDRESS_TAB (
                                      new Address ('Kazipara','Mirpur',1216),
                                      new Address ('Mirpur 10', 'Mirpur', 1216)
                                      ),
                           230000, '02-JAN-1998');

INSERT INTO Person1 VALUES (1003, new Name ('Carol','M.','Smith'), 
                                 new ADDRESS_TAB (
                                      new Address ('Badda','Rampura',1212),
                                      new Address ('Merul', 'Rampura', 1213)
                                      ),
                           50000, '03-JAN-1998');


-- Unnesting 

SELECT P.id, P.name.firstName, Q.street, Q.city, P.annual_income
FROM Person1 P, table(P.addr) Q
WHERE Q.city = 'Rampura';

-- Practice Problem

-- Create type Book that consists of book_title (varchar2) and author_name (NAME TYPE)

-- Create a table Favourite_Books that consists of the following
   -- personName (NAME)
   -- fav_books (Collection Type of Book)
   
-- Insert a few rows

-- Write a query that returns the first name of a person and the book title he/she liked.

CREATE OR REPLACE TYPE Book as OBJECT (
    book_title varchar2(20),
    author_name NAME
)
/

CREATE OR REPLACE TYPE Book_Tab IS TABLE OF Book;
/

CREATE TABLE Favourite_Books (
    personName NAME,
    fav_books BOOK_TAB
)
NESTED TABLE fav_books STORE as Person_Fav_Books
/

INSERT INTO Favourite_Books VALUES (new Name ('Carol','M.','Smith'),
                                    new Book_Tab ( new Book ('Database', new NAME ('Sudarshan', 'M.', 'Smith')),
                                                   new Book ('Java', new NAME ('Deitel', 'M.', 'Smith'))
                                                 )
                                    );
                                    
INSERT INTO Favourite_Books VALUES (new Name ('Alice','M.','Smith'),
                                    new Book_Tab ( new Book ('Harry Potter', new NAME ('Rowling', 'M.', 'Smith')),
                                                   new Book ('LOTR', new NAME ('Someone', 'M.', 'Smith'))
                                                 )
                                    );
                                    
SELECT F.personName.firstName, B.book_title, B.author_name.firstName
FROM Favourite_Books F, table(F.fav_books) B;



