DELIMITER //

DROP PROCEDURE IF EXISTS mostrarLocalidadesPorCliente;
CREATE PROCEDURE mostrarLocalidadesPorCliente(IN numero_tarjeta INT)
BEGIN
    SELECT E.titulo AS 'Título', R.direccion AS 'Dirección', R.fecha AS 'Fecha', L.grada AS 'Grada', L.ubicacion AS 'Ubicación', O.tipo_usuario AS 'Tipo de Usuario', C.precio AS 'Precio de la entrada'
    FROM Ofertas O
    JOIN Localidades L ON O.id_localidad = L.id
    JOIN Recintos R ON O.id_recinto = R.id
    JOIN Espectaculos E ON O.id_espectaculo = E.id
    JOIN Cuesta C ON O.id_espectaculo = C.id_espectaculo AND O.id_recinto = C.id_recinto AND O.id_localidad = C.id_localidad AND O.tipo_usuario = C.tipo_usuario
    WHERE O.num_tarjeta = numero_tarjeta
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarLocalidadesPorEspectaculo;
CREATE PROCEDURE mostrarLocalidadesPorEspectaculo(IN titulo VARCHAR(40), IN tipo_espec VARCHAR(20), IN productor VARCHAR(40), IN direccion_recinto VARCHAR(40), IN fecha DATETIME)
BEGIN
    SELECT L.ubicacion AS 'Ubicación', L.grada AS 'Grada', C.precio AS 'Precio de la entrada'
    FROM Localidades L
    JOIN Cuesta C ON L.id_espectaculo = C.id_espectaculo AND L.id_recinto = C.id_recinto AND L.id = C.id_localidad
    JOIN Espectaculos E ON L.id_espectaculo = E.id
    JOIN Recintos R ON E.id = R.id_espectaculo
    WHERE E.titulo = titulo AND E.tipo_espec = tipo_espec AND E.productor = productor AND R.direccion = direccion_recinto AND R.fecha = fecha;
END//

DROP PROCEDURE IF EXISTS mostrarLocalidadesDisponiblesPorEspectaculo;
CREATE PROCEDURE mostrarLocalidadesDisponiblesPorEspectaculo(IN titulo VARCHAR(40), IN tipo_espec VARCHAR(20), IN productor VARCHAR(40), IN direccion_recinto VARCHAR(40), IN fecha DATETIME)
BEGIN
    SELECT L.ubicacion AS 'Ubicación', L.grada AS 'Grada', C.precio AS 'Precio de la entrada'
    FROM Localidades L
    JOIN Cuesta C ON L.id_espectaculo = C.id_espectaculo AND L.id_recinto = C.id_recinto AND L.id = C.id_localidad
    JOIN Espectaculos E ON L.id_espectaculo = E.id
    JOIN Recintos R ON E.id = R.id_espectaculo
    WHERE E.titulo = titulo AND E.tipo_espec = tipo_espec AND E.productor = productor AND R.direccion = direccion_recinto AND R.fecha = fecha AND L.num_tarjeta IS NULL;
END//

DROP PROCEDURE IF EXISTS mostrarLocalidadesNoDisponiblesPorEspectaculo;
CREATE PROCEDURE mostrarLocalidadesNoDisponiblesPorEspectaculo(IN titulo VARCHAR(40), IN tipo_espec VARCHAR(20), IN productor VARCHAR(40), IN direccion_recinto VARCHAR(40), IN fecha DATETIME)
BEGIN
    SELECT L.ubicacion AS 'Ubicación', L.grada AS 'Grada', C.precio AS 'Precio de la entrada', L.num_tarjeta AS 'Cliente'
    FROM Localidades L
    JOIN Cuesta C ON L.id_espectaculo = C.id_espectaculo AND L.id_recinto = C.id_recinto AND L.id = C.id_localidad
    JOIN Espectaculos E ON L.id_espectaculo = E.id
    JOIN Recintos R ON E.id = R.id_espectaculo
    WHERE E.titulo = titulo AND E.tipo_espec = tipo_espec AND E.productor = productor AND R.direccion = direccion_recinto AND R.fecha = fecha AND L.num_tarjeta IS NOT NULL;
END//

DELIMITER ;