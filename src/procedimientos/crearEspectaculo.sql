DELIMITER //

DROP PROCEDURE IF EXISTS crearEspectaculo;
CREATE PROCEDURE crearEspectaculo(
    IN titulo VARCHAR(40),
    IN tipo_espec VARCHAR(20),
    IN productor VARCHAR(40),
    IN limite_entradas INT,
    IN tiempo_reserva INT,
    IN tiempo_anulacion INT,
    IN penalizacion INT,
    IN direccion_recinto VARCHAR(40),
    IN fecha_recinto DATETIME,
    IN num_gradas INT,
    IN num_localidades_por_grada INT,
    IN tipo_usuario VARCHAR(10),
    IN precio DECIMAL(5,2)
)
BEGIN
    DECLARE id_espectaculo INT;
    DECLARE id_recinto INT;
    DECLARE grada_actual INT;
    DECLARE localidad_actual INT;

    START TRANSACTION;

    INSERT INTO Espectaculos(titulo, tipo_espec, productor, limite_entradas, tiempo_reserva, tiempo_anulacion, penalizacion)
    VALUES (titulo, tipo_espec, productor, limite_entradas, tiempo_reserva, tiempo_anulacion, penalizacion);
    SET id_espectaculo = LAST_INSERT_ID();

    INSERT INTO Recintos(direccion, fecha, id_espectaculo)
    VALUES (direccion_recinto, fecha_recinto, id_espectaculo);
    SET id_recinto = LAST_INSERT_ID();

    SET grada_actual = 1;
    SET localidad_actual = 1;

    WHILE grada_actual <= num_gradas DO
        WHILE localidad_actual <= num_localidades_por_grada DO
            INSERT INTO Localidades(ubicacion, grada, id_espectaculo, id_recinto)
            VALUES (CONCAT('A', localidad_actual), CONCAT('Grada ', grada_actual), id_espectaculo, id_recinto);

            INSERT INTO Cuesta(precio, id_espectaculo, id_recinto, id_localidad, tipo_usuario)
            VALUES (precio, id_espectaculo, id_recinto, LAST_INSERT_ID(), tipo_usuario);

            SET localidad_actual = localidad_actual + 1;
        END WHILE;

        SET localidad_actual = 1;
        SET grada_actual = grada_actual + 1;
    END WHILE;

    INSERT INTO Permite(tipo_usuario, id_espectaculo)
    VALUES (tipo_usuario, id_espectaculo)
    ON DUPLICATE KEY UPDATE id_espectaculo = id_espectaculo;

    INSERT INTO Ofertas(id_espectaculo, id_recinto, id_localidad, tipo_usuario, num_tarjeta)
    SELECT id_espectaculo, id_recinto, id, tipo_usuario, NULL
    FROM Localidades
    WHERE Localidades.id_espectaculo = id_espectaculo;

    INSERT INTO LocalidadesUsuarios(id_espectaculo, id_recinto, id_localidad, tipo_usuario)
    SELECT id_espectaculo, id_recinto, id, tipo_usuario
    FROM Localidades
    WHERE Localidades.id_espectaculo = id_espectaculo;

    SELECT "Espectáculo creado con éxito" AS Mensaje;

    COMMIT;
END //

DELIMITER ;