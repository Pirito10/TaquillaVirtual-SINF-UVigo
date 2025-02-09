DELIMITER //

DROP PROCEDURE IF EXISTS verificarLimiteAnulaciones;
CREATE PROCEDURE verificarLimiteAnulaciones(
    IN id_localidad INT,
    IN num_tarjeta INT,
    OUT resultado BOOLEAN
)
BEGIN
    DECLARE anulaciones INT;
    DECLARE limite_anulaciones INT;

    SELECT COUNT(*) INTO anulaciones
    FROM Registro
    JOIN Localidades ON Registro.id_espectaculo = Localidades.id_espectaculo
    WHERE Localidades.id = id_localidad AND Registro.num_tarjeta = num_tarjeta AND Registro.accion = "anulacion"; 

    SELECT limite_entradas INTO limite_anulaciones
    FROM Espectaculos
    JOIN Localidades ON Localidades.id_espectaculo = Espectaculos.id
    WHERE Localidades.id = id_localidad;

    IF anulaciones > limite_anulaciones * 2 THEN
        SET resultado = FALSE;
    ELSE
        SET resultado = TRUE;
    END IF;
END //

DELIMITER ;