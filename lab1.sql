----- INSERTA AVIONES A UN MODELO ESPECIFICO
CREATE OR REPLACE FUNCTION insertarAviones(idModelo integer, cantAviones integer) RETURNS real AS $$
DECLARE
    horasVuelo integer;
    anio integer;
    idAvion integer;
BEGIN
    -- Itera para crear aviones asociados al modelo actual
    FOR j IN 1..cantAviones LOOP
        horasVuelo := FLOOR(RANDOM() * 4000) + 100; -- Genera horas entre 100 y 4099
		anio := FLOOR(RANDOM() * 2000) + 999;	-- Genera año entre 999 y 2998
        idAvion := (SELECT COALESCE(MAX("nroAvion"), 0) FROM avion) + 1; -- nuevo ID del avión
        INSERT INTO avion VALUES(idAvion, idModelo, anio, horasVuelo); -- Inserta el nuevo avión asociado al modelo actual
    END LOOP;
    RETURN cantAviones; -- Cantidad de aviones insertados
END;
$$ LANGUAGE plpgsql;

----- CARGA MASIVA
CREATE OR REPLACE FUNCTION cargaMasiva(cantModelos integer) RETURNS real AS $$
DECLARE
    cantAviones integer := 10000; -- Cantidad predeterminada de aviones por modelo
    descripcion_nueva VARCHAR(100);
    cantReg real := 0; -- Contador de registros insertados
    capacidad integer;
    idModelo integer;
BEGIN
    -- Itera para crear los modelos de avión y asociar aviones a cada modelo
    FOR i IN 1..cantModelos LOOP
        idModelo := (SELECT COALESCE(MAX("tipoModelo"), 0) FROM "modeloAvion") + 1; -- Nuevo ID del modelo de avión
        -- Descripción aleatoria y concatenar '1'
        descripcion_nueva := (SELECT CONCAT(TRIM(descripcion), '1') AS descripcion_concatenada FROM "modeloAvion" ORDER BY RANDOM() LIMIT 1);
        capacidad := FLOOR(RANDOM() * 4000) + 100; -- Capacidad aleatoria entre 100 y 4099
		INSERT INTO "modeloAvion" VALUES (idModelo, descripcion_nueva, capacidad);	-- Insertar el nuevo modelo de avión
        cantReg := cantReg + 1;
        cantReg := cantReg + insertarAviones(idModelo, cantAviones); -- Insertar aviones asociados al modelo actual
    END LOOP;

	RETURN cantReg;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar la función con 5 modelos
SELECT cargaMasiva(5);