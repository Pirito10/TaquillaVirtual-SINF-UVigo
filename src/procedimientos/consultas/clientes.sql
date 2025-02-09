DELIMITER //

DROP PROCEDURE IF EXISTS mostrarClientes;
CREATE PROCEDURE mostrarClientes()
BEGIN
    SELECT C.num_tarjeta AS 'Número de tarjeta'
    FROM Clientes C
    ORDER BY C.num_tarjeta;
END//

DELIMITER ;