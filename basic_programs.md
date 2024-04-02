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

```

### What was used: