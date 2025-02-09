DELIMITER //

DROP PROCEDURE IF EXISTS verificarPenalizacion;
CREATE PROCEDURE verificarPenalizacion(
    IN id_localidad INT,
    OUT penalizacion DECIMAL(5, 2)
)
BEGIN
    SELECT 
        IF(TIMESTAMPDIFF(MINUTE, NOW(), R.fecha) > E.tiempo_anulacion, 0.00, C.precio * E.penalizacion / 100)
    INTO penalizacion
    FROM Ofertas O
    JOIN Recintos R ON O.id_recinto = R.id
    JOIN Espectaculos E ON O.id_espectaculo = E.id
    JOIN Localidades L ON O.id_localidad = L.id
    JOIN Cuesta C ON O.id_localidad = C.id_localidad
    WHERE O.id_localidad = id_localidad
    LIMIT 1;
END //

DELIMITER ;