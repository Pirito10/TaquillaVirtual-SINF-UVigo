DELIMITER //

DROP PROCEDURE IF EXISTS realizarCompra;
CREATE PROCEDURE realizarCompra(
    IN num_tarjeta INT,
    IN titulo VARCHAR(40),
    IN tipo VARCHAR(20),
    IN productor VARCHAR(40),
    IN direccion VARCHAR(40),
    IN fecha DATETIME,
    IN tipo_usuario VARCHAR(10),
    IN grada VARCHAR(20),
    IN ubicacion VARCHAR(20)    
)
realizarCompra: BEGIN
    DECLARE id_espectaculo INT;
    DECLARE id_localidad INT;
    DECLARE cliente_existente BOOLEAN;
    DECLARE publico_permitido BOOLEAN;
    DECLARE limite_tiempo BOOLEAN;
    DECLARE limite_entradas_permitido BOOLEAN;

    START TRANSACTION;

    SELECT Espectaculos.id INTO id_espectaculo
    FROM Espectaculos
    WHERE Espectaculos.titulo = titulo AND Espectaculos.tipo_espec = tipo AND Espectaculos.productor = productor;

    CALL verificarRealizarCompra(id_espectaculo, limite_tiempo);
    IF NOT limite_tiempo THEN
        SELECT "Ya no se pueden realizar compras para este espectáculo" AS Mensaje;
        LEAVE realizarCompra;
    END IF;

    CALL verificarPublicoPermitido(id_espectaculo, tipo_usuario, publico_permitido);
    IF NOT publico_permitido THEN
        SELECT "Ese tipo de público no está permitido para ese espectáculo" AS Mensaje;
        LEAVE realizarCompra;
    END IF;

    SELECT EXISTS(
        SELECT 1
        FROM Clientes
        WHERE Clientes.num_tarjeta = num_tarjeta
    ) INTO cliente_existente;

    IF cliente_existente THEN
        CALL verificarLimiteEntradas(id_espectaculo, num_tarjeta, limite_entradas_permitido);
        IF NOT limite_entradas_permitido THEN
            SELECT "Ya tienes el máximo número de entradas permitidas para ese espectáculo" AS Mensaje;
            LEAVE realizarCompra;
        END IF;
    ELSE
        INSERT INTO Clientes(num_tarjeta) VALUES (num_tarjeta);
    END IF;

    SELECT Localidades.id INTO id_localidad
    FROM Localidades
    WHERE Localidades.ubicacion = ubicacion AND Localidades.grada = grada AND Localidades.id_espectaculo = id_espectaculo;

    UPDATE Localidades
    SET Localidades.num_tarjeta = num_tarjeta
    WHERE Localidades.id = id_localidad;

    UPDATE Ofertas
    SET Ofertas.num_tarjeta = num_tarjeta
    WHERE Ofertas.id_localidad = id_localidad;

    INSERT INTO Registro(num_tarjeta, accion, id_espectaculo, fecha)
    VALUES (num_tarjeta, 'compra', id_espectaculo, NOW());

    SELECT "Compra realizada con éxito" AS Mensaje;

    COMMIT;
END //

DELIMITER ;