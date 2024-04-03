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
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Too many rows');

END;
```

### What was used:
- where vs having: **You use where before GROUP BY, You use having after GROUP BY or aggregation functions**
- record type
```sql
TYPE record_type_name IS RECORD (
    varriable_decaration 
);
v_name record_type_name;

DBMS_OUTPUT.PUT_LINE(v_name.varr);
```
- exceptions

```sql
EXCEPTION
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('Nie ma takiej marki posrod samochodow.');
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Jest wiecej niz 1 samochod takiej marki.');
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



## Program 3


**Utwórz pakiet, który zawiera poniższą funkcję i procedurę: Napisz funkcję, która wyświetli liczbę rozpraw, które odbyły się w podanej jako parametr sali. Funkcja powinna zwrócić sumaryczną liczbę rozpraw. - 3 pkt. Napisz procedurę, której zadaniem jest wypisanie dla każdego pozwanego informacji o rozprawach, które go dotyczyły. Są to: nazwisko i imię pozwanego, nazwisko i imię pracownika oraz typ Pamiętaj o wywołaniu programów.**

```sql
CREATE OR REPLACE PROCEDURE informacje_pozwany IS
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
END;


EXECUTE informacje_pozwany;
```

### What was used:
- cursor
- record type
- 