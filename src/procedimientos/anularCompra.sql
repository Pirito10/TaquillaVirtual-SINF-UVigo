DELIMITER //

DROP PROCEDURE IF EXISTS anularCompra;
CREATE PROCEDURE anularCompra(
    IN num_tarjeta INT,
    IN titulo VARCHAR(40),
    IN tipo VARCHAR(20),
    IN productor VARCHAR(40),
    IN direccion VARCHAR(40),
    IN fecha DATETIME,
    IN grada VARCHAR(20),
    IN ubicacion VARCHAR(20)
)
BEGIN
    DECLARE id_localidad INT;
    DECLARE id_espectaculo INT;
    DECLARE puede_anular BOOLEAN;
    DECLARE limite_anulaciones BOOLEAN;
    DECLARE penalizacion BOOLEAN;
    DECLARE num_localidades INT;

    START TRANSACTION;

    SELECT L.id, E.id INTO id_localidad, id_espectaculo
    FROM Localidades L
    JOIN Recintos R ON L.id_recinto = R.id
    JOIN Espectaculos E ON L.id_espectaculo = E.id
    WHERE E.titulo = titulo
    AND E.tipo_espec = tipo
    AND E.productor = productor
    AND R.direccion = direccion
    AND R.fecha = fecha
    AND L.grada = grada
    AND L.ubicacion = ubicacion;

    CALL verificarAnularCompra(id_localidad, num_tarjeta, puede_anular);
    CALL verificarLimiteAnulaciones(id_localidad, num_tarjeta, limite_anulaciones);

    IF puede_anular IS NULL THEN
        SET puede_anular = FALSE;
    END IF;

    IF puede_anular AND limite_anulaciones THEN
        CALL verificarPenalizacion(id_localidad, penalizacion);

        UPDATE Localidades
        SET Localidades.num_tarjeta = NULL
        WHERE Localidades.id = id_localidad;

        UPDATE Ofertas
        SET Ofertas.num_tarjeta = NULL
        WHERE Ofertas.id_localidad = id_localidad;

        SELECT COUNT(*) INTO num_localidades
        FROM Localidades
        WHERE Localidades.num_tarjeta = num_tarjeta;

        IF num_localidades = 0 THEN
            DELETE FROM Clientes
            WHERE Clientes.num_tarjeta = num_tarjeta;
        END IF;

        INSERT INTO Registro(num_tarjeta, accion, id_espectaculo, fecha)
        VALUES (num_tarjeta, 'anulacion', id_espectaculo, NOW());

        IF penalizacion > 0 THEN
            SELECT "Se ha anulado la compra con una penalización de " AS Mensaje, penalizacion, "€" AS Mensaje;
        ELSE
            SELECT "Se ha anulado la compra sin penalización" AS Mensaje;
        END IF;
    ELSE
        IF NOT puede_anular THEN
            SELECT "Esa entrada no te pertenece";
        END IF;
        IF NOT limite_anulaciones THEN
            SELECT "Ya no puedes anular más";
        END IF;
    END IF;

    COMMIT;
END //

DELIMITER ;