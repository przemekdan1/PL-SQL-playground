SELECT czytelnik.imie || ' ' || czytelnik.nazwisko AS "DANE CZYTELNIKA", COUNT(ksiazka.id_gat) AS "LICZBA GATUNKOW"  
FROM czytelnik
JOIN wypozyczenia ON czytelnik.id_czyt = wypozyczenia.id_czyt
JOIN ksiazka ON ksiazka.id_ks = wypozyczenia.id_ks
GROUP BY czytelnik.imie, czytelnik.nazwisko
ORDER BY "LICZBA GATUNKOW" DESC



SELECT COUNT(wydawnictwo.w_nazwa) AS "LICZBA WYDANYCH KSIAZEK" FROM wydawnictwo
JOIN ksiazka ON ksiazka.id_wyd=wydawnictwo.id_wyd
WHERE wydawnictwo.id_wyd = (
    SELECT id_wyd FROM ksiazka
    ORDER BY SYSDATE - data_wyd DESC
    FETCH FIRST ROW ONLY
)




SELECT format.f_nazwa,COUNT(ksiazka.tytul) AS "Liczba wypozyczen" FROM ksiazka
JOIN format USING(id_for)
JOIN wypozyczenia USING(id_ks)
WHERE SYSDATE - wypozyczenia.data_wyp < 90
GROUP BY format.f_nazwa
ORDER BY "Liczba wypozyczen"
FETCH FIRST ROW ONLY




SELECT gatunek.g_nazwa, COUNT(ksiazka.tytul), SUM(ksiazka.cena) FROM ksiazka
JOIN gatunek USING(id_gat)
GROUP BY gatunek.g_nazwa




SELECT gatunek.g_nazwa,COUNT(id_wyp) FROM wypozyczenia
JOIN ksiazka ON ksiazka.id_ks=wypozyczenia.id_ks
JOIN gatunek ON gatunek.id_gat=ksiazka.id_gat
GROUP BY g_nazwa
HAVING COUNT(id_wyp) > (
    SELECT AVG(COUNT(*)) FROM wypozyczenia
    JOIN ksiazka ON ksiazka.id_ks = wypozyczenia.id_ks
    GROUP BY id_gat
)

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
