## Program 1


**Napisz funkcję, która dla wybranego gatunku ( parametr id) obliczy sumaryczną cenę wszystkich książek tego gatunku.**


```sql
CREATE OR REPLACE FUNCTION laczna_cena_po_gatunku
    (p_gatunek gatunek.id_gat%TYPE DEFAULT null) 
    RETURN NUMBER IS 
    v_laczna_cena_dla_gatunku NUMBER;
    v_nazwa_gatunku gatunek.g_nazwa%TYPE;
BEGIN
    IF p_gatunek IS NULL THEN
        v_laczna_cena_dla_gatunku := 0;
    ELSE
        SELECT gatunek.g_nazwa,SUM(ksiazka.cena) INTO v_nazwa_gatunku, v_laczna_cena_dla_gatunku FROM ksiazka
        JOIN gatunek ON ksiazka.id_gat = gatunek.id_gat
        WHERE gatunek.id_gat = p_gatunek
        GROUP BY gatunek.g_nazwa;
    END IF;
    RETURN v_laczna_cena_dla_gatunku;
END;

-----------------------------------------
SELECT laczna_cena_po_gatunku(3) FROM dual;

```

### What was used:
- parametrized function
- call function



## Program 2


**Zakładamy, że ceny książek w bazie to ceny brutto (z podatkiem), a podatek wynosi 8%. Napisz funkcję, która dla podanego id książki zwróci jej cenę netto. Dodaj obsługę błędów w przypadku braku książki o podanym id oraz w sytuacji kiedy id przypisane jest do więcej niż jednej książki (ma więcej niż jednego autora).**


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
        RAISE_APPLICATION_ERROR(-20001, 'Nie istnieje takie ID książki.');
    WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20002, 'Książka ma wiele autorów.');
END brutto_na_netto;
-------------------------------------
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

### What was used:
- parametrized function
- exceptions


## Program 3


**Napisz procedurę, która zmodyfikuje cenę książki w zależności od ceny bieżącej: cena > =25 --> cena + 10% cena < 25 --> cena +15%**


```sql
CREATE OR REPLACE PROCEDURE aktualizacja_ceny 
    (p_nazwa_ksiazki ksiazka.tytul%TYPE) IS
    v_cena_ksiazki ksiazka.cena%TYPE;
BEGIN 
    IF p_nazwa_ksiazki IS NOT NULL THEN
        SELECT cena INTO v_cena_ksiazki FROM ksiazka
        WHERE tytul = p_nazwa_ksiazki;

        IF v_cena_ksiazki >= 25 THEN
            UPDATE ksiazka SET cena = v_cena_ksiazki * 1.1
            WHERE tytul = p_nazwa_ksiazki;
        ELSE
            UPDATE ksiazka SET cena = v_cena_ksiazki * 1.15
            WHERE tytul = p_nazwa_ksiazki;
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nie ma takiego tytułu');
    END IF;
END aktualizacja_ceny;


BEGIN
    aktualizacja_ceny('PAN TADEUSZ');
END;
```

### What was used:
- parametrized procedure modifying data


## Program 4


**Napisz procedurę, w której zostanie wybrana nazwa wydawnictwa, które wydało najstarszą książkę. Wypisz nazwę wydawnictwa, tytuł książki i nazwisko autora. Wprowadź obsługę błędów, jeśli jest więcej niż jedno takie wydawnictwo.**


```sql
CREATE OR REPLACE PROCEDURE najstarsze_wydawnictwo IS
    v_wydawnictwo wydawnictwo.w_nazwa%TYPE;
    v_tytul ksiazka.tytul%TYPE;
    v_nazwisko_autora autor.nazwisko%TYPE;
BEGIN
    SELECT w_nazwa, tytul, nazwisko
    INTO v_wydawnictwo, v_tytul, v_nazwisko_autora
    FROM ksiazka
    JOIN wydawnictwo ON ksiazka.id_wyd = wydawnictwo.id_wyd
    JOIN autor_tytul ON ksiazka.id_ks = autor_tytul.id_ks
    JOIN autor ON autor.id_aut = autor_tytul.id_aut 
    WHERE data_wyd = (SELECT MIN(data_wyd) FROM ksiazka);

    DBMS_OUTPUT.PUT_LINE(v_wydawnictwo || ' ' || v_tytul || ' ' || v_nazwisko_autora);
END;

DECLARE
BEGIN
    najstarsze_wydawnictwo;
END;

```

### What was used:
- procedure showing data


## Program 5


**Utwórz pakiet (sekcja specyfikacji i ciała) składający się z procedury i funkcji opisanych poniżej: 1. Napisz funkcję sparametryzowaną (parametry: nazwisko i imię autora), która dla podanego nazwiska i imienia autora zwróci liczbę formatów napisanych przez niego książek.2. Napisz procedurę, która wyświetli tytuły książek i nazwiska czytelników, którzy pożyczali książki wydane przez to wydawnictwo, które wydało najmniej książek.**


```sql
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

```

### What was used:
- package, package body
- parametrized function
- parametrized procedure
- cursors


