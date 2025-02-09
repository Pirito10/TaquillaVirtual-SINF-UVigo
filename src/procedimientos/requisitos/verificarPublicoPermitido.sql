DELIMITER //

DROP PROCEDURE IF EXISTS verificarPublicoPermitido;
CREATE PROCEDURE verificarPublicoPermitido(
    IN id_espectaculo INT,
    IN tipo_publico VARCHAR(10),
    OUT resultado BOOLEAN
)
BEGIN
    DECLARE usuario_permitido BOOLEAN;

    SELECT EXISTS(
        SELECT 1
        FROM Permite
        WHERE Permite.tipo_usuario = tipo_publico AND Permite.id_espectaculo = id_espectaculo
    ) INTO usuario_permitido;

    SET resultado = usuario_permitido;
END //

DELIMITER ;