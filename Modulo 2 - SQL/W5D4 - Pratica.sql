#Prima devo creare il Database
CREATE DATABASE Nuovi_Prodotti;
#verifico che sia stato creato
SHOW databases;
USE Nuovi_Prodotti; #Dovrei usare il data base
#dovrei creare le tabelle per ogni entita forte e debole
#Prima entita forte
CREATE TABLE Cliente(
ClienteID INT AUTO_INCREMENT PRIMARY KEY, #creo la chiave primaria della prima tabella
Email VARCHAR (30) NOT NULL,
Città VARCHAR (30),
Indirizzo VARCHAR (30),
CAP VARCHAR (10),
Telefono VARCHAR (20),
CONSTRAINT PK_Cliente PRIMARY KEY (ClienteID) 
);
DESCRIBE Cliente;
#Seconda entita  forte
CREATE TABLE Prodotto(
ProdottoID INT AUTO_INCREMENT PRIMARY KEY, #creo la chiave primaria della seconda tabella
Nome VARCHAR (30) NOT NULL,
Prezzo DECIMAL (10,2) NOT NULL,
Categoria VARCHAR (50),
Quantità INT,
CONSTRAINT PK_Prodotto PRIMARY KEY (ProdottoID) 
);
DESCRIBE Prodotto;
#Terza entità forte
CREATE TABLE Spedizione(
SpedizioneID INT AUTO_INCREMENT PRIMARY KEY, # Creo la chiave primaria della terza tabella
Indirizzo VARCHAR (30),
Data_Consegna DATE NOT NULL,
Trasporto VARCHAR (30),
Stato VARCHAR (30),
Tracking Varchar (30),
Peso_Totale DECIMAL (10,2),
CONSTRAINT PK_Spedizione PRIMARY KEY (SpedizioneID)
);
DESCRIBE Spedizione;
#La entital devole, dipende da Cliente, Prodotto e spedizione
CREATE TABLE Ordine(
OrdineID INT AUTO_INCREMENT,
ODL VARCHAR (30),
Preventivo DECIMAL (10,2),
Data DATE NOT NULL,
Totale DECIMAL (10,2),
ClienteID INT NOT NULL,
ProdottoID INT NOT NULL,
SpedizioneID INT,
CONSTRAINT PK_Ordine PRIMARY KEY (OrdineID),
FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
FOREIGN KEY (ProdottoID) REFERENCES Prodotto(ProdottoID),
FOREIGN KEY (SpedizioneID) REFERENCES Spedizione(SpedizioneID)
);
DESCRIBE Ordine;

