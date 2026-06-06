USE AdventureWorksDW;
DESCRIBE dimproduct;

# 1. Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia?
SELECT 
	Productkey
FROM dimproduct
WHERE Productkey IS NULL; #Verifico che non ci siano spazi vuoti in la tabella Productkey
#si controla che non ci siano duplicati all interno di Productkey
SELECT 
	Productkey,
	COUNT(*) AS Contegio
FROM dimproduct
GROUP BY Productkey
HAVING COUNT(*) > 1; #Non ci sono duplicati
# non ci sono spazi vuoti ne duplicati per cio e una chiave primaria 

# 2. Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.
SELECT *
FROM factresellersales;
DESCRIBE factresellersales;
#Si debe verificare se SalesOrderNumber e SalesOrderLineNumber siano chiavi primarie
#si debe verificare che non cisiano duplicati 
SELECT 
	SalesOrderNumber,
	SalesOrderLineNumber,
    COUNT(*) AS Occorrenze
FROM factresellersales
GROUP BY 
	SalesOrderNumber,
    SalesOrderLineNumber
HAVING COUNT(*) >1;

#si debe verificare che non cisiano valori null
SELECT *
FROM factresellersales
WHERE  SalesOrderLineNumber IS NULL = SalesOrderNumber IS NULL;

# 3. Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
SELECT 
	OrderDate,
    COUNT(SalesOrderLineNumber)
FROM factresellersales
WHERE OrderDate > '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate ASC;
# 4. Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) 
#e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020.
# Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
#I campi in output devono essere parlanti!
SELECT
    P.EnglishProductName AS Nome_Prodotto,
    F.OrderDate AS Data_Ordine,
    SUM(F.SalesAmount) AS Fatturato_Totale,
    SUM(F.OrderQuantity) AS Totale_Ordini,
    AVG(F.UnitPrice) AS Prezzo_Medio_Vendita
FROM factresellersales AS F
LEFT JOIN dimproduct AS P ON F.ProductKey = P.ProductKey
WHERE F.OrderDate >= '2020-01-01'
GROUP BY P.EnglishProductName;

# 5. Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory).
# Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!

# Fatturato totale = FactResellerSales.SalesAmount = FactResellerSales
# Quantità totale venduta = FactResellerSales.OrderQuantity = FactResellerSales
# Categoria prodotto = DimProductCategor = DimProduct
# Non esiste un collegamente directo con la 'categoria prodotto' per cio si debe collegare con le join
# FactResellerSales -> DimProduct -> DimProductSubcategory -> DimProductCategory
SELECT
    P.EnglishProductCategoryName AS 'Nome_Categoria',
    SUM(F.SalesAmount) AS 'Fatturato_Totale',
    SUM(F.OrderQuantity) AS 'Quantita_Totale_Venduta'
FROM factresellersales F
LEFT JOIN dimproduct D ON D.ProductKey = F.ProductKey
LEFT JOIN dimproductsubcategory PS ON PS.ProductSubcategoryKey = D.ProductSubcategoryKey
LEFT JOIN dimproductcategory P ON P.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY P.EnglishProductCategoryName;

# 6. Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
# Il result set deve esporre lʼelenco delle città con fatturato realizzato superiore a 60K.
# Fatturato totale = FactResellerSales.SalesAmount = FactResellerSales
# Area città  = DimGeography.City = DimGeography
# Non esiste un collegamente directo tra 'Fatturato totale' e 'Area città' per cio si debe collegare con le join
# FactResellerSales -> DimReseller -> DimGeography 
	# Tra FactResellerSales → DimReseller = ResellerKey 
	# Tra DimReseller -> DimGeography = GeographyKey
SELECT
    C.City AS Area_Citta,
    SUM(F.SalesAmount) AS Fatturato_Totale
FROM factresellersales F
LEFT JOIN dimreseller R ON R.ResellerKey = F.ResellerKey
LEFT JOIN dimgeography C ON C.GeographyKey = R.GeographyKey
WHERE F.OrderDate >= '2020-01-01'
GROUP BY C.City
HAVING SUM(F.SalesAmount) > 60000;

