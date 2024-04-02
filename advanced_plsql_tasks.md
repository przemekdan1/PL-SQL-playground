# Advanced PL/SQL tasks

## Program 1


**Napisz program, którego zadaniem jest obliczenie i wypisanie liczby rozpraw dla specjalności pracownika podanej jako parametr kursora. Zaimplementuj obsługę błędów jeśli pracownik nie miał żadnej rozprawy albo ma ich więcej niż 3.**

```sql

```

### What was used:
- parametrized cursor
```sql
CURSOR cursor_name (param_name param_type) IS
    query;

-- OPEN CLOSE
OPEN cursor_name(param_val);
LOOP
    FETCH cursor_name INTO variables;
    EXIT WHEN cursor_name%NOTFOUND;
END LOOP;
CLOSE cursor_name;

--FOR
FOR 
```



## Program 2


**Napisz program (blok anonimowy) wybierający nazwisko i imię pozwanego oraz liczbę jego rozpraw - dotyczy to pozwanego, który miał największą liczbę rozpraw. Wykorzystaj zapytanie w PL/SQL, zmienną rekordową, wprowadź obsługę błędów, jeśli będzie więcej pozwanych o takiej samej największej liczbie rozpraw.**

```sql

```

### What was used:
- record type
```sql
TYPE record_type_name IS RECORD (
    varriable_decaration 
);
v_name record_type_name;


```