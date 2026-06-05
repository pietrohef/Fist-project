USE AdventureWorksDW;
# 1. Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria DimProduct, DimProductSubcategory).
SELECT * 
FROM dimproduct; # la colomna che ha un collegamento con la tabella sucesiva: Englishproductname e Englishproductsubcategoryname
# Per cio il risultato è:
SELECT * 
FROM dimproductsubcategory; #Si controla che tipo di colonna hanno un collegamento con le la tabella dimproduct
SELECT 
	P.Englishproductname AS 'Nome_Protto',
    C.Englishproductsubcategoryname AS 'Sottocategoria'
FROM dimproduct P
LEFT JOIN dimproductsubcategory C 
	ON P.Productsubcategorykey = C.Productsubcategorykey;
    
# 2. Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria DimProduct, DimProductSubcategory, DimProductCategory).
SELECT * 
FROM dimproduct;
SELECT * 
FROM dimproductcategory; 
SELECT * 
FROM dimproductsubcategory; 
# Si controla il collegamentro tra di loro, si trova la relazione Englishproductname sulle tre tabelle e Productcategorykey solo su la seconda e terza
SELECT 
	P.Englishproductname AS 'Nome_Protto',
    C.Englishproductsubcategoryname AS 'Sottocategoria',
    S.Englishproductcategoryname AS 'Categoria'
FROM dimproduct P
LEFT JOIN dimproductsubcategory C 
	ON P.Productsubcategorykey = C.Productsubcategorykey
LEFT JOIN dimproductcategory S 
	ON C.Productcategorykey = S.Productcategorykey;
    
# 3. Esponi lʼelenco dei soli prodotti venduti DimProduct, FactResellerSales). 
SELECT * 
FROM dimproduct;
SELECT * 
FROM factresellersales;
# Si controla il collegamentro tra di loro, si trova la relazione Productkey sulle due tabelle
SELECT DISTINCT P.* # 'P.*' Sarebbe seleccionare tutti campi da dimproduct = P; si usa il SELECT DISTINCT per cancelare i duplicati
FROM dimproduct P
JOIN factresellersales F 
	ON P.productkey = F.productkey;
    
# 4. Esponi lʼelenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1)
SELECT 
	P.EnglishProductName AS 'Nome_Protto' #Apartiene al elenco di prodotti al interno da dimproduct
FROM dimproduct P
LEFT JOIN factresellersales F # Tabella che apartiene al elenco di prodotti
ON P.Productkey = F.Productkey #Colonna di collegamento tra P.EnglishProductName e factresellersales F
WHERE P.FinishedGoodsFlag = 1 #Filtro
	AND F.Productkey IS NULL;

# 5. Esponi lʼelenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)
SELECT 
	F.SalesOrderNumber AS Numero_Vendita,
	F.SalesOrderLineNumber AS Numero_Riga,
    F.OrderDate AS Data_Ordine,
    D.EnglishProductName AS 'Nome_Protto'
FROM factresellersales F
LEFT JOIN dimproduct D ON F.Productkey = D.Productkey;
    
# 6. Esponi lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
	# Primary Key delle tabelle 
    #factresellersales: ProductKey
    #dimproduct: ProductKey, ProductSubcategoryKey
    #dimproductsubcategory: ProductCategoryKey, ProductSubcategoryKey
    #dimproductcategory: ProductCategoryKey
SELECT 
	C.SalesOrderNumber AS 'Numero_Vendita',
	C.SalesOrderLineNumber AS 'Numero_Riga',
    C.OrderDate AS Data_Ordine,
	P.EnglishProductName AS 'Nome_Protto',
    S.Englishproductcategoryname AS 'Categoria'
FROM factresellersales C
LEFT JOIN dimproduct P ON C.Productkey = P.Productkey
LEFT JOIN dimproductsubcategory SC ON SC.ProductSubcategoryKey = P.ProductSubcategoryKey
LEFT JOIN dimproductcategory S ON S.productcategorykey = SC.productcategorykey;

# 7. Esplora la tabella DimReseller.
# 8. sponi in output lʼelenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.
# Ti chiede di controllare 'rivenditore', per trovare il nomme di tutti rivenditore si dobbrebe controllare a un livello regionale 
# per cio si fa il confronto con la tabella 'dimgeography' 
SELECT 
	N.ResellerName AS 'Nome_Rivenditore',
    R.EnglishCountryRegionName AS 'Regione'
FROM dimreseller N
LEFT JOIN dimgeography R ON R.GeographyKey = N.GeographyKey;

# 9. Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity,TotalProductCost. 

# transazioni di vendita = factresellersales
SELECT 
	S.SalesOrderNumber AS 'Numero_Vendita',
    S.SalesOrderLineNumber AS 'Numero_Riga',
    S.OrderDate AS 'Numero_Ordine',
    S.UnitPrice AS 'Prezzo_Unitario',
    S.OrderQuantity AS 'Quantità_Ordine',
    S.TotalProductCost AS 'Costo_Totale_Prodotto',
    P.EnglishProductName AS 'Nome_Protto',
	C.Englishproductcategoryname AS 'Categoria'
FROM factresellersales S
# Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e lʼarea geografica.
LEFT JOIN dimproduct P ON P.ProductKey = S.ProductKey #Collegamento tra la tabella 'dimproduct' e 'factresellersales'
LEFT JOIN dimproductsubcategory SC ON SC.ProductSubcategoryKey = P.ProductSubcategoryKey #Collegamento tra la tabella 'dimproductsubcategory' e 'dimproduct'
LEFT JOIN dimproductcategory C ON C.productcategorykey = SC.productcategorykey #Collegamento tra la tabella 'dimproductcategory' e 'dimproductsubcategory'
LEFT JOIN dimreseller D ON D.ResellerKey = S.ResellerKey #Collegamento tra la tabella 'dimreseller' e 'factresellersales'
LEFT JOIN dimgeography R ON R.GeographyKey = D.GeographyKey; #Collegamento tra la tabella 'dimgeography' e 'dimreseller'