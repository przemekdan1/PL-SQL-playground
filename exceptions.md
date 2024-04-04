## Program 1


**Napisz program, który wyświetli nazwisko i imię czytelnika, który miał najmniej wypożyczeń.Wprowadź obsługę błędów, jeśli więcej niż jeden czytelnik ma najmniejszą liczbę wypożyczeń.**


```sql
DECLARE
    v_imie czytelnik.imie%TYPE;
    v_nazwisko czytelnik.nazwisko%TYPE;
BEGIN
    SELECT czytelnik.imie,czytelnik.nazwisko INTO v_imie,v_nazwisko FROM czytelnik
    JOIN wypozyczenia USING(id_czyt)
    GROUP BY czytelnik.imie,czytelnik.nazwisko
    HAVING COUNT(id_wyp) = (
        SELECT MIN(wyp) FROM (
        SELECT COUNT(id_wyp) AS wyp FROM wypozyczenia 
        GROUP BY id_czyt)
    );
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Jest wiecej niz jeden czytelnik.');
END;

```

### What was used:
-


## Program 2


**Napisz program, który wybierze nazwę gatunku najdroższej książki. Wypisz nazwę gatunku, tytuł książki i cenę. Wprowadź obsługę błędów, jeśli więcej niż jedna książka ma najwyższą cenę.**


```sql
DECLARE
    v_gatunek gatunek.g_nazwa%TYPE;
    v_tytul ksiazka.tytul%TYPE;
    v_cena ksiazka.cena%TYPE;
BEGIN
    SELECT gatunek.g_nazwa, ksiazka.tytul, ksiazka.cena INTO v_gatunek, v_tytul, v_cena FROM ksiazka
    JOIN gatunek USING (id_gat)
    ORDER BY ksiazka.cena DESC
    FETCH FIRST 1 ROW ONLY;
    DBMS_OUTPUT.PUT_LINE(v_gatunek || ' ' || v_tytul || ' ' || v_cena);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Jest wiecej niz jedna ksiazka w najwyzszej cenie');
END;

```

### What was used:
- TOO_MANY_ROWS
- FETCH FIRST 1 ROW ONLY


## Program 3


**Napisz program, który wyświetli imię, nazwisko czytelnika, dzień i miesiąc z daty wypożyczenia (miesiąc w postaci pełnej nazwy miesiąca) oraz tytuł książki i jej format, np.:Jan Nowak 04 DECEMBERpan Tadeusz ebook**


```sql

```

### What was used:
-


## Program 3


**Napisz program, który wyświetli imię, nazwisko czytelnika, dzień i miesiąc z daty wypożyczenia (miesiąc w postaci pełnej nazwy miesiąca) oraz tytuł książki i jej format, np.:Jan Nowak 04 DECEMBERpan Tadeusz ebook**


```sql

```

### What was used:
-


