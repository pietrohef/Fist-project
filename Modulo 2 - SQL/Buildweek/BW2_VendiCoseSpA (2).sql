# ==============================================================================
# ESERCIZIO BW2
# Data: 12/06/2026
# ==============================================================================

# ==============================================================================
# CREAZIONE DATABASE
# ==============================================================================

# Eliminiamo il database se già esistente per permettere esecuzioni ripetute
DROP DATABASE IF EXISTS 	VendiCoseSpA;
# ------------------------------------------------------------------------------
# Creiamo il database
CREATE DATABASE 			VendiCoseSpA;
# ------------------------------------------------------------------------------
# Selezioniamo il database
USE 						VendiCoseSpA;

# ==============================================================================
# CREAZIONE TABELLE 
# ==============================================================================

# ------------------------------------------------------------------------------
# Creiamo le tabelle FORTI:
# ------------------------------------------------------------------------------

CREATE TABLE Region (
     RegionID 						INT AUTO_INCREMENT
    ,RegionName						VARCHAR(100) NOT NULL
    ,State 							VARCHAR(100) NOT NULL
    ,CONSTRAINT PK_Region 			PRIMARY KEY (RegionID)
);

CREATE TABLE Warehouse (
     WarehouseID 					INT AUTO_INCREMENT
    ,WarehouseName					VARCHAR(100) NOT NULL
    ,RegionID 						INT NOT NULL
    ,CONSTRAINT PK_Warehouse 		PRIMARY KEY (WarehouseID)
    ,CONSTRAINT FK_Warehouse_Region FOREIGN KEY (RegionID) REFERENCES Region(RegionID) 
);

CREATE TABLE Category (
     CategoryID 					INT AUTO_INCREMENT
    ,CategoryName					VARCHAR(100) NOT NULL
    ,LimitNumber 					INT NOT NULL
    ,CONSTRAINT 					PK_Category PRIMARY KEY (CategoryID)
);

CREATE TABLE Store (
     StoreID        				INT AUTO_INCREMENT
    ,StoreName	      				VARCHAR(100) NOT NULL
    ,WarehouseID    				INT NOT NULL
    ,CONSTRAINT PK_Store            PRIMARY KEY (StoreID)
    ,CONSTRAINT FK_Store_Warehouse  FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Product (
     ProductID 						INT AUTO_INCREMENT
    ,ProductName 					VARCHAR(150) NOT NULL
    ,CategoryID 					INT NOT NULL
    ,CONSTRAINT PK_Product 			PRIMARY KEY (ProductID)
    ,CONSTRAINT FK_ProductCategory 	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE SalesHeader (
     SalesHeaderID 					INT AUTO_INCREMENT
    ,StoreID 						INT NOT NULL
    ,SaleDate 						DATE NOT NULL
    ,CONSTRAINT PK_SalesHeader 		PRIMARY KEY (SalesHeaderID)
    ,CONSTRAINT FK_SalesHeaderStore FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

# ------------------------------------------------------------------------------
# Creiamo le tabelle DEBOLI (di associazione):
# ------------------------------------------------------------------------------

CREATE TABLE SalesDetail (
     SalesDetailID 					INT NOT NULL AUTO_INCREMENT
    ,SalesHeaderID 					INT NOT NULL
    ,ProductID 						INT NOT NULL
    ,Quantity 						INT NOT NULL
    ,UnitPrice 						DECIMAL(18,2) NOT NULL
    ,TotalPrice 					DECIMAL(18,2) NOT NULL
    ,CONSTRAINT PK_SalesDetail 		PRIMARY KEY (SalesDetailID)
    ,CONSTRAINT FK_DetailHeader 	FOREIGN KEY (SalesHeaderID) REFERENCES SalesHeader(SalesHeaderID) ON DELETE CASCADE
    ,CONSTRAINT FK_DetailProduct 	FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE RESTRICT
);

CREATE TABLE Inventory (
     InventoryID        				INT NOT NULL AUTO_INCREMENT
    ,WarehouseID        				INT NOT NULL
    ,ProductID          				INT NOT NULL
    ,QuantityInventory  				INT NOT NULL DEFAULT 0
    ,CONSTRAINT PK_Inventory 			PRIMARY KEY (InventoryID)
    ,CONSTRAINT FK_InventoryWarehouse 	FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) ON DELETE CASCADE
    ,CONSTRAINT FK_InventoryProduct 	FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE RESTRICT
);

CREATE TABLE Restock (
     RestockID          				INT NOT NULL AUTO_INCREMENT
    ,WarehouseID        				INT NOT NULL
    ,CategoryID         				INT NOT NULL
    ,LimitNumber        				INT NOT NULL DEFAULT 0
    ,CONSTRAINT PK_Restock 				PRIMARY KEY (RestockID)
    ,CONSTRAINT FK_Restock_Warehouse 	FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) ON DELETE CASCADE
    ,CONSTRAINT FK_Restock_Category 	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON DELETE CASCADE
);

# ==============================================================================
# POPOLAMENTO DELLE TABELLE (INSERT INTO)
# ==============================================================================

# REGION (Anagrafica Geografica Nazionale)
INSERT INTO Region (RegionName, State) VALUES 
 ('Abruzzo', 'Italia'), ('Basilicata', 'Italia'), ('Calabria', 'Italia'), ('Campania', 'Italia'),
 ('Emilia-Romagna', 'Italia'), ('Friuli-Venezia Giulia', 'Italia'), ('Lazio', 'Italia'), ('Liguria', 'Italia'),
 ('Lombardia', 'Italia'), ('Marche', 'Italia'), ('Molise', 'Italia'), ('Piemonte', 'Italia'),
 ('Puglia', 'Italia'), ('Sardegna', 'Italia'), ('Sicilia', 'Italia'), ('Toscana', 'Italia'),
 ('Trentino-Alto Adige', 'Italia'), ('Umbria', 'Italia'), ('Valle d''Aosta', 'Italia'), ('Veneto', 'Italia');

# WAREHOUSE (Nodi Logistici di Rifornimento Territoriale VendiCose S.p.A.)
# (CeDi = centro distribuzione)
INSERT INTO Warehouse (WarehouseName, RegionID) VALUES 
 ('CeDi VendiCose - Liguria', 8)          # WarehouseID 1 (Liguria)
,('CeDi VendiCose - Lombardia', 9)        # WarehouseID 2 (Lombardia)
,('CeDi VendiCose - Piemonte', 12)        # WarehouseID 3 (Piemonte)
,('CeDi VendiCose - Lazio', 7)            # WarehouseID 4 (Lazio)
,('CeDi VendiCose - Campania', 4)         # WarehouseID 5 (Campania)
,('CeDi VendiCose - Puglia', 13)          # WarehouseID 6 (Puglia)
,('CeDi VendiCose - Sicilia', 15);         # WarehouseID 7 (Sicilia)

# CATEGORY (Macro-Reparti Merceologici Supermercato)
INSERT INTO Category (CategoryName, LimitNumber) VALUES 
 ('Alimentari', 50)                     # CategoryID 1
,('Cartoleria', 20)                     # CategoryID 2
,('Abbigliamento', 30)                  # CategoryID 3
,('Sport', 15)                          # CategoryID 4
,('Cosmetica', 25)                      # CategoryID 5
,('Elettronica', 10);                   # CategoryID 6

# STORE (Rete di Punti Vendita Diretti del Marchio VendiCose S.p.A.)
INSERT INTO Store (StoreName, WarehouseID) VALUES 
# Afferenti al Nodo Liguria (Warehouse 1)
 ('VendiCose Express - Genova Fiumara', 1) # StoreID 1
,('VendiCose Iper - Savona Centro', 1)     # StoreID 2
# Afferenti al Nodo Lombardia (Warehouse 2)
,('VendiCose Supermercato - Milano Centro', 2) # StoreID 3
,('VendiCose Local - Monza Stazione', 2)   # StoreID 4
,('VendiCose Iper - Bergamo', 2)           # StoreID 5
# Afferenti al Nodo Piemonte (Warehouse 3)
,('VendiCose Iper - Torino Lingotto', 3)   # StoreID 6
,('VendiCose Express - Novara', 3)         # StoreID 7
# Afferenti al Nodo Lazio (Warehouse 4)
,('VendiCose Iper - Roma Est', 4)          # StoreID 8
,('VendiCose Supermercato - Latina', 4)    # StoreID 9
# Afferenti ad altri Nodi Regionali
,('VendiCose Supermercato - Napoli Chiaia', 5) # StoreID 10
,('VendiCose Local - Salerno', 5)          # StoreID 11
,('VendiCose Supermercato - Bari Centro', 6) # StoreID 12
,('VendiCose Iper - Catania Fontanarossa', 7) # StoreID 13
,('VendiCose Express - Palermo Libertà', 7); # StoreID 14

# PRODUCT (Catalogo Merci a Marchio Privato e Distribuzione VendiCose)
INSERT INTO Product (ProductName, CategoryID) VALUES 
# Categoria 1: Alimentari
 ('Caffè Espresso Selezione Oro VendiCose 250g', 1)  # ProductID 1
,('Pasta Trafilata al Bronzo Alta Qualità 1kg', 1)  # ProductID 2
,('Olio Extravergine d''Oliva 100% ITA BIO 1L', 1)   # ProductID 3
# Categoria 2: Cartoleria
,('Penna a Sfera Scrittura Fluida - Blu (Conf. da 4)', 2) # ProductID 4
,('Taccuino Quadernone A5 Copertina Panda', 2)     # ProductID 5
,('Set Evidenziatori Pastello per Ufficio x4', 2)   # ProductID 6
# Categoria 3: Abbigliamento
,('Felpa Basic Con Cappuccio Cotone Grigia', 3)    # ProductID 7
,('T-Shirt Sportiva Traspirante Tempo Libero', 3)  # ProductID 8
# Categoria 4: Sport & Tempo Libero
,('Tappetino Fitness Antiscivolo Imbottito', 4)     # ProductID 9
,('Coppia Manubri Fitness in Neoprene 2x2kg', 4)    # ProductID 10
# Categoria 5: Cosmetica & Cura Persona
,('Crema Viso Idratante Giorno Aloe Vera BIO', 5)   # ProductID 11
,('Bagnoschiuma Rigenerante Fiori di Lavanda 500ml', 5) # ProductID 12
# Categoria 6: Elettronica
,('Auricolari Wireless Bluetooth Pocket Tech', 6)  # ProductID 13
,('Cassa Speaker Bluetooth Impermeabile da Doccia', 6); # ProductID 14

# SALESHEADER (Flusso transazionale ad alte performance su TUTTA la rete di negozi)
INSERT INTO SalesHeader (StoreID, SaleDate) VALUES 
 (1, '2026-06-11'), (1, '2026-06-11')   # Store 1 (Genova)
,(2, '2026-06-11')                     # Store 2 (Savona)
,(3, '2026-06-11'), (3, '2026-06-11')   # Store 3 (Milano)
,(4, '2026-06-11')                     # Store 4 (Monza)
,(5, '2026-06-11'), (5, '2026-06-11')   # Store 5 (Bergamo)
,(6, '2026-06-11')                     # Store 6 (Torino)
,(7, '2026-06-11')                     # Store 7 (Novara)
,(8, '2026-06-11'), (8, '2026-06-11')   # Store 8 (Roma)
,(9, '2026-06-11')                     # Store 9 (Latina)
,(10, '2026-06-11')                    # Store 10 (Napoli)
,(11, '2026-06-11')                    # Store 11 (Salerno)
,(12, '2026-06-11')                    # Store 12 (Bari)
,(13, '2026-06-11')                    # Store 13 (Catania)
,(14, '2026-06-11');                    # Store 14 (Palermo)

# SALESDETAIL (Grandi volumi d'acquisto diffusi su tutti i 14 negozi)
INSERT INTO SalesDetail (SalesHeaderID, ProductID, Quantity, UnitPrice, TotalPrice) VALUES 
# Scontrini Store 1 (Genova)
 (1, 5, 3, 5.90, 17.70)
,(1, 1, 2, 3.50, 7.00)
,(2, 2, 4, 2.80, 11.20)
,(2, 3, 1, 6.50, 6.50)
# Scontrino Store 2 (Savona)
,(3, 11, 2, 14.90, 29.80)
,(3, 12, 3, 4.20, 12.60)
# Scontrini Store 3 (Milano)
 ,(4, 4, 15, 1.99, 29.85)
,(4, 13, 2, 24.99, 49.98)
,(5, 3, 5, 6.50, 32.50)
,(5, 11, 2, 14.90, 29.80)
# Scontrino Store 4 (Monza)
,(6, 1, 4, 3.50, 14.00)
,(6, 2, 8, 2.80, 22.40)
# Scontrini Store 5 (Bergamo)
,(7, 14, 2, 19.99, 39.98)
,(7, 7, 2, 29.90, 59.80)
,(8, 2, 10, 2.80, 28.00)
,(8, 6, 3, 4.50, 13.50)
# Scontrino Store 6 (Torino)
,(9, 14, 3, 19.99, 59.97)
,(9, 10, 2, 15.50, 31.00)
# Scontrino Store 7 (Novara)
,(10, 8, 5, 12.50, 62.50)
,(10, 9, 2, 18.00, 36.00)
# Scontrini Store 8 (Roma)
,(11, 3, 12, 6.50, 78.00)
,(11, 1, 6, 3.50, 21.00)
,(12, 13, 3, 24.99, 74.97)
,(12, 7, 2, 29.90, 59.80)
# Scontrino Store 9 (Latina)
,(13, 2, 20, 2.80, 56.00)
,(13, 4, 5, 1.99, 9.95)
# Scontrino Store 10 (Napoli)
,(14, 1, 25, 3.50, 87.50)
,(14, 2, 15, 2.80, 42.00)
# Scontrino Store 11 (Salerno)
,(15, 11, 4, 14.90, 59.60)
,(15, 12, 6, 4.20, 25.20)
# Scontrino Store 12 (Bari)
,(16, 3, 8, 6.50, 52.00)
,(16, 8, 4, 12.50, 50.00)
# Scontrino Store 13 (Catania)
,(17, 13, 4, 24.99, 99.96)
,(17, 14, 2, 19.99, 39.98)
# Scontrino Store 14 (Palermo)
,(18, 1, 10, 3.50, 35.00)
,(18, 7, 5, 29.90, 149.50);

# INVENTORY (Mappatura completa e realistica di tutti i 7 CeDi logistici)
INSERT INTO Inventory (WarehouseID, ProductID, QuantityInventory) VALUES 
# CeDi 1 - Liguria
(1, 1, 150), (1, 2, 280), (1, 3, 90), (1, 4, 110), (1, 5, 15), (1, 6, 45), (1, 11, 60), (1, 12, 85), (1, 13, 40), (1, 14, 30)
# CeDi 2 - Lombardia
,(2, 1, 400), (2, 2, 550), (2, 3, 180), (2, 4, 200), (2, 5, 120), (2, 6, 90), (2, 11, 8), (2, 12, 140), (2, 13, 70), (2, 14, 55)
# CeDi 3 - Piemonte
,(3, 1, 130), (3, 2, 190), (3, 3, 70), (3, 6, 5), (3, 7, 45), (3, 8, 60), (3, 9, 30), (3, 14, 65)
# CeDi 4 - Lazio
,(4, 1, 210), (4, 2, 340), (4, 3, 75), (4, 4, 130), (4, 7, 80), (4, 11, 50), (4, 12, 95), (4, 13, 3), (4, 14, 40)
# CeDi 5 - Campania
,(5, 1, 180), (5, 2, 290), (5, 3, 85), (5, 11, 12), (5, 12, 110)
# CeDi 6 - Puglia
,(6, 1, 140), (6, 2, 210), (6, 3, 65), (6, 8, 4), (6, 12, 70)
# CeDi 7 - Sicilia
,(7, 1, 160), (7, 2, 250), (7, 7, 11), (7, 12, 80), (7, 13, 35), (7, 14, 28);

# RESTOCK (Pianificazione storica dei parametri e delle soglie critiche)
INSERT INTO Restock (WarehouseID, CategoryID, LimitNumber) VALUES 
# CeDi 1 - Liguria
(1, 1, 50), (1, 2, 20), (1, 5, 15)
# CeDi 2 - Lombardia
,(2, 1, 100), (2, 2, 40), (2, 5, 25)
# CeDi 3 - Piemonte
,(3, 1, 40), (3, 2, 15), (3, 4, 20)
# CeDi 4 - Lazio
,(4, 1, 60), (4, 3, 35), (4, 6, 10)
# CeDi 5 - Campania
,(5, 1, 55), (5, 5, 20)
# CeDi 6 - Puglia
,(6, 1, 45), (6, 3, 25)
# CeDi 7 - Sicilia
,(7, 1, 50), (7, 3, 30), (7, 6, 12);

# ==============================================================================
# QUERY DI ANALISI
# ==============================================================================

SHOW TABLES;

# Visualizza il contenuto delle tabelle Anagrafiche (Forti)
SELECT * FROM Region;
SELECT * FROM Warehouse;
SELECT * FROM Store;
SELECT * FROM Category;
SELECT * FROM Product;
# Visualizza il contenuto delle tabelle Transazionali (Scontrini)
SELECT * FROM SalesHeader;
SELECT * FROM SalesDetail;
# Visualizza il contenuto delle tabelle Logistiche (Deboli/Ponte)
SELECT * FROM Inventory;
SELECT * FROM Restock;

# ------------------------------------------------------------------------------
# Troviamo l'elenco dei negozi con la loro regione.
# ------------------------------------------------------------------------------

SELECT 
	 S.StoreName
    ,W.WarehouseName
    ,R.RegionName
FROM Store S
JOIN Warehouse W ON S.WarehouseID = W.WarehouseID
JOIN Region R    ON W.RegionID = R.RegionID;

# ------------------------------------------------------------------------------
# Report standard dei prodotti sotto soglia logistica
# ------------------------------------------------------------------------------

SELECT 
     W.WarehouseName		AS Magazzino
    ,P.ProductName			AS Prodotto
    ,C.CategoryName			AS Categoria
    ,I.QuantityInventory 	AS GiacenzaAttuale
    ,R.LimitNumber 			AS SogliaMinimaRichiesta
FROM Inventory I
JOIN Warehouse W 			ON I.WarehouseID = W.WarehouseID
JOIN Product P    			ON I.ProductID = P.ProductID
JOIN Category C   			ON P.CategoryID = C.CategoryID
JOIN Restock R    			ON R.WarehouseID = I.WarehouseID AND R.CategoryID = C.CategoryID
WHERE I.QuantityInventory < R.LimitNumber;

# ------------------------------------------------------------------------------
# Ipotizziamo una vendita nel Negozio con ID = 1 (Liguria), 
# per il Prodotto con ID = 5 (taccuino), quantità venduta = 3
# ------------------------------------------------------------------------------

UPDATE Inventory I
JOIN Store S ON I.WarehouseID = S.WarehouseID
SET I.QuantityInventory = I.QuantityInventory - 3 
WHERE S.StoreID = 1 AND I.ProductID = 5;

# ------------------------------------------------------------------------------
# verifichiamo se la quantità del Prodotto con ID = 5 
# dal totale di 12 è diminuita ad arrivare a 9 e
# creiamo un report di tutti i prodotti che, in un dato magazzino, 
# sono scesi sotto la soglia critica stabilita per la loro categoria.
# ------------------------------------------------------------------------------

SELECT 
     W.WarehouseName		AS Magazzino
    ,P.ProductName			AS Prodotto
    ,C.CategoryName			AS Categoria
    ,I.QuantityInventory 	AS GiacenzaAttuale
    ,R.LimitNumber 			AS SogliaMinimaRichiesta
FROM Inventory I
JOIN Warehouse W 			ON I.WarehouseID = W.WarehouseID
JOIN Product P    			ON I.ProductID = P.ProductID
JOIN Category C   			ON P.CategoryID = C.CategoryID
JOIN Restock R    			ON R.WarehouseID = I.WarehouseID AND R.CategoryID = C.CategoryID
WHERE I.QuantityInventory < R.LimitNumber;

# ------------------------------------------------------------------------------
# Crea una vista per identificare immediatamente le urgenze di rifornimento
# ------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_AssetsUnderManagement AS
SELECT 
     W.WarehouseName						AS CentroDistribuzione
    ,C.CategoryName							AS Categoria
    ,P.ProductName							AS Prodotto
    ,I.QuantityInventory 					AS GiacenzaAttuale
    ,R.LimitNumber 							AS SogliaMinima
    ,(R.LimitNumber - I.QuantityInventory) 	AS PezziDaOrdinare
FROM Inventory I
JOIN Warehouse W 			ON I.WarehouseID = W.WarehouseID
JOIN Product P    			ON I.ProductID = P.ProductID
JOIN Category C   			ON P.CategoryID = C.CategoryID
JOIN Restock R    			ON R.WarehouseID = I.WarehouseID AND R.CategoryID = C.CategoryID
WHERE I.QuantityInventory < R.LimitNumber
ORDER BY PezziDaOrdinare DESC;

# Test della Vista Logistica
SELECT * FROM v_AssetsUnderManagement;

# ------------------------------------------------------------------------------
# Crea un'unica grande tabella virtuale con tutti i dettagli delle vendite
# ------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_ReportIncome AS
SELECT 
     SH.SalesHeaderID 	AS NumeroScontrino
    ,SH.SaleDate 		AS DataVendita
    ,R.RegionName 		AS Regione
    ,S.StoreName 		AS PuntoVendita
    ,P.ProductName 		AS Prodotto
    ,C.CategoryName 	AS Categoria
    ,SD.Quantity 		AS QuantitaVenduta
    ,SD.UnitPrice 		AS PrezzoUnitario
    ,SD.TotalPrice 		AS RicavoTotale
FROM SalesDetail SD
JOIN SalesHeader SH 	ON SD.SalesHeaderID = SH.SalesHeaderID
JOIN Store S 			ON SH.StoreID = S.StoreID
JOIN Warehouse W 		ON S.WarehouseID = W.WarehouseID
JOIN Region R 			ON W.RegionID = R.RegionID
JOIN Product P 			ON SD.ProductID = P.ProductID
JOIN Category C 		ON P.CategoryID = C.CategoryID;

# Test della Vista Commerciale
SELECT * FROM v_ReportIncome;

# ------------------------------------------------------------------------------
# prodotti che nei vari magazzini hanno toccato o superato in negativo la soglia minima di reparto
# ------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_ProductToRestock AS
SELECT 
     W.WarehouseName        				AS Magazzino
    ,P.ProductName          				AS Prodotto
    ,C.CategoryName         				AS Categoria
    ,I.QuantityInventory    				AS GiacenzaAttuale
    ,R.LimitNumber          				AS SogliaMinimaRichiesta
    ,(R.LimitNumber - I.QuantityInventory) 	AS UnitaDaOrdinare
FROM Inventory I
JOIN Warehouse W            ON I.WarehouseID = W.WarehouseID
JOIN Product P              ON I.ProductID = P.ProductID
JOIN Category C             ON P.CategoryID = C.CategoryID
JOIN Restock R              ON R.WarehouseID = I.WarehouseID AND R.CategoryID = C.CategoryID
WHERE I.QuantityInventory < R.LimitNumber;

# Test della Vista 
SELECT * FROM v_ProductToRestock;

# ------------------------------------------------------------------------------
# Report per la Logistica: offre uno specchietto complessivo della saturazione
# di magazzino contando quante SKU (referenze) e quanti pezzi staziona ogni CeDi.
# ------------------------------------------------------------------------------

CREATE OR REPLACE VIEW v_WarehouseStatement AS
SELECT 
     W.WarehouseID          	AS MagazzinoID
    ,W.WarehouseName        	AS Magazzino
    ,COUNT(I.ProductID)     	AS ReferenzeDistinte
    ,SUM(I.QuantityInventory) 	AS TotalePezziStoccati
FROM Warehouse W
LEFT JOIN Inventory I       	ON W.WarehouseID = I.WarehouseID
GROUP BY W.WarehouseID, W.WarehouseName;

# Test della Vista 
SELECT * FROM v_WarehouseStatement;

# ------------------------------------------------------------------------------
# Identifica i prodotti campioni di incassi
# ------------------------------------------------------------------------------

SELECT 
     Prodotto
    ,Categoria
    ,SUM(QuantitaVenduta) 	AS PezziTotaliVenduti
    ,SUM(RicavoTotale) 		AS FatturatoGenerato
FROM v_ReportIncome
GROUP BY Prodotto, Categoria
ORDER BY FatturatoGenerato DESC;

# ------------------------------------------------------------------------------
# Calcola le performance di vendita territoriali
# ------------------------------------------------------------------------------

SELECT 
     Regione
    ,COUNT(DISTINCT NumeroScontrino) 	AS TotaleScontriniEmessi
    ,SUM(QuantitaVenduta) 				AS TotalePezziVenduti
    ,SUM(RicavoTotale) 					AS FatturatoRegionale
FROM v_ReportIncome
GROUP BY Regione
ORDER BY FatturatoRegionale DESC;

# ------------------------------------------------------------------------------
# Conteggio totale delle merci presenti nei Centri di Distribuzione
# ------------------------------------------------------------------------------

SELECT 
     W.WarehouseName 				AS CentroDistribuzione
    ,COUNT(DISTINCT I.ProductID) 	AS VarietaProdottiInStock
    ,SUM(I.QuantityInventory) 		AS VolumeMerciStoccate
FROM Inventory I
JOIN Warehouse W ON I.WarehouseID = W.WarehouseID
GROUP BY W.WarehouseID, W.WarehouseName
ORDER BY VolumeMerciStoccate DESC;

# ==============================================================================
# FINE SCRIPT SQL
# ==============================================================================