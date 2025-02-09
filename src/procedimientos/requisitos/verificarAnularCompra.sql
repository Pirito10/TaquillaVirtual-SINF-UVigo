DELIMITER //

DROP PROCEDURE IF EXISTS verificarAnularCompra;
CREATE PROCEDURE verificarAnularCompra(
    IN id_localidad INT,
    IN num_tarjeta INT,
    OUT resultado BOOLEAN
)
BEGIN
    SELECT COUNT(*) > 0 AND Recintos.fecha > NOW() INTO resultado
    FROM Localidades
    JOIN Recintos ON Localidades.id_recinto = Recintos.id
    WHERE Localidades.id = id_localidad AND Localidades.num_tarjeta = num_tarjeta
    GROUP BY Recintos.fecha;
END //

DELIMITER ;