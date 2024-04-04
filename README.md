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
        <li><a href="#record-type">Record type</a></li>
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
          <li><a href="#cursor-atributes">Cursor atributes</a></li>
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


### FETCH

Selecting how many rows from query you want

only first
```sql
FETCH FIRST ROW ONLY
```
three rows
```sql
FETCH FIRST 3 ROW ONLY
```



## PL/SQL basics

### Anonymous blocks

every program that isn't storage in database
```sql
DECLARE
    variables,cursors,record_type
BEGIN
    logic
EXCEPTION
    WHEN ... THEN
END;
```

### TYPE and ROWTYPE
if you want your variable to have exact type as field in the table 

```sql
variable_name table.field_name%TYPE;
```

You can use row type with cursor:
```sql
DECLARE
    r_autor autor%ROWTYPE;
    CURSOR c_autorzy IS
    SELECT * FROM autor;
BEGIN
    OPEN c_autorzy;
    LOOP
        FETCH c_autorzy INTO r_autor;
        EXIT WHEN c_autorzy%NOTFOUND;
        dbms_output.put_line(r_autor.imie || ' ' || r_autor.nazwisko || ' ' || r_autor.kraj);
    END LOOP;
    CLOSE c_autorzy;
END;
``` 

### Record type

Variable that contains many diffrent type values. Fields are separated with comas, at the bottom we have to declare a object witch is this record type object

```sql
TYPE record_type_name IS RECORD (
    variable1 table.field1%TYPE,
    variable2 table.field2%TYPE,
    variable3 NUMBER(5)
);
reference_name record_type_name;
```
Usage:
- fetching data from cursor
- assiging with SELECT INTO


### If statement, case

```sql
    IF condition THEN
        ...
    ELSIF condition THEN
        ...
    ELSE
        ...
    END IF;
```

### Loops

#### LOOP

```sql
    LOOP
        some actions;
        EXIT WHEN condition;
    END LOOP;
```

#### WHILE
```sql
    WHILE condition LOOP
        actions;
    END LOOP;
```
#### FOR
```sql
    FOR i IN  from..to_range LOOP
        actions;
    END LOOP;
```




## PL/SQL modifing and assiging data

### SELECT INTO, INSERT INTO

### UPDATE, DELETE

### RETURNING INTO

It saves values from record i database that have been modify in previous command such as INSERT INTO, UPDATE
Just normal command and then
```sql
RETURNING column_name_from_table INTO variable
``` 
```sql
DECLARE
    v_nazwisko pracownicy.nazwisko%TYPE;

BEGIN
    INSERT INTO pracownicy VALUES (11, 'Zieba', 'Weronika') 
    RETURNING nazwisko INTO v_nazwisko;

    DBMS_OUTPUT.PUT_LINE('Nazwisko nowego pracownika: ' || v_nazwisko);
END;
```

## Cursors

Only way to iterafe through multiple results from sql query when we want them in PL/SQL programme


```sql 
CURSOR cursor_name
    (param_name param_type) IS
    SQL query;
```

```sql
CURSOR nazwiska_ksiazka 
    (p_nazwisko czytelnik.nazwisko%TYPE) IS
        SELECT DISTINCT nazwisko FROM ksiazka
        JOIN wypozyczenia USING(id_ks)
        JOIN czytelnik USING(id_czyt)
        WHERE tytul = 'KORDIAN'
        ORDER BY tytul;
```

### Iterating through cursor

- with loop

Opening cursor -> creating loop -> fetching into varaible -> exit condition -> ending loop -> closing cursor
```sql
    OPEN samochod1;
    LOOP
        FETCH samochod1 INTO sam;
        EXIT WHEN samochod1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(to_char(sam.id_samochodu) || ' ' || sam.marka || ' ' || to_char(sam.cena));
    END LOOP;
    CLOSE samochod1;
```

- with for

much more easierm dont have to worry about closing cursor
```sql
FOR iterator IN cursor
LOOP
    iterator_reference
END LOOP;
```
```sql
    FOR sam IN samochod('Opel') LOOP
        dbms_output.put_line(to_char(samochod%ROWCOUNT)|| '. ' || to_char(sam.id_samochodu) ||' ' || sam.marka || ' ' || to_char(sam.cena));
    END LOOP;
```

### Cursor atributes
Optrions refering to explicit cursors, you can find some informations about current state of cursor such as:
- is current cursor record found **%FOUND** or **%NOTFOUND**
- is cursor open? **%ISOPEN** 
- how many records have been downloaded? 0 before first **%ROWCOUNT**
```sql
LOOP
    EXIT WHEN aktualne_wypozyczenia%NOTFOUND OR aktualne_wypozyczenia%ROWCOUNT > 3;
END LOOP;
```

### WHERE CURRENT OF

It allows you to modify or delete current cursor record. First cursor mus be declared with FOR UPDATE in the end of declaration and then used during UPDATE seletion

```sql
CURSOR cursor_name IS
    SELECT * FROM car FOR UPDATE;
BEGIN
    ...
    UPDATE car SET price = price + 1 WHERE CURRENT OF cursor_name;
END;
```



## Exceptions

Hadling errors with messages or other actions, in some cases user can RAISE his own exceptions declared in declaration block, printing message or raise error. 

```sql
DECLARE
    exception1 EXCEPTION;
BEGIN
    IF sth THEN
        RAISE exception1;
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Nie ma takiej marki posrod samochodow.');
    WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001,'Jest wiecej niz 1 samochod takiej marki.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('To jakis inny wyjatek.');
```


| Nazwa wyjątku       | Opis wyjątku                                                                   |
|---------------------|--------------------------------------------------------------------------------|
| CASE_NOT_FOUND      | nie znaleziono pasującego WHEN dla CASE                                        |
| CURSOR_ALREADY_OPEN | próba otwarcia otwartego kursora                                               |
| DUP_VALUE_ON_INDEX  | powielenie wartości w atrybucie ograniczonym kluczem podstawowym lub unikalnym |
| INVALID_CURSOR      | wykonanie zabronionej operacji na kursorze                                     |
| NO_DATA_FOUND       | polecenie SELECT INTO nie zwróciło żadnego rekordu                             |
| TOO_MANY_ROWS       | polecenie SELECT INTO zwróciło więcej niż 1 rekord                             |
| VALUE_ERROR         | błąd wykonania operacji arytmetycznej, konwersji lub rozmiaru typu             |
| ZERO_DIVIDE         | dzielenie przez zero                                                           |


## Sequences




## Stored procedures

Precompiled programs, which user can invoke at any time or can be invoke when event occur. Sheared with other users.

Always add OR REPLACE for easier refactor.



### Procedures

They do some specific tasks

```sql
CREATE OR REPLACE PROCEDURE procedure_name 
[params] IS
    declarations
BEGIN
    content
END procedure_name
```

Then you have to invoke procedure in diffrent program or anonymous block

```sql
DECLARE
BEGIN
    procedure_name('param');
END;
```
or
```sql
EXECUTE procedure_name('param');
```

Procedure that modifies price of books 

```sql
CREATE OR REPLACE PROCEDURE aktualizacja_ceny 

    (p_nazwa_ksiazki ksiazka.tytul%TYPE) IS

    v_cena_ksiazki ksiazka.cena%TYPE;

BEGIN 

    IF p_nazwa_ksiazki IS NOT NULL THEN

        SELECT cena INTO v_cena_ksiazki FROM ksiazka

        WHERE tytul = p_nazwa_ksiazki;

        WHERE ksiazka.tytul = p_nazwa_ksiazki;

        IF v_cena_ksiazki >= 25 THEN

            UPDATE ksiazka SET cena = v_cena_ksiazki * 1.1

        WHERE ksiazka.tytul = p_nazwa_ksiazki;

        ELSE

            UPDATE ksiazka SET cena = v_cena_ksiazki * 1.15;

        END IF;

    ELSE

        DBMS_OUTPUT.PUT_LINE('Nie ma takiego tutułu');

    END IF;

END aktualizacja_ceny;





DECLARE

BEGIN

    aktualizacja_ceny('PAN TADEUSZ');

END;
```





### Functions

They do some calculation and return values 
```sql
CREATE OR REPLACE FUNCTION function_name
[params type DEFAULT NULL, param2, ...] RETURN return_value_type IS
    declaration
BEGIN
    content
    RETURN sth;
END function_name;
```

```sql
CREATE OR REPLACE FUNCTION brutto_na_netto

(p_id_ksiazki ksiazka.id_ks%TYPE DEFAULT NULL)

    RETURN ksiazka.cena%TYPE IS

    v_cena_netto ksiazka.cena%TYPE;

    v_cena_brutto ksiazka.cena%TYPE;

BEGIN

    SELECT ksiazka.cena INTO v_cena_brutto FROM ksiazka

    WHERE ksiazka.id_ks = p_id_ksiazki;

    

    IF v_cena_brutto IS NOT NULL THEN

        v_cena_netto := v_cena_brutto/1.08;

    END IF;

    RETURN v_cena_netto;

    

    EXCEPTION

    WHEN no_data_found THEN

        RAISE_APPLICATION_ERROR(-20001, 'Nie istnieje takie ID ksiazki.');

    WHEN too_many_rows THEN

        RAISE_APPLICATION_ERROR(-20002, 'Ksiazka ma wiele autorow.');

END brutto_na_netto;
```



To invoke function you have to create proper variable in programe for result  value
```sql
DECLARE

    id_ksiazki ksiazka.id_ks%TYPE := &id_ksiazki;

    v_cena_netto ksiazka.cena%TYPE;

BEGIN

    IF id_ksiazki IS NOT NULL THEN

        v_cena_netto := brutto_na_netto(id_ksiazki);

        DBMS_OUTPUT.PUT_LINE('ID KSIAZKI: ' || id_ksiazki || ' CENA NETTO: ' || v_cena_netto);

    END IF;

END;
```
or, in query
```sql
SELECT laczna_cena_po_gatunku(3) FROM ksiazka
```







### Packages

They are some kind of libraries of procedures and function. Package is devided into specification and body part. 
- In **specification**, we declare functions and procedures used in this package and constants, variables.
- In **body**, whe have definitions of those declared elements. Also it contain cursors, variables inside package, hidden for user

```sql
CREATE OR REPLACE PACKAGE package_name IS
    variables, cursors, exception declarations for users
    procedures, functions declaration for users
END package_name;

CREATE OR REPLACE PACKAGE BODY package_name IS
    variables, cursors, exception declarations for insie programs
    procedures, functions declaration for insie programs
END package_name;
```

How to call function/procedure form package?
```sql
BEGIN
    samochod.sprawdz_samochod(3);
    SELECT samochod.liczba_samochodow('Opel') FROM samochody;
END;
```

```sql
CREATE OR REPLACE PACKAGE sadowe_informacje IS
    FUNCTION rozprawy_sala (p_sala sala.nazwa%TYPE DEFAULT NULL) RETURN NUMBER;
    PROCEDURE informacje_pozwany;
END sadowe_informacje;


CREATE OR REPLACE PACKAGE BODY sadowe_informacje IS
    FUNCTION rozprawy_sala
        (p_sala sala.nazwa%TYPE DEFAULT NULL) 
        RETURN NUMBER IS
        v_liczba_rozpraw NUMBER;
        v_nazwa_sali sala.nazwa%TYPE;
    BEGIN
        IF p_sala IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Brak podanego parametru');
        ELSE
            SELECT nazwa,COUNT(id_rozprawa) INTO v_nazwa_sali, v_liczba_rozpraw FROM sala
            JOIN rozprawa USING(id_sala)
            WHERE nazwa = p_sala
            GROUP BY nazwa;
        END IF;
        RETURN v_liczba_rozpraw;
    END rozprawy_sala;

    PROCEDURE informacje_pozwany IS
        CURSOR informacje IS
            SELECT pozwany.nazwisko,pozwany.imie,pracownicy.imie,typ_sprawy.nazwa FROM rozprawa
            JOIN pozwany USING(id_poz)
            JOIN pracownicy USING(id_prac)
            JOIN typ_sprawy USING(id_typ);
    
        TYPE dane IS RECORD(
            v_nazwisko_poz pozwany.nazwisko%TYPE,
            v_imie_poz pozwany.imie%TYPE,
            v_imie_prac pracownicy.imie%TYPE,
            v_typ_sprawy typ_sprawy.nazwa%TYPE
        );
        dane_pozwanego dane;
    BEGIN
        OPEN informacje;
        LOOP
            FETCH informacje INTO dane_pozwanego;
            EXIT WHEN informacje%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(dane_pozwanego.v_nazwisko_poz || ' ' || dane_pozwanego.v_imie_poz || ' ' ||  dane_pozwanego.v_imie_prac || ' ' || dane_pozwanego.v_typ_sprawy);
        END LOOP;
        CLOSE informacje;
    END informacje_pozwany;
END sadowe_informacje;


DECLARE
    v_liczba_rozpraw NUMBER(4);
    nazwa_sali sala.nazwa%TYPE := '&nazwa_sali';
BEGIN
    v_liczba_rozpraw := sadowe_informacje.rozprawy_sala(nazwa_sali);
    DBMS_OUTPUT.PUT_LINE('Liczba rozpraw, ktora odbyla sie w sali ' || nazwa_sali || ' wynosi: ' || v_liczba_rozpraw);
    
    sadowe_informacje.informacje_pozwany;
END;
```

## Triggers





DECLARE
    CURSOR liczba_rozpraw (p_spec specjalnosc.nazwa%TYPE) IS
        SELECT imie,nazwisko,COUNT(id_rozprawa) AS "LICZBA" FROM pracownicy
        JOIN rozprawa ON pracownicy.id_prac = rozprawa.id_prac
        JOIN specjalnosc ON pracownicy.id_spec = specjalnosc.id_spec
        WHERE nazwa = p_spec
        GROUP BY nazwa;
        
    v_imie pozwany.imie%TYPE;   
    v_nazwisko pozwany.nazwisko%TYPE;
    v_liczba_rozpraw NUMBER;
BEGIN
    FOR spec IN ('ADWOKAT', 'SEDZIA', 'PROKURATOR', 'OBRONCA')
    LOOP
        DBMS_OUTPUT.PUT_LINE('Specjalność: ' || spec);
        OPEN liczba_rozpraw(spec);
        FETCH liczba_rozpraw INTO v_imie, v_nazwisko, v_liczba_rozpraw;
        IF liczba_rozpraw%FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Imię: ' || v_imie || ', Nazwisko: ' || v_nazwisko || ', Liczba rozpraw: ' || v_liczba_rozpraw);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Brak danych dla specjalności: ' || spec);
        END IF;
        CLOSE liczba_rozpraw;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Brak danych dla specjalności: ' || spec);
END;

DECLARE
    v_spec specjalnosc.nazwa%TYPE := '&nazwa';
    CURSOR rozprawy(v_nazwa specjalnosc.nazwa%TYPE) IS 
    SELECT s.nazwa AS nazwa_spec, COUNT(r.id_rozprawa) AS liczba_rozpraw FROM specjalnosc s
    JOIN pracownicy p ON p.id_spec = s.id_spec
    JOIN rozprawa r ON r.id_prac = p.id_prac
    WHERE s.nazwa = 'ADWOKAT'
    GROUP BY s.nazwa;
    za_duzo_rozpraw EXCEPTION;
BEGIN
    FOR i IN rozprawy(v_spec) LOOP
        IF i.liczba_rozpraw > 3 THEN
            RAISE za_duzo_rozpraw;
        END IF;
        DBMS_OUTPUT.PUT_LINE(i.nazwa_spec || ' ' || i.liczba_rozpraw);
    END LOOP;
    
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Pracownik nie mial zadnej rozprawy.');
    WHEN za_duzo_rozpraw THEN
        DBMS_OUTPUT.PUT_LINE('Pracownik mial wiecej niz 3 rozprawy.');
END;



        SELECT nazwisko,id_rozprawa,nazwa FROM pracownicy
        JOIN rozprawa ON pracownicy.id_prac = rozprawa.id_prac
        JOIN specjalnosc ON pracownicy.id_spec = specjalnosc.id_spec
        ORDER BY nazwisko

        SELECT nazwisko,nazwa,COUNT(id_rozprawa) AS "LICZBA" FROM pracownicy
        JOIN rozprawa ON pracownicy.id_prac = rozprawa.id_prac
        JOIN specjalnosc ON pracownicy.id_spec = specjalnosc.id_spec
        GROUP BY nazwisko,nazwa
        
        SELECT nazwisko FROM pracownicy




DECLARE
    TYPE oskarzony IS RECORD (
        v_imie pozwany.imie%TYPE,
        v_nazwisko pozwany.nazwisko%TYPE,
        v_liczba_rozpraw NUMBER
    );
    osk oskarzony;
BEGIN
    SELECT imie,nazwisko,COUNT(id_rozprawa) AS "LICZBA_ROZPRAW" INTO osk FROM pozwany
    JOIN rozprawa USING(id_poz)
    HAVING COUNT(id_rozprawa) = (
            SELECT COUNT(id_rozprawa) FROM pozwany
            JOIN rozprawa USING(id_poz)
            GROUP BY imie,nazwisko
            ORDER BY COUNT(id_rozprawa) DESC
            FETCH FIRST ROW ONLY
        )
    GROUP BY imie,nazwisko;
    
    DBMS_OUTPUT.PUT_LINE(osk.v_imie || ' ' || osk.v_nazwisko || ' ' || osk.v_liczba_rozpraw);
    
EXCEPTION 
    WHEN too_many_rows  THEN
        DBMS_OUTPUT.PUT_LINE('Too many rows');

END;

    SELECT p.nazwisko, p.imie, COUNT(r.id_rozprawa) FROM pozwany p
    JOIN rozprawa r ON r.id_poz = p.id_poz
    HAVING COUNT(r.id_rozprawa) IN (
                                SELECT MAX(COUNT(id_rozprawa)) FROM rozprawa 
                                GROUP BY id_poz
                                )
    GROUP BY p.nazwisko, p.imie




    SELECT imie,nazwisko,COUNT(id_rozprawa) AS "LICZBA_ROZPRAW" FROM pozwany
    JOIN rozprawa USING(id_poz)
    HAVING COUNT(id_rozprawa) = (
            SELECT COUNT(id_rozprawa) FROM pozwany
            JOIN rozprawa USING(id_poz)
            GROUP BY imie,nazwisko
            ORDER BY COUNT(id_rozprawa) DESC
            FETCH FIRST ROW ONLY
        )
    GROUP BY imie,nazwisko

v_nazwisko_poz,v_imie_poz, v_imie_prac, v_typ_sprawy 


CREATE OR REPLACE PACKAGE sadowe_informacje IS
    FUNCTION rozprawy_sala (p_sala sala.nazwa%TYPE DEFAULT NULL) RETURN NUMBER;
    PROCEDURE informacje_pozwany;
END sadowe_informacje;

CREATE OR REPLACE PACKAGE BODY sadowe_informacje IS
    FUNCTION rozprawy_sala
        (p_sala sala.nazwa%TYPE DEFAULT NULL) 
        RETURN NUMBER IS
        v_liczba_rozpraw NUMBER;
        v_nazwa_sali sala.nazwa%TYPE;
    BEGIN
        IF p_sala IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Brak podanego parametru');
        ELSE
            SELECT nazwa,COUNT(id_rozprawa) INTO v_nazwa_sali, v_liczba_rozpraw FROM sala
            JOIN rozprawa USING(id_sala)
            WHERE nazwa = p_sala
            GROUP BY nazwa;
        END IF;
        RETURN v_liczba_rozpraw;
    END rozprawy_sala;

    PROCEDURE informacje_pozwany IS
        CURSOR informacje IS
            SELECT pozwany.nazwisko,pozwany.imie,pracownicy.imie,typ_sprawy.nazwa FROM rozprawa
            JOIN pozwany USING(id_poz)
            JOIN pracownicy USING(id_prac)
            JOIN typ_sprawy USING(id_typ);
    
        TYPE dane IS RECORD(
            v_nazwisko_poz pozwany.nazwisko%TYPE,
            v_imie_poz pozwany.imie%TYPE,
            v_imie_prac pracownicy.imie%TYPE,
            v_typ_sprawy typ_sprawy.nazwa%TYPE
        );
        dane_pozwanego dane;
    BEGIN
        OPEN informacje;
        LOOP
            FETCH informacje INTO dane_pozwanego;
            EXIT WHEN informacje%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(dane_pozwanego.v_nazwisko_poz || ' ' || dane_pozwanego.v_imie_poz || ' ' ||  dane_pozwanego.v_imie_prac || ' ' || dane_pozwanego.v_typ_sprawy);
        END LOOP;
        CLOSE informacje;
    END informacje_pozwany;
END sadowe_informacje;

BEGIN
    sadowa_informacje.rozprawa_sala('F02');
    sadowa_informacje
END;


DECLARE
    v_liczba_rozpraw NUMBER(4);
    nazwa_sali sala.nazwa%TYPE := '&nazwa_sali';
BEGIN
    v_liczba_rozpraw := sadowe_informacje.rozprawy_sala(nazwa_sali);
    DBMS_OUTPUT.PUT_LINE('Liczba rozpraw, ktora odbyla sie w sali ' || nazwa_sali || ' wynosi: ' || v_liczba_rozpraw);
    
    sadowe_informacje.informacje_pozwany;
END;


EXECUTE informacje_pozwany;






CREATE OR REPLACE PACKAGE biblioteka_info IS
    FUNCTION autor_format
        (p_nazwisko autor.nazwisko%TYPE DEFAULT NULL,
        p_imie autor.imie%TYPE DEFAULT NULL)
        RETURN NUMBER;
    PROCEDURE wydawnictwo_info;
END biblioteka_info;

CREATE OR REPLACE PACKAGE BODY biblioteka_info IS

    FUNCTION autor_format
        (p_nazwisko autor.nazwisko%TYPE DEFAULT NULL,
        p_imie autor.imie%TYPE DEFAULT NULL)
        RETURN NUMBER IS
        v_liczba_formatow NUMBER;
    BEGIN
        IF p_nazwisko IS NOT NULL AND p_imie IS NOT NULL THEN
            SELECT DISTINCT COUNT(id_for) INTO v_liczba_formatow FROM autor
            JOIN autor_tytul USING(id_aut)
            JOIN ksiazka USING(id_ks)
            JOIN format USING(id_for)
            WHERE nazwisko = p_nazwisko AND imie = p_imie
            GROUP BY nazwisko,imie;
        END IF;
        RETURN v_liczba_formatow;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,'Nie istnieje taki autor');
    END autor_format;

    PROCEDURE wydawnictwo_info IS
        CURSOR nazwiska_ksiazka 
        (p_tytul ksiazka.tytul%TYPE) IS
            SELECT DISTINCT nazwisko FROM ksiazka
            JOIN wypozyczenia USING(id_ks)
            JOIN czytelnik USING(id_czyt)
            WHERE tytul = p_tytul
            ORDER BY tytul;
            
        CURSOR ksiazki_wydawnictwa IS
            SELECT tytul FROM wydawnictwo
            JOIN ksiazka USING(id_wyd)
            WHERE w_nazwa = (
                SELECT w_nazwa FROM wydawnictwo
                JOIN ksiazka USING(id_wyd)      
                GROUP BY w_nazwa
                ORDER BY COUNT(id_ks)
                FETCH FIRST ROW ONLY
                );
    BEGIN
        FOR tytul_ksiazki IN ksiazki_wydawnictwa 
        LOOP
            DBMS_OUTPUT.PUT_LINE(tytul_ksiazki.tytul);
            FOR nazwiska_wypozyczenia IN nazwiska_ksiazka(tytul_ksiazki.tytul)
            LOOP
                DBMS_OUTPUT.PUT_LINE(nazwiska_wypozyczenia.nazwisko);
            END LOOP;
        END LOOP;
    END wydawnictwo_info;
END biblioteka_info;
    
SELECT biblioteka_info.autor_format('Goethe', 'Anna') FROM dual;
EXECUTE biblioteka_info.wydawnictwo_info;

BEGIN 
    biblioteka_info.autor_format('Goethe', 'Anna');























