DROP DATABASE taquilla;
CREATE DATABASE taquilla;
USE taquilla;

CREATE TABLE Espectaculos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(40),
    tipo_espec VARCHAR(20),
    productor VARCHAR(40),
    limite_entradas INT,
	tiempo_reserva INT,
	tiempo_anulacion INT,
	penalizacion INT,
    UNIQUE (titulo, tipo_espec, productor)
);

CREATE TABLE Recintos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(40),
    fecha DATETIME,
    id_espectaculo INT NOT NULL,
    FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id),
    UNIQUE (direccion, fecha)
);

CREATE TABLE Clientes(
	num_tarjeta INT PRIMARY KEY
);

CREATE TABLE Localidades(
	id INT AUTO_INCREMENT PRIMARY KEY,
	ubicacion VARCHAR(20),
	grada VARCHAR(20),
	id_espectaculo INT NOT NULL,
    id_recinto INT NOT NULL,
    num_tarjeta INT,
	FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id),
	FOREIGN KEY (id_recinto) REFERENCES Recintos(id),
	FOREIGN KEY (num_tarjeta) REFERENCES Clientes(num_tarjeta),
	UNIQUE (ubicacion, grada, id_recinto)
);

CREATE TABLE Usuarios(
	tipo_usuario VARCHAR(10) PRIMARY KEY
);

CREATE TABLE Ocupa(
	tipo_usuario VARCHAR(10) NOT NULL,
	id_localidad INT NOT NULL,
	FOREIGN KEY (tipo_usuario) REFERENCES Usuarios(tipo_usuario),
	FOREIGN KEY (id_localidad) REFERENCES Localidades(id)
);


CREATE TABLE Permite(
	tipo_usuario VARCHAR(10) NOT NULL,
	id_espectaculo INT NOT NULL,
	FOREIGN KEY (tipo_usuario) REFERENCES Usuarios(tipo_usuario),
	FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id)
);

CREATE TABLE Ofertas(
	id_espectaculo INT NOT NULL,
	id_recinto INT NOT NULL,
	id_localidad INT NOT NULL,
	tipo_usuario VARCHAR(10) NOT NULL,
	num_tarjeta INT,
	FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id),
	FOREIGN KEY (id_recinto) REFERENCES Recintos(id),
	FOREIGN KEY (id_localidad) REFERENCES Localidades(id),
	FOREIGN KEY (tipo_usuario) REFERENCES Usuarios(tipo_usuario),
	FOREIGN KEY (num_tarjeta) REFERENCES Clientes(num_tarjeta)
);

CREATE TABLE LocalidadesUsuarios(
	id_espectaculo INT NOT NULL,
	id_recinto INT NOT NULL,
	id_localidad INT NOT NULL,
	tipo_usuario VARCHAR(10) NOT NULL,
	FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id),
	FOREIGN KEY (id_recinto) REFERENCES Recintos(id),
	FOREIGN KEY (id_localidad) REFERENCES Localidades(id),
	FOREIGN KEY (tipo_usuario) REFERENCES Usuarios(tipo_usuario)
);

CREATE TABLE Cuesta(
 	precio DECIMAL(5,2) NOT NULL,
	id_espectaculo INT NOT NULL,
	id_recinto INT NOT NULL,
	id_localidad INT NOT NULL,
	tipo_usuario VARCHAR(10) NOT NULL,
	FOREIGN KEY (id_espectaculo) REFERENCES Espectaculos(id),
	FOREIGN KEY (id_recinto) REFERENCES Recintos(id),
	FOREIGN KEY (id_localidad) REFERENCES Localidades(id),
	FOREIGN KEY (tipo_usuario) REFERENCES Usuarios (tipo_usuario)
);

CREATE TABLE Registro(
	num_tarjeta INT NOT NULL,
	accion VARCHAR(10) NOT NULL,
	id_espectaculo INT NOT NULL,
	fecha DATETIME NOT NULL
);