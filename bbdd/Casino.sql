CREATE DATABASE IF NOT EXISTS Casino;

CREATE TABLE DatosUsuario(
DNI VARCHAR(10),
fechaNacimiento DATE,
Nombre VARCHAR(40),
Apellido VARCHAR(40),
Credito DOUBLE,
PRIMARY KEY(DNI)
);

CREATE TABLE Usuario(
id INT AUTO_INCREMENT DEFAULT 1,
DNI VARCHAR(10),
PRIMARY KEY(id),
FOREIGN KEY(DNI) REFERENCES DatosUsuario(DNI)
);

CREATE TABLE bannedUser(
id INT AUTO_INCREMENT,
Veto BOOLEAN,
Descripcion VARCHAR(255),
idUsuario INT,
PRIMARY KEY (id),
FOREIGN KEY(idUsuario)REFERENCES Usuario(id)
);

CREATE TABLE Juego(
id INT AUTO_INCREMENT,
nombre VARCHAR(20),
PRIMARY KEY(id)
);

CREATE TABLE Partida(
id INT AUTO_INCREMENT DEFAULT 1,
idJuego INT,
idUsuario INT,
apuesta FLOAT,
balance FLOAT,
fechaHora DATETIME,
PRIMARY KEY(id),
FOREIGN KEY(idJuego) REFERENCES Juego(id),
FOREIGN KEY(idUsuario) REFERENCES Usuario(id)
);

CREATE TABLE password(
idUsuario INT,
contrasenia VARCHAR(20),
PRIMARY KEY (idUsuario),
FOREIGN KEY (idUsuario)REFERENCES Usuario(id)
);

ALTER TABLE partida auto_increment = 1;

INSERT INTO juego (nombre) VALUES ('Black Jack'), ('Ruleta'),('Tragaperras');
INSERT INTO DatosUsuario VALUES ('12345678A', '1945-01-01', 'Invitado', 'Invitado');
INSERT INTO Usuario (premiumId, DNI) VALUES (1, '12345678A');
INSERT INTO banneduser (Veto,Descripcion, idUsuario) VALUES (false,'Hola', 1);
INSERT INTO password (idUsuario, contrasenia) VALUES (1, 'hola');

DELIMITER $$
CREATE PROCEDURE existe (IN dniP VARCHAR(10), OUT verify BOOL)
BEGIN
    SET verify = FALSE;
    SELECT TRUE INTO verify FROM usuario u WHERE u.DNI = dniP LIMIT 1;  
END
$$

CREATE PROCEDURE banCheck (IN id VARCHAR(10), OUT verify BOOL)
BEGIN
    SET verify = FALSE;
    SELECT TRUE INTO verify FROM bannedUser bu WHERE bu.idUsuario = id LIMIT 1;
END
$$

CREATE TRIGGER actualizarCredito AFTER INSERT ON partida FOR EACH ROW
	UPDATE datosusuario 
		SET Credito = credito - NEW.balance
        WHERE DNI = NEW.idUsuario;
$$

CREATE TRIGGER deleteUsuario AFTER DELETE ON usuario FOR EACH ROW
BEGIN
	DELETE FROM datosusuario
		WHERE DNI = OLD.DNI;
END
$$

DROP TRIGGER deleteUser $$
CREATE TRIGGER deleteUser BEFORE DELETE ON usuario FOR EACH ROW
BEGIN
	DELETE FROM password
    WHERE idUsuario = OLD.id;
END
$$





