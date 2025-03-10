DROP DATABASE IF EXISTS ReteteWebsite;
CREATE DATABASE ReteteWebsite;
USE ReteteWebsite;

-- Tabela Utilizatori
CREATE TABLE Utilizatori (
    ID_utilizator INT AUTO_INCREMENT PRIMARY KEY,
    Nume_utilizator VARCHAR(100) NOT NULL,
    Parola VARCHAR(255) NOT NULL
);

-- Tabela Retete
CREATE TABLE Retete (
    ID_reteta INT AUTO_INCREMENT PRIMARY KEY,
    Nume_reteta VARCHAR(255) NOT NULL,
    Descriere TEXT,
    Timp_preparare INT, -- În minute
    Unitate_timp VARCHAR(50)
);

-- Tabela Ingrediente
CREATE TABLE Ingrediente (
    ID_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    Nume_ingredient VARCHAR(100) NOT NULL
);

-- Tabela de legatura intre Retete si Ingrediente (relația M:N)
CREATE TABLE Retete_Ingrediente (
    ID_reteta INT, -- Legătura cu tabelul Retete
    ID_ingredient INT, -- Legătura cu tabelul Ingrediente
    Cantitate INT NOT NULL, 
    Unitate_masura VARCHAR(50) NOT NULL, 
    PRIMARY KEY (ID_reteta, ID_ingredient),
    FOREIGN KEY (ID_reteta) REFERENCES Retete(ID_reteta) ON DELETE CASCADE,
    FOREIGN KEY (ID_ingredient) REFERENCES Ingrediente(ID_ingredient) ON DELETE CASCADE
);


ALTER TABLE Retete_Ingrediente
ADD CONSTRAINT fk_ingredient
FOREIGN KEY (ID_ingredient) REFERENCES Ingrediente(Id_ingredient) ON DELETE CASCADE;

ALTER TABLE Retete_Ingrediente
ADD CONSTRAINT fk_recipe
FOREIGN KEY (ID_reteta) REFERENCES Retete(ID_reteta) ON DELETE CASCADE;

INSERT INTO Utilizatori (Nume_utilizator, Parola) VALUES ('Bardasu Emi', 'parola123');

INSERT INTO Retete (Nume_reteta, Descriere, Timp_preparare,Unitate_timp)
VALUES
    ('Prajitura cu mere', 'O prajitura simpla si gustoasa.', 6,	'minutes'),
    ('Supa de rosii', 'O supa racoritoare de vara.', 4, 'seconds'),
    ('Pui la cuptor', 'Pui fraged cu legume la cuptor.', 4, 'hours');

INSERT INTO Ingrediente (Nume_ingredient) VALUES ('Mere'),('Faina'),('Oua'),('Rosii'),('Piept de pui'),('Cartofi');

INSERT INTO Retete_Ingrediente (ID_reteta, ID_ingredient, Cantitate, Unitate_masura)
VALUES
    (1, 1, 4, 'buc'), 
    (1, 2, 200, 'g'), 
    (1, 3, 3, 'buc'), 
    (2, 4, 500, 'g'), 
    (3, 5, 2, 'buc'), 
    (3, 6, 4, 'buc'); 

SELECT r.Nume_reteta, i.Nume_ingredient, ri.Cantitate, ri.Unitate_masura FROM Retete r JOIN Retete_Ingrediente ri ON r.ID_reteta = ri.ID_reteta JOIN Ingrediente i ON ri.ID_ingredient = i.ID_ingredient;

DELIMITER //

CREATE PROCEDURE GetAllRecipes()
BEGIN
SELECT r.ID_reteta, r.Nume_reteta, r.Descriere, r.Timp_preparare, r.Unitate_timp,
       GROUP_CONCAT(CONCAT(i.Nume_ingredient, ' - ', ri.Cantitate, ' ', ri.Unitate_masura)) AS Ingredients
FROM Retete r
LEFT JOIN Retete_Ingrediente ri ON r.ID_reteta = ri.ID_reteta
LEFT JOIN Ingrediente i ON ri.ID_ingredient = i.ID_ingredient
GROUP BY r.ID_reteta;

END //
DELIMITER ;

