DELIMITER //

DROP PROCEDURE IF EXISTS mostrarRecintos;
CREATE PROCEDURE mostrarRecintos()
BEGIN
    SELECT DISTINCT R.direccion AS 'Recinto'
    FROM Recintos R
    ORDER BY R.direccion;
END//

DELIMITER ;