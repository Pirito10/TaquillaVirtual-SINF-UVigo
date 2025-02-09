DELIMITER //

DROP PROCEDURE IF EXISTS eliminarEspectaculo;
CREATE PROCEDURE eliminarEspectaculo(
    IN titulo VARCHAR(40),
    IN tipo_espec VARCHAR(20),
    IN productor VARCHAR(40),
    IN direccion VARCHAR(40),
    IN fecha DATETIME
)
BEGIN
    DECLARE id_espectaculo INT;

    START TRANSACTION;
    
    SELECT Espectaculos.id INTO id_espectaculo
    FROM Espectaculos
    WHERE Espectaculos.titulo = titulo
    AND Espectaculos.tipo_espec = tipo_espec
    AND Espectaculos.productor = productor;
    
    DELETE FROM Cuesta WHERE Cuesta.id_espectaculo = id_espectaculo;

    DELETE FROM LocalidadesUsuarios WHERE LocalidadesUsuarios.id_espectaculo = id_espectaculo;

    DELETE FROM Ofertas WHERE Ofertas.id_espectaculo = id_espectaculo;

    DELETE FROM Permite WHERE Permite.id_espectaculo = id_espectaculo;

    DELETE FROM Ocupa WHERE Ocupa.id_localidad IN (
        SELECT Localidades.id
        FROM Localidades
        WHERE Localidades.id_espectaculo = id_espectaculo
    );

    DELETE FROM Localidades WHERE Localidades.id_espectaculo = id_espectaculo;

    DELETE FROM Recintos WHERE Recintos.direccion = direccion AND Recintos.fecha = fecha AND Recintos.id_espectaculo = id_espectaculo;

    DELETE FROM Espectaculos WHERE Espectaculos.id = id_espectaculo;

    DELETE FROM Clientes
    WHERE Clientes.num_tarjeta NOT IN (
        SELECT DISTINCT Localidades.num_tarjeta
        FROM Localidades
    );

    SELECT "Espectáculo eliminado con éxito" AS Mensaje;

    COMMIT;
END//

DELIMITER ;
