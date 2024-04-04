## Program 1


**Napisz program w trzech wariantach, który pobierze dane wszystkich autorów i umieści je w zmiennej rekordowej. W pierwszym wariancie zadeklaruj zmienną jako rekord typu TYPE … IS RECORD, w drugim wykorzystaj atrybut %ROWTYPE,w trzecim wykorzystaj pętlę FOR.Wyświetl wszystkie dane z rekordu.**

```sql
DECLARE
    TYPE r_autor IS RECORD 
    (
        v_imie VARCHAR(50),
        v_nazwisko VARCHAR(50),
        v_kraj VARCHAR(50)
    );
    autor r_autor;

    CURSOR autorzy IS
    SELECT imie,nazwisko,kraj FROM autor;

BEGIN
    OPEN autorzy;
    LOOP
        FETCH autorzy INTO autor;
        EXIT WHEN autorzy%NOTFOUND;
        dbms_output.put_line(autor.v_imie || ' ' || autor.v_nazwisko || ' ' || autor.v_kraj);
    END LOOP;
    CLOSE autorzy;
END;
--------------------------------
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
---------------------------------------
DECLARE
    CURSOR autorzy IS
    SELECT * FROM autor;

BEGIN
    FOR autor IN autorzy LOOP
        dbms_output.put_line(autor.imie || ' ' || autor.nazwisko || ' ' || autor.kraj);
    END LOOP;
END;
```

### What was used:
- record type
- cursor with: open loop fetch exit close approach
- rowtype with cursor
- cursor with for loop


## Program 2


**Napisz program, który wyświetli imiona nazwiska czytelników oraz miasto w następującej postaci wynik powinien być posortowany według nazwisk w kolejności odwrotnej, wszystkie nazwiska dużymi literami, odstępy w postaci wykropkowanej: Jan  NOWAK Warszawa**
```sql
DECLARE
    TYPE czytelnik_type IS RECORD (
        v_imie VARCHAR2(30),
        v_nazwisko VARCHAR2(30),
        v_miasto VARCHAR2(30)
    );

    czyt czytelnik_type;
BEGIN
    SELECT imie, nazwisko, miasto INTO czyt FROM czytelnik
    WHERE nazwisko = 'SOSNA';

    DBMS_OUTPUT.PUT_LINE(INITCAP(czyt.v_imie) || LPAD(czyt.v_nazwisko, 10, '*') || LPAD(czyt.v_miasto, 10, '*'));
END;
```

### What was used:
- row type
- string formating: initcap,lpad


## Program 3


**Napisz program, który wyświetli imię, nazwisko czytelnika, dzień i miesiąc z daty wypożyczenia (miesiąc w postaci pełnej nazwy miesiąca) oraz tytuł książki i jej format, np.:Jan Nowak 04 DECEMBERpan Tadeusz ebook**


```sql
DECLARE
    CURSOR c_dane IS 
        SELECT c.imie, c.nazwisko, EXTRACT(DAY FROM w.data_wyp) AS dzien, TO_CHAR(data_wyp, 'Month') AS miesiac, k.tytul, f.f_nazwa
        FROM czytelnik c
        NATURAL JOIN wypozyczenia w
        JOIN ksiazka k ON w.id_ks = k.id_ks
        JOIN format f ON k.id_for = f.id_for;
BEGIN
    FOR dane IN c_dane LOOP
        DBMS_OUTPUT.PUT_LINE(dane.imie || ' ' || dane.nazwisko || ' ' || dane.dzien || ' ' || dane.miesiac || ' ' || dane.tytul || ' ' || dane.f_nazwa);
    END LOOP;
END;
```

### What was used:
- cursor with for loop
- string functions: month to_char from date
- extraction part from date, EXTRACT(DAY FROM...)

## Program 4


**Napisz program, który wyświetli dane o wszystkich aktualnie wypożyczonych książkach (tytuł, nazwisko autora, nazwę wydawnictwa, data zwrotu), których cena jest większa lub równa niż cena podana przez użytkownika. Skorzystaj z kursora sparametryzowanego. Korzystając z atrybutu %ROWCOUNT ogranicz liczbę wyników do trzech najdroższych pozycji.**


```sql
DECLARE
    v_cena ksiazka.cena%TYPE := &cena;

    CURSOR aktualne_wypozyczenia
        (p_cena NUMBER) IS
            SELECT *
            FROM ksiazka
            JOIN wypozyczenia USING(id_ks)
            JOIN autor_tytul USING(id_ks)
            JOIN autor USING(id_aut)
            JOIN wydawnictwo USING(id_wyd)
            WHERE wypozyczenia.data_zwr > SYSDATE AND ksiazka.cena >= p_cena;
BEGIN
    FOR wypozyczenie IN aktualne_wypozyczenia(v_cena) 
    LOOP
        EXIT WHEN aktualne_wypozyczenia%NOTFOUND OR aktualne_wypozyczenia%ROWCOUNT > 3;
        DBMS_OUTPUT.PUT_LINE(wypozyczenie.tytul || ' ' || wypozyczenie.nazwisko || ' ' || wypozyczenie.w_nazwa || ' ' || wypozyczenie.data_zwr);
    END LOOP;
END;
```

### What was used:
- parametrized cursor
- %ROWCOUNT and  %NOTFOUND

## Program 5


**Napisz program, który wyświetli liczbę książek konkretnego formatu oraz nazwę formatu. Wykorzystaj polecenie FETCH do pobierania rekordów z kursora. W drugim wariancie skorzystaj z parametru (nazwa formatu) i wyświetl liczbę książek dla podanego formatu.**


```sql
DECLARE
    v_format format.f_nazwa%TYPE;
    v_liczba_wypozyczen NUMBER;
    CURSOR dane_format IS
        SELECT format.f_nazwa,COUNT(*) AS liczba_wypozyczen FROM ksiazka
        JOIN format USING(id_for)
        GROUP BY format.f_nazwa;
BEGIN
    OPEN dane_format;
    LOOP
        FETCH dane_format INTO v_format, v_liczba_wypozyczen;
        EXIT WHEN dane_format%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Liczba wypożyczeń książek w formacie ' || v_format || ': '  || v_liczba_wypozyczen);
    END LOOP;
    CLOSE dane_format;
END;
-------------------------------------------------------------
DECLARE
    v_format format.f_nazwa%TYPE := '&format';
    CURSOR dane_format IS
        SELECT format.f_nazwa,COUNT(*) AS liczba_wypozyczen FROM ksiazka
        JOIN format USING(id_for)
        WHERE format.f_nazwa = v_format
        GROUP BY format.f_nazwa;
BEGIN
    FOR dane IN dane_format LOOP
        DBMS_OUTPUT.PUT_LINE('Liczba wypożyczeń książek w formacie ' || v_format || ': '  || dane.liczba_wypozyczen);
    END LOOP;
END;

```

### What was used:
- iterating through cursor using FETCH
- iterating through cursor using FOR

## Program 6


**Podnieś cenę wszystkich książek wydanych przez wydawnictwa Litera o 10%, a pozostałych wydawnictw o 5%.W pierwszym wariancie programu skorzystaj z klauzuli WHERE CURRENT OF (wskazanie rekordu do zmiany ceny).W wariancie drugim skorzystaj z klauzuli RETURNING INTO (przekazanie zmienionej ceny do zmiennej).**


```sql
DECLARE
    wspolczynnik_ceny NUMBER;
    CURSOR dane_ksiazek IS
        SELECT * FROM ksiazka
        JOIN wydawnictwo USING(id_wyd)
        FOR UPDATE;
BEGIN
    FOR dane_ksiazki IN dane_ksiazek LOOP
        IF dane_ksiazki.w_nazwa = 'Litera' THEN
            wspolczynnik_ceny := 1.05;
        ELSE 
            wspolczynnik_ceny := 1.1;
        END IF;
        UPDATE ksiazka SET ksiazka.cena = ksiazka.cena * wspolczynnik_ceny
        WHERE CURRENT OF dane_ksiazek;
    END LOOP;
END;
---------------------------------------------------------
DECLARE
    wspolczynnik_ceny NUMBER;
    nowa_cena NUMBER;
    CURSOR dane_ksiazek IS
        SELECT * FROM ksiazka
        JOIN wydawnictwo USING(id_wyd)
        FOR UPDATE;
BEGIN
    FOR dane_ksiazki IN dane_ksiazek LOOP
        IF dane_ksiazki.w_nazwa = 'Litera' THEN
            wspolczynnik_ceny := 1.05;
        ELSE 
            wspolczynnik_ceny := 1.1;
        END IF;
        UPDATE ksiazka SET ksiazka.cena = ksiazka.cena * wspolczynnik_ceny
        WHERE dane_ksiazki.id_ks = id_ks
        RETURNING ksiazka.cena INTO nowa_cena;
        DBMS_OUTPUT.PUT_LINE(dane_ksiazki.tytul || ' nowa cena wynosi: ' || nowa_cena);
    END LOOP;
END;

```

### What was used:
- updating data when iterating with cursor
- WHERE CURRENT OF
- RETURNING INTO 




