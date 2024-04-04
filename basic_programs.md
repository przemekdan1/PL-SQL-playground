# Basic programs PL/SQL

## Program 1


**Napisz program, który dla podanego przez użytkownika n 
obliczy wartość wyrażenia n! = 1 * 2 * 3 * ... * n (silnię).**

```sql
DECLARE
    v_liczba NUMBER := &liczba;
    v_silnia NUMBER :=1;
BEGIN
    FOR licznik IN 1..v_liczba 
    LOOP
        v_silnia := v_silnia*licznik;   
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( 'Obliczanie silnii: ' || v_liczba || '! = ' || v_silnia);
END;
```

### What was used:
- user input
- assinging value to varriable
- for loop
```sql
FOR iterator IN 1..range
LOOP
    content
END LOOP;
```

## Program 2


**Zdefiniuj zmienną rekordową student w oparciu o typ rekordowy. Zmienna powinna zawierać pola: id, nazwisko, miasto, telefon. Wyświetl przykładowe dane.**

```sql
DECLARE
    TYPE r_student IS RECORD
    (
        v_id_student NUMBER,
        v_surname VARCHAR2(50),
        v_name  VARCHAR2(50),
        v_city  VARCHAR2(50),
        v_number  VARCHAR2(50)
    );
    student r_student;
BEGIN
    student.v_id_student := 1;
    student.v_surname := 'Smith';
    student.v_name  := 'John';
    student.v_city  := 'Cracow';
    student.v_number  := '512331233';
    DBMS_OUTPUT.PUT_LINE('ID: ' || student.v_id_student || ', Surname: ' || student.v_surname || ', Name: ' || student.v_name || ', City: ' || student.v_city || ', Number: ' || student.v_number);
END;

```

### What was used:
- record_type


## Program 3


**Napisz program, który policzy NWD (największy wspólny dzielnik) dwóch podanych z klawiatury liczb.**

```sql
DECLARE 
    first_num NUMBER := &a;
    second_num NUMBER := &b;
    saved_num NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('NWD(' || first_num || ',' || second_num || ')=');
    LOOP
        saved_num := second_num;
        second_num := MOD(first_num,second_num);
        first_num := saved_num;
        EXIT WHEN second_num = 0;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(first_num);                                              END;
```

### What was used:
- input from user wuth := &input name
- loop, exit when condition


## Program 4


**Napisz program generujący ciąg n początkowych liczb Fibonacciego.Kolejne elementy ciągu: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89 ...**

```sql
DECLARE
    fib_number NUMBER := &n;
    first_fib NUMBER := 0;
    second_fib NUMBER := 1;
    third_fib NUMBER := 0;
    result VARCHAR(10000) := 'Kolejne elementy ciągu: ' || first_fib || ',' || second_fib || ',';
BEGIN
    IF fib_number <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Niepoprawna wartosc.');
        RETURN;
    END IF;

    FOR licznik IN 1..fib_number LOOP
        third_fib := first_fib + second_fib;
        result := result || third_fib || ',';
        first_fib := second_fib;
        second_fib := third_fib;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(result);
END;

```

### What was used:
- if statement
- for iterator in range(1..n)