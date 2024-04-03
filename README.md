# PL/SQL trainning

In this repo was created for PL/SQL review of what I have learned during my course. Starting with basics od SQL and moving on to concepts of PL/SQL such as varriables, loops, if statement, SELECT INTO, CURSOR, EXCEPTION, SEQUENCES, TRIGGERS, PROCEDURE, FUNCTION, PACKAGE 
In my training I used Oracle SQLdeveloper.


# Table of Contents
  <ol>
    <li>
      <a href="#used-data">Used Data</a>
      <ul>
        <li><a href="#erd-diagram">ERD diagram</a></li>
      </ul>
    </li>
    <li>
      <a href="#sql-basics">SQL basics</a>
      <ul>
        <li><a href="#creating-table">Creating table</a></li>
        <li><a href="#inserting-data">Inserting data</a></li>
        <li><a href="#naming-columns">Naming columns</a></li>
        <li><a href="#filtering-operators">Filtering operators</a></li>
        <li><a href="#group-by">Group by</a></li>
        <li><a href="#where">Where</a></li>
        <li><a href="#basic_programs.md#program-1">Having</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">PL/SQL basics</a>
      <ul>
        <li><a href="#anonymous-blocks">Anonymous blocks</a></li>
        <li><a href="#type-and-rowtype">TYPE and ROWTYPE</a></li>
        <li><a href="#record-variable">Record variable</a></li>
        <li><a href="#if-statement-case">If statement, case</a></li>
        <li><a href="#loops">Loops</a></li>
    </ul>
    <li><a href="#plsql-modifying-and-assigning-data">PL/SQL modifying and assigning data</a>
        <ul>
          <li><a href="#select-into-insert-into">SELECT INTO, INSERT INTO</a></li>
          <li><a href="#update-delete">UPDATE, DELETE</a></li>
          <li><a href="#returning-into">RETURNING INTO</a></li>
        </ul>
    </li>
    <li>
        <a href="#cursors">Cursors</a>
        <ul>
          <li><a href="#iterating-through-cursor">Iterating through cursor</a></li>
          <li><a href="#where-current-of">WHERE CURRENT OF</a></li>
        </ul>
        <li><a href="#exceptions">Exceptions</a></li>
        <li><a href="#sequences">Sequences</a></li>
        <li><a href="#triggers">Triggers</a></li>
        <li><a href="#stored-procedures">Stored procedures</a></li>
        <ul>
          <li><a href="#procedures">Procedures</a></li>
          <li><a href="#functions">Functions</a></li>
          <li><a href="#packages">Packages</a></li>
        </ul>
    </li>
  </ol>


<!-- ABOUT THE PROJECT -->


## Used data

Short description: my database contain data that could be collected while working in library. You can search for details about specific book, it's autor, publishing house, history of borrowing book or readers.

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### ERD diagram
![alt text](image.png)

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

## SQL basics

### Creating table

First of all we have to create some tables to work on. For that we use
```sql
CREATE TABLE Name (
    field_name TYPE CONSTRAINT,
);
```
Example of creating new table
```sql
CREATE TABLE Books (
    book_id INT PRIMARY KEY, -- Primary Key constraint
    title VARCHAR(100) NOT NULL, -- NOT NULL constraint
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    publication_year INT,
    isbn VARCHAR(13) UNIQUE, -- UNIQUE constraint
    FOREIGN KEY (author) REFERENCES Authors(author_name) -- FOREIGN KEY constraint
    ON DELETE CASCADE, -- Specifies what to do when a referenced row in the parent table is deleted
    price DECIMAL(10, 2) DEFAULT 0, -- DEFAULT constraint
    CHECK (price >= 0) -- CHECK constraint
);

-- Creating an index on the title column for faster data retrieval
CREATE INDEX idx_title ON Books(title);
```
<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### Inserting data

For data we want to insert into our table we can use:
```sql
INSERT INTO name VALUES(a,b,..);
```
<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>


### Naming columns
- aliases and space between words
```sql
SELECT imie || ' ' || nazwisko AS "dane klienta" FROM klienci;
```

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### Filtering operators
- ALL
- BETWEEN
- EXISTS
- **LIKE**
- NULL

Retrieve all books with a number of pages greater than every other book's page count
```sql
SELECT * FROM books
WHERE pages > ALL (SELECT pages FROM books)
AND release_date BETWEEN '2020-01-01' AND '2022-12-31'
AND author_id IS NOT NULL;
```

Retrieve all customers who have made a purchase in the past and whose name starts with 'J'
```sql
SELECT * FROM customers
WHERE EXISTS (SELECT * FROM purchases WHERE purchases.customer_id = customers.customer_id)
AND customer_name LIKE 'J%'
AND NOT customer_name LIKE '%Test%';
```
<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### Group by

**You always have to connect group by with some aggregate functions**

GROUP BY -> COUNT(), SUM(), AVG()

```sql
SELECT nazwa,COUNT(id_rozprawa) FROM pracownicy
JOIN rozprawa ON pracownicy.id_prac = rozprawa.id_prac
JOIN specjalnosc ON pracownicy.id_spec = specjalnosc.id_spec
GROUP BY nazwa
```

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### Where

**You always use it before GROUP BY**

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>

### Having

**You always use it after GROUP BY or aggregation functions**

<p align="right">(<a href="#pl/sql-trainning">back to top</a>)</p>







## PL/SQL basics

### Anonymous blocks

### TYPE and ROWTYPE

### Record variable

### If statement, case

### Loops



## PL/SQL modifing and assiging data

### SELECT INTO, INSERT INTO

### UPDATE, DELETE

### RETURNING INTO



## Cursors

### Iterating through cursor

### WHERE CURRENT OF



## Exceptions


## Sequences



## Triggers


## Stored procedures

### Procedures

### Functions

### Packages



