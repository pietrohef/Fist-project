CREATE DATABASE W8D4_Epicode;
USE W8D4_Epicode;
CREATE TABLE Product (
ProductID INT AUTO_INCREMENT PRIMARY KEY,
NomeProdotto VARCHAR (50),
NomeCategoria VARCHAR (50)
);
CREATE TABLE Region (
RegionID INT AUTO_INCREMENT PRIMARY KEY,
NomeStato VARCHAR (50),
NomeRegione VARCHAR(50)
);
CREATE TABLE Sales (
SalesID INT AUTO_INCREMENT PRIMARY KEY,
RegionID INT,
ProductID INT,
DataVendita DATE NOT NULL,
Importo DECIMAL (18,2),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
FOREIGN KEY (RegionID) REFERENCES Region(RegionID) 
);

INSERT INTO Product (NomeProdotto, NomeCategoria) VALUES
  ('LEGO Technic Ferrari Daytona SP3', 'LEGO e Costruzioni'),
  ('LEGO City Stazione dei Pompieri', 'LEGO e Costruzioni'),
  ('Barbie Dreamhouse', 'Bambole e Accessori'),
  ('Baby Alive Beve e Fa la Pipì', 'Bambole e Accessori'),
  ('Hot Wheels Pista Turbo Loop', 'Macchinine e Veicoli'),
  ('Brio World Trenino in Legno', 'Macchinine e Veicoli'),
  ('Nerf Elite 2.0 Commander', 'Giochi Attivi'),
  ('Playmobil Castello dei Cavalieri', 'Playmobil e Personaggi'),
  ('Monopoly Classic', 'Giochi da Tavolo'),
  ('Scacchiera Deluxe in Legno', 'Giochi da Tavolo');

INSERT INTO Region (NomeStato, NomeRegione) VALUES
  ('Italia', 'Lombardia'),
  ('Italia', 'Lazio'),
  ('Italia', 'Campania'),
  ('Italia', 'Veneto'),
  ('Italia', 'Emilia-Romagna'),
  ('Italia', 'Piemonte'),
  ('Italia', 'Toscana'),
  ('Italia', 'Puglia'),
  ('Italia', 'Sicilia'),
  ('Italia', 'Liguria');

INSERT INTO Sales (RegionID, ProductID, DataVendita, Importo) VALUES
  (1, 1, '2026-01-15', 449.99),
  (2, 3, '2026-01-18', 259.00),
  (3, 5, '2026-01-22', 49.99),
  (4, 7, '2026-02-03', 34.90),
  (5, 2, '2026-02-10', 89.99),
  (6, 4, '2026-02-20', 44.90),
  (7, 8, '2025-03-01', 74.99),
  (8, 9, '2025-03-05', 39.90),
  (9, 10, '2025-03-12', 89.00),
  (10, 6, '2025-03-15', 54.90);

DROP TABLE Product;
DROP TABLE Region;
DROP TABLE Sales;

SELECT * FROM Product;
SELECT * FROM Region;
SELECT * FROM Sales;

# 1. Verificare che i campi definiti come PK siano univoci. 
# In altre parole, scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata).

#Verifica PK di ogni entità
SELECT 	
COUNT(*) AS ConteggioRighe,
COUNT(DISTINCT (ProductID)) AS Conteggio
FROM product;

SELECT 	
COUNT(*) AS ConteggioRighe,
COUNT(DISTINCT (RegionID)) AS Conteggio
FROM Region;

SELECT 	
COUNT(*) AS ConteggioRighe,
COUNT(DISTINCT (SalesID)) AS Conteggio
FROM Sales;

# l’univocità dei valori dele PK
SELECT 
	ProductID, 
	COUNT(*) AS Conteggio
FROM Product
GROUP BY ProductID
HAVING Conteggio > 1;
 
SELECT RegionID, COUNT(*) AS Conteggio
FROM Region
GROUP BY RegionID
HAVING Conteggio > 1;
 
SELECT SalesID, COUNT(*) AS Conteggio
FROM Sales
GROUP BY SalesID
HAVING Conteggio > 1;

# 2. Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, la categoria del prodotto,
# il nome dello stato, il nome della regione di vendita e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni 
# dalla data vendita o meno (>180 -> True, <= 180 -> False)

SELECT
    S.SalesID                                    AS CodiceDocumento,
    S.DataVendita                                AS Data,
    P.NomeProdotto                               AS Prodotto,
    P.NomeCategoria                              AS Categoria,
    R.NomeRegione                                AS Regione,
    R.NomeStato                                  AS Stato,
	CASE WHEN datediff(curdate(), S.DataVendita) > 180 THEN 1 ELSE 0 END AS '180_Giorni_FLG'
FROM Sales AS S
JOIN Product AS P ON P.ProductID = S.ProductID
JOIN Region  AS R ON R.RegionID  = S.RegionID;

# 3. Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito.
# (ogni valore della condizione deve risultare da una query e non deve essere inserito a mano). 
# Nel result set devono comparire solo il codice prodotto e il totale venduto.

SELECT
    S.ProductID                  AS CodiceProducto,
    SUM(S.Importo)               AS TotaleVenduto
FROM Sales S
GROUP BY S.ProductID
HAVING SUM(S.Importo) > (
    SELECT AVG(Totale_Per_Prodotto)
    FROM (
        SELECT SUM(Importo) AS totale_Per_Prodotto
        FROM Sales
        WHERE YEAR(DataVendita) = YEAR(CURDATE()) - 1
        GROUP BY ProductID
    ) AS Media_Annuale
);
# 4. Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 
SELECT
    P.ProductID                  AS CodiceProducto,
    YEAR(S.DataVendita)          AS Anno,
    SUM(S.Importo)               AS FatturatoTotale
FROM Sales AS S
JOIN Product AS P ON P.ProductID = S.ProductID
GROUP BY 
	P.ProductID, 
	YEAR(S.DataVendita)
ORDER BY 
	Anno,
    FatturatoTotale DESC;
    
# 5.Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente. 
SELECT
    R.NomeStato                  AS Stato,
    YEAR(S.DataVendita)          AS Anno,
    SUM(S.Importo)               AS FatturatoTotale
FROM Sales AS S
JOIN Region AS R ON R.RegionID = S.RegionID
GROUP BY 
	R.NomeStato,
    YEAR(S.DataVendita)
ORDER BY 
	Anno ASC,
	FatturatoTotale DESC;
    
# 6. Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT
    P.NomeCategoria              AS Categoria,
    COUNT(S.SalesID)             AS NumeroVendite
FROM Sales AS S
JOIN Product AS P ON S.ProductID = P.ProductID
GROUP BY P.NomeCategoria
ORDER BY NumeroVendite DESC
LIMIT 1;
 
# 7. Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
SELECT
    P.ProductID,
    P.NomeProdotto,
    P.NomeCategoria
FROM Product AS P
LEFT JOIN Sales AS S ON P.ProductID = S.ProductID
WHERE S.SalesID IS NULL;
 
 SELECT
    ProductID,
    NomeProdotto,
    NomeCategoria
FROM Product
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM Sales
);
# Il risultato e vuoto perche tutti prodotti sono stati venduti almeno una volta

# 8. Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili (codice prodotto, nome prodotto, nome categoria)

CREATE OR REPLACE VIEW Views_Prodotti AS (
SELECT
    ProductID      AS CodiceProducto,
    NomeProdotto   AS NomeProdotto,
    NomeCategoria  AS NomeCategoria
FROM Product
);
SELECT * FROM Views_Prodotti; 

# 9. Creare una vista per le informazioni geografiche
CREATE OR REPLACE VIEW Views_Geografia AS (
SELECT
    RegionID       AS CodiceRegione,
    NomeStato      AS Stato,
    NomeRegione    AS Regione
FROM Region
);
SELECT * FROM Views_Geografia;
