# PL/SQL trainning

In this repo was created for PL/SQL review of what I have learned during my course. Starting with basics od SQL and moving on to concepts of PL/SQL such as varriables, loops, if statement, SELECT INTO, CURSOR, EXCEPTION, SEQUENCES, TRIGGERS, PROCEDURE, FUNCTION, PACKAGE 
In my training I used Oracle SQLdeveloper.



## Used data

Short description: my database contain data that could be collected while working in library. You can search for details about specific book, it's autor, publishing house, history of borrowing book or readers.

### ERD diagram
![alt text](image.png)

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

### Inserting data

For data we want to insert into our table we can use:
```sql
INSERT INTO name VALUES(a,b,..);
