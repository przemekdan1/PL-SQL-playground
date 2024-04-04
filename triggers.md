## Program 1


**Utwórz nową tabelę o nazwie AUTOR_LOG, która będzie miała takie same kolumny jak tabela AUTOR, oraz dodatkową kolumnę tekstową o nazwie LOG_OPERATION.Napisz wyzwalacz, który dla operacji INSERT wykonanej na tabeli AUTOR wstawią do tabeli AUTOR_LOG rekord będący kopią danych wstawianych za pomocą polecenia INSERT. W kolumnie LOG_OPERATION ma pojawić się słowo „INSERT”.Napisz wyzwalacz, który dla operacji UPDATE wykonanej na tabeli AUTOR wstawią do tabeli AUTOR_LOG rekord będący kopią danych wstawianych za pomocą polecenia UPDATE. W kolumnie LOG_OPERATION ma pojawić się słowo „UPDATE”.Napisz wyzwalacz, który dla operacji DELETE wykonanej na tabeli AUTOR wstawią do tabeli AUTOR_LOG rekord będący kopią danych wstawianych za pomocą polecenia UPDATE. W kolumnie LOG_OPERATION ma pojawić się słowo „DELETE”.**

```sql
CREATE SEQUENCE id_autor_log_seq
START WITH 1
INCREMENT BY 1
MAXVALUE 999;

CREATE OR REPLACE TRIGGER autor_insert
AFTER INSERT OR UPDATE OR DELETE ON autor
FOR EACH ROW
BEGIN 
    IF INSERTING THEN
        INSERT INTO autor_log (id_rek, id_aut, nazwisko, imie, kraj, log_operation)
        VALUES (id_autor_log_seq.NEXTVAL, :NEW.id_aut, :NEW.nazwisko, :NEW.imie, :NEW.kraj, 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO autor_log (id_rek, id_aut, nazwisko, imie, kraj, log_operation)
        VALUES (id_autor_log_seq.NEXTVAL, :NEW.id_aut, :NEW.nazwisko, :NEW.imie, :NEW.kraj, 'UPDATE');
    ELSIF DELETING THEN
        INSERT INTO autor_log (id_rek, id_aut, nazwisko, imie, kraj, log_operation)
        VALUES (id_autor_log_seq.NEXTVAL, :OLD.id_aut, :OLD.nazwisko, :OLD.imie, :OLD.kraj, 'DELETE');
    END IF;
END;

INSERT INTO autor
VALUES(16,'Remigiusz','Mróz','Polska');

UPDATE autor
SET imie = 'Remigiusz'
WHERE imie = 'Mróz';

UPDATE autor
SET nazwisko = 'Mróz'
WHERE nazwisko = 'Remigiusz';

DELETE FROM autor 
WHERE id_aut = 16;
```

### What was used:
- sequence
- trigger after all operations (insert update delete) for each row
- IF INSERTING, DELETING, UPDATING THEN

## Program 4


**Utwórz nowy wyzwalacz dla tabeli AUTOR, który wygeneruje wyjątek gdy użytkownik będzie próbował wstawić do tabeli rekord z Nazwiskiem „Dorian”.**


```sql
CREATE OR REPLACE TRIGGER blacklist_autor_surname_trig
BEFORE INSERT ON autor
DECLARE 
    blacklist_surname EXCEPTION;
BEGIN
    IF :NEW.nazwisko = 'Dorian' THEN
        RAISE blacklist_surname;
    END IF;
EXCEPTION
    WHEN blacklist_surname THEN
        RAISE_APPLICATION_ERROR(-20000,'Nie można wstawić autora o nazwisku Dorian!');
END;

```

### What was used:
- :NEW usage

## Program 5


**Napisz program zwiększający ceny książek o 5%, zaczynając od książek najtańszych. Zmiany należy przerwać, jeśli cena przekroczy 300 zł.**


```sql
DECLARE 
    CURSOR dane_ksiazek IS
        SELECT * FROM ksiazka
        ORDER BY cena
        FOR UPDATE;
    v_cena ksiazka.cena%TYPE;
BEGIN
    FOR dane_ksiazki IN dane_ksiazek LOOP
        v_cena := dane_ksiazki.cena * 1.05;
        IF v_cena < 300 THEN
            UPDATE ksiazka SET cena = v_cena
            WHERE CURRENT OF dane_ksiazek;
        END IF;
    END LOOP;
END;
```

