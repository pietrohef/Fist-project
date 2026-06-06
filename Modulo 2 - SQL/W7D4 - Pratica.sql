USE AdventureWorksDW;
# 1. Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
#La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata.
SELECT
	D.ProductKey,
    D.EnglishProductName AS 'Prodotto',
    S.EnglishProductSubcategoryName AS 'SottoCategoria',
    C.EnglishProductCategoryName AS 'Categoria'
FROM dimproduct D
LEFT JOIN dimproductsubcategory S ON S.ProductSubcategoryKey = D.ProductSubcategoryKey
LEFT JOIN dimproductcategory C ON C.ProductCategoryKey = S.ProductCategoryKey;

# 2. Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
#La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione.
SELECT
    R.ResellerKey,
    R.ResellerName AS 'NomeRivenditore',
    G.City AS 'NomeCitta',
    G.EnglishCountryRegionName AS 'Regione'
FROM dimreseller R
LEFT JOIN dimgeography G ON G.GeographyKey = R.GeographyKey;

# 3. Crea una vista denominata Sales che deve restituire la data dellʼordine, 
# il codice documento, la riga di corpo del documento, la quantità venduta, lʼimporto totale e il profitto.
SELECT
    F.OrderDate,
    F.SalesOrderNumber,
    F.SalesOrderLineNumber,
    ProductKey ,
    ResellerKey,
    F.OrderQuantity,
    F.SalesAmount,
    F.TotalProductCost,
    (F.SalesAmount - IFNULL(F.TotalProductCost,0)) AS 'Profitto'
FROM factresellersales F;

