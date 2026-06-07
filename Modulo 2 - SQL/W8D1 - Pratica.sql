Create database Epicode_Esercitazioni;
use Epicode_Esercitazioni;

# Region e una entita forte 
CREATE TABLE Region (
	RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR (50),
    City VARCHAR (50),
    AreaGeografica VARCHAR (50)
    );
    
# Store e una entita debole
CREATE TABLE Store (
	StoreID INT AUTO_INCREMENT PRIMARY KEY,
    RegionID INT,
    StoreName VARCHAR(50),
    DataApertura DATE NOT NULL,
	FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

# Popolazionde delle tabelle
INSERT INTO Region (RegionName, City, AreaGeografica) 
VALUES
	('Lombardia',  'Milano',  'Nord'),
	('Piemonte',   'Torino',  'Nord'),
	('Lazio',      'Roma',    'Centro'),
	('Campania',   'Napoli',  'Sud');

INSERT INTO Store (RegionID, StoreName, DataApertura) 
VALUES
	(1, 'Store Milano Centro', '2020-03-15'),
	(2, 'Store Torino Sud',    '2019-06-01'),
	(3, 'Store Roma Est',      '2021-11-20'),
	(4, 'Store Napoli Nord',   '2022-01-10'),
	(1, 'Store Milano Nord',   '2023-05-05');

# MODIFICA

# Cambio il nome delle colomne della tabella Store 
SELECT * FROM Store;
UPDATE Store
SET StoreName = 'StoreMilanoCentrale'
WHERE StoreID = 1;
UPDATE Store
SET StoreName = 'StoreMilanoSud'
WHERE StoreID = 2;
UPDATE Store
SET StoreName = 'StoreMilanoEst'
WHERE StoreID = 3;
UPDATE Store
SET StoreName = 'StoreMilanoNord'
WHERE StoreID = 4;
UPDATE Store
SET StoreName = 'StoreMilanoCentrale'
WHERE StoreID = 5;
# Cambio il area geografica di una colomna della tabella Region
SELECT * FROM Region;
UPDATE Region
SET AreaGeografica = 'NordOvest'
WHERE RegionID = 1;

# DELETE

# Voglio eliminare un Store
SELECT * FROM Store;
DELETE FROM Store
WHERE StoreID = 5;
# Voglio eliminare una regione 
SELECT * FROM Region;
# Non potevo eliminare la Region directamente per cio prima debo eliminare gli store collegate 
# Cancelazione Store della Region
DELETE FROM Store  
WHERE RegionID = 4;
# Cancelazione della Region
DELETE FROM Region 
WHERE RegionID = 4;

#Operazione INSERT

SELECT * FROM Store;
SELECT * FROM Region;
INSERT INTO Store (RegionID, StoreName, DataApertura) 
VALUES
	(1, 'StoreMilanoCentrale', '2022-12-21'); #DELETE  FROM Store WHERE StoreID = 7; Per svaglio avvevo duplicato una riga 
INSERT INTO Region (RegionName, City, AreaGeografica) 
VALUES
	('Lombardia', 'Milano', 'Est');

#Operazioni UPDATE

SELECT * FROM Store;
SELECT * FROM Region;
UPDATE Store 
SET StoreName = 'StoreMilanoCentrale' 
WHERE StoreID = 1;
UPDATE Region 
SET AreaGeografica = 'Est' WHERE RegionID = 2;

START TRANSACTION;
# Cancelazione di un store 
DELETE FROM Store
WHERE StoreID = 3;
# Per cancelare una Region ci serve prima cancelare un store
DELETE FROM Store
WHERE RegionID = 2;
DELETE FROM Region
WHERE RegionID = 2;
SELECT * FROM Store;
SELECT * FROM Region;
ROLLBACK;




