# 1. Connettiti al db aziendale o esegui il restore del db 
# 2. Esplora la tabelle dei prodotti (DimProduct)
USE AdventureWorksDW;
SHOW databases;
SELECT *
FROM dimproduct;
# 3. Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi:
# ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
# Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno.
USE AdventureWorksDW;
SHOW databases;
SELECT 
productKey AS 'Codice_Prodotto',
ProductAlternateKey AS 'Codice_Prodotto_Alternativo', 
EnglishProductName AS 'Nome_Prodotto',
Color AS 'Colore',
StandardCost AS 'Costo_Standard',
FinishedGoodsFlag AS 'Prodotto_Finito'
FROM dimproduct
# 4. Partendo dalla query scritta nel passaggio precedente, esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1.
WHERE FinishedGoodsFlag = 1;
# 5. Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello ProductAlternateKey) comincia con FR oppure BK. Il result set deve 
# contenere il codice prodotto ProductKey), il modello, il nome del prodotto, il costo standard StandardCost) e il prezzo di listino ListPrice).
USE AdventureWorksDW;
SHOW databases;
SELECT 
productKey AS 'Codice_Prodotto',
ProductAlternateKey AS 'Modello', 
EnglishProductName AS 'Nome_Prodotto',
StandardCost AS 'Costo_Standard',
ListPrice AS 'Prezzo_di_listino'
FROM dimproduct
WHERE LEFT(ProductAlternateKey, 2) IN ("FR","BK") AND ProductKey>200; #se voglio cercare prodoti maggiori di 200
#Si puo utilizare anche: WHERE ProductAlternateKey LIKE 'FR%' OR ProductAlternateKey LIKE 'BK%'
# 6. Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dallʼazienda ListPrice - StandardCost)
# 7. Scrivi unʼaltra query al fine di esporre lʼelenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.
USE AdventureWorksDW;
SHOW databases;
SELECT 
productKey AS 'Codice_Prodotto',
ProductAlternateKey AS 'Codice_Prodotto_Alternativo', 
EnglishProductName AS 'Nome_Prodotto',
Color AS 'Colore',
StandardCost AS 'Costo_Standard',
FinishedGoodsFlag AS 'Prodotto_Finito',
ListPrice AS 'Prezzo_di_listino',
ListPrice - StandardCost AS 'Markup'
FROM dimproduct
WHERE FinishedGoodsFlag = 1 AND ListPrice BETWEEN 1000 AND 2000; #Si fissa i prezzi tra 1000 e 2000, la funzione AND aplicca la continuazione delle condizione 
# 8. Esplora la tabella degli impiegati aziendali DimEmployee)
# 9. Esponi, interrogando la tabella degli impiegati aziendali, lʼelenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1.
USE AdventureWorksDW;
SHOW databases;
SELECT *
FROM dimemployee
WHERE SalespersonFlag = 1;
# 10. Interroga la tabella delle vendite FactResellerSales). Esponi in output lʼelenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto:
# 597, 598, 477, 214. Calcola per ciascuna transazione il profitto SalesAmount - TotalProductCost).
SELECT *, 
(SalesAmount - TotalProductCost) AS Profitto # e la seconda parte della domanda 10
FROM factresellersales
WHERE OrderDate >= '2020-01-01' AND ProductKey IN (597,598,477,214);