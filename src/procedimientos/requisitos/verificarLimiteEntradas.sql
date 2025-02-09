DELIMITER //

DROP PROCEDURE IF EXISTS verificarLimiteEntradas;
CREATE PROCEDURE verificarLimiteEntradas(
    IN id_espectaculo INT,
    IN num_tarjeta INT,
    OUT resultado BOOLEAN
)
BEGIN
    SELECT COUNT(*) < Espectaculos.limite_entradas INTO resultado
    FROM Localidades
    JOIN Espectaculos ON Localidades.id_espectaculo = Espectaculos.id
    WHERE Localidades.id_espectaculo = id_espectaculo AND Localidades.num_tarjeta = num_tarjeta
    GROUP BY Espectaculos.limite_entradas;    
END //
DELIMITER ;
