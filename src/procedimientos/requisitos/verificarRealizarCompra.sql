DELIMITER //

DROP PROCEDURE IF EXISTS verificarRealizarCompra;
CREATE PROCEDURE verificarRealizarCompra(
    IN id_espectaculo INT,
    OUT resultado BOOLEAN
)
BEGIN
    DECLARE tiempo_reserva INT;
    DECLARE minutos_para_inicio INT;

    SELECT Espectaculos.tiempo_reserva INTO tiempo_reserva
    FROM Espectaculos
    WHERE Espectaculos.id = id_espectaculo;

    SELECT TIMESTAMPDIFF(MINUTE, NOW(), Recintos.fecha) INTO minutos_para_inicio
    FROM Recintos
    WHERE Recintos.id_espectaculo = id_espectaculo
    AND Recintos.fecha > NOW()
    ORDER BY Recintos.fecha
    LIMIT 1;


    IF minutos_para_inicio < tiempo_reserva THEN
        SET resultado = FALSE;
    ELSE
        SET resultado = TRUE;
    END IF;
END //

DELIMITER ;