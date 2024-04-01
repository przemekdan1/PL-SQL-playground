/*
Wyświetl imię i nazwisko czytelnika (jedna kolumna – DANE CZYTELNIKA) oraz liczbę gatunków pożyczanych przez niego książek. Wyniki posortuj malejąco.
*/
SELECT czytelnik.imie || ' ' || czytelnik.nazwisko AS "DANE CZYTELNIKA", COUNT(ksiazka.id_gat) AS "LICZBA GATUNKOW"  
FROM czytelnik
JOIN wypozyczenia ON czytelnik.id_czyt = wypozyczenia.id_czyt
JOIN ksiazka ON ksiazka.id_ks = wypozyczenia.id_ks
GROUP BY czytelnik.imie, czytelnik.nazwisko
ORDER BY "LICZBA GATUNKOW" DESC

/*
Wyświetl liczbę książek wydanych przez to wydawnictwo, które wydało najstarszą książkę.
*/
SELECT COUNT(wydawnictwo.w_nazwa) AS "LICZBA WYDANYCH KSIAZEK" FROM wydawnictwo
JOIN ksiazka ON ksiazka.id_wyd=wydawnictwo.id_wyd
WHERE wydawnictwo.id_wyd = (
    SELECT id_wyd FROM ksiazka
    ORDER BY SYSDATE - data_wyd DESC
    FETCH FIRST ROW ONLY
)



/*
Wyświetl format książki, który był najczęściej pożyczany w ciągu ostatnich 3 miesięcy.
*/
SELECT format.f_nazwa,COUNT(ksiazka.tytul) AS "Liczba wypozyczen" FROM ksiazka
JOIN format USING(id_for)
JOIN wypozyczenia USING(id_ks)
WHERE SYSDATE - wypozyczenia.data_wyp < 90
GROUP BY format.f_nazwa
ORDER BY "Liczba wypozyczen"
FETCH FIRST ROW ONLY



/*
Wyświetl liczbę książek każdego rodzaju oraz sumaryczną cenę dla każdej grupy.
*/
SELECT gatunek.g_nazwa, COUNT(ksiazka.tytul), SUM(ksiazka.cena) FROM ksiazka
JOIN gatunek USING(id_gat)
GROUP BY gatunek.g_nazwa



/*
Wyświetl nazwę gatunku, który był częściej pożyczany niż średnia liczba pożyczonych książek wszystkich gatunków.
*/
SELECT gatunek.g_nazwa,COUNT(id_wyp) FROM wypozyczenia
JOIN ksiazka ON ksiazka.id_ks=wypozyczenia.id_ks
JOIN gatunek ON gatunek.id_gat=ksiazka.id_gat
GROUP BY g_nazwa
HAVING COUNT(id_wyp) > (
    SELECT AVG(COUNT(*)) FROM wypozyczenia
    JOIN ksiazka ON ksiazka.id_ks = wypozyczenia.id_ks
    GROUP BY id_gat
)


/*
Wyświetl wszystkie dane o autorze, który napisał książki tego samego typu, co najcieńsza książka.
*/
SELECT * FROM autor
JOIN autor_tytul ON autor.id_aut=autor_tytul.id_aut
JOIN ksiazka ON ksiazka.id_ks=autor_tytul.id_ks
WHERE ksiazka.id_ks IN (
    SELECT id_ks FROM ksiazka
    WHERE id_gat = (
        SELECT id_gat FROM ksiazka
        WHERE l_stron = (
            SELECT l_stron FROM ksiazka
            ORDER BY l_stron ASC
            FETCH FIRST 1 ROWS ONLY
        )
    )
)
