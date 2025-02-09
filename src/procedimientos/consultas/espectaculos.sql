DELIMITER //

DROP PROCEDURE IF EXISTS mostrarEspectaculosDisponibles;
CREATE PROCEDURE mostrarEspectaculosDisponibles()
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE R.fecha > NOW()
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosFinalizados;
CREATE PROCEDURE mostrarEspectaculosFinalizados()
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE R.fecha <= NOW()
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorTitulo;
CREATE PROCEDURE mostrarEspectaculosPorTitulo(IN titulo_espectaculo VARCHAR(40))
BEGIN
    SELECT E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE E.titulo = titulo_espectaculo
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorTipo;
CREATE PROCEDURE mostrarEspectaculosPorTipo(IN tipo_espectaculo VARCHAR(20))
BEGIN
    SELECT E.titulo AS 'Título', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE E.tipo_espec = tipo_espectaculo
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorProductor;
CREATE PROCEDURE mostrarEspectaculosPorProductor(IN nombre_productor VARCHAR(40))
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE E.productor = nombre_productor
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorRecinto;
CREATE PROCEDURE mostrarEspectaculosPorRecinto(IN direccion_recinto VARCHAR(40))
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE R.direccion = direccion_recinto
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorFecha;
CREATE PROCEDURE mostrarEspectaculosPorFecha(IN fecha_consulta DATE)
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE DATE(R.fecha) = fecha_consulta
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosEntreFechas;
CREATE PROCEDURE mostrarEspectaculosEntreFechas(IN fecha_inicio DATETIME, IN fecha_fin DATETIME)
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', GROUP_CONCAT(P.tipo_usuario SEPARATOR ', ') AS 'Público permitido', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE R.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY E.id, E.titulo, E.tipo_espec, E.productor, R.direccion, R.fecha, E.limite_entradas
    ORDER BY R.fecha;
END//

DROP PROCEDURE IF EXISTS mostrarEspectaculosPorTipoUsuario;
CREATE PROCEDURE mostrarEspectaculosPorTipoUsuario(IN tipo_usuario VARCHAR(10))
BEGIN
    SELECT E.titulo AS 'Título', E.tipo_espec AS 'Tipo', E.productor AS 'Productor', R.direccion AS 'Recinto', R.fecha AS 'Fecha y hora', E.limite_entradas AS 'Límite entradas'
    FROM Espectaculos E
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Permite P ON E.id = P.id_espectaculo
    WHERE P.tipo_usuario = tipo_usuario
    ORDER BY R.fecha;
END//   

DROP PROCEDURE IF EXISTS mostrarBeneficiosEspectaculo;
CREATE PROCEDURE mostrarBeneficiosEspectaculo(IN titulo VARCHAR(40), IN tipo VARCHAR(20), IN productor VARCHAR(40), IN direccion VARCHAR(40), IN fecha DATETIME)
BEGIN
    SELECT SUM(C.precio) AS 'Beneficios'
    FROM Cuesta C
    JOIN Espectaculos E ON C.id_espectaculo = E.id
    JOIN Recintos R ON E.id = R.id_espectaculo
    JOIN Localidades L ON C.id_localidad = L.id
    WHERE E.titulo = titulo AND E.tipo_espec = tipo AND E.productor = productor AND R.direccion = direccion AND R.fecha = fecha AND L.num_tarjeta IS NOT NULL;
END//

DELIMITER ;