-- ID FALLA
CREATE OR REPLACE FUNCTION seleccionarIdFalla() RETURNS text AS $$
DECLARE
    idFalla text;
BEGIN
    -- Seleccionar el tipoFalla
    SELECT "tipoFalla" INTO idFalla FROM "falla" ORDER BY RANDOM() LIMIT 1;
    
    RETURN idFalla;
END;
$$ LANGUAGE plpgsql;

-- DNI TRABAJADOR ALEATORIO
CREATE OR REPLACE FUNCTION seleccionarDNITrabajadorAleatorio() RETURNS text AS $$
DECLARE
    dniTrabajador text;
BEGIN
    -- Seleccionar un DNI de trabajador aleatorio
    SELECT "dni" INTO dniTrabajador FROM trabajador ORDER BY RANDOM() LIMIT 1;
    
    RETURN dniTrabajador;
END;
$$ LANGUAGE plpgsql;

-- INSERTA EL TRABAJADOR REPARACION
CREATE OR REPLACE FUNCTION insertarTrabajadorReparacion(idAvion integer) RETURNS VOID AS $$
DECLARE
    dniTrabajador integer;
	tipofalla_id integer;
BEGIN
    -- Seleccionar un DNI de trabajador aleatorio
    dniTrabajador := seleccionarDNITrabajadorAleatorio();
    tipofalla_id := seleccionarIdFalla();

	-- Insertar en la tabla "trabajadorReparacion"
    INSERT INTO "trabajadorReparacion" ("nroAvion", "dniTrabajador", "fechaInicioReparacion", "fechaFinReparacion", "tipoFallaReparada")
    VALUES (idAvion, dniTrabajador, CURRENT_DATE, CURRENT_DATE, tipofalla_id);
END;
$$ LANGUAGE plpgsql;

-- NUEVO ID
CREATE OR REPLACE FUNCTION obtenerNuevoIDAvion() RETURNS integer AS $$
DECLARE
    nuevoID integer;
BEGIN
    -- Obtener el nuevo ID del avión
    nuevoID := (SELECT COALESCE(MAX("nroAvion"), 0) FROM avion) + 1;
    RETURN nuevoID;
END;
$$ LANGUAGE plpgsql;

-- ANIO ALEATORIO
CREATE OR REPLACE FUNCTION generarAnioAleatorio() RETURNS integer AS $$
DECLARE
    anio integer;
BEGIN
    -- Generar un año aleatorio entre 999 y 2998
    anio := FLOOR(RANDOM() * 2000) + 999;
    RETURN anio;
END;
$$ LANGUAGE plpgsql;

-- HORAS ALEATORIAS
CREATE OR REPLACE FUNCTION generarHorasVueloAleatorias() RETURNS integer AS $$
DECLARE
    horasVuelo integer;
BEGIN
    -- Generar horas de vuelo aleatorias entre 100 y 4099
    horasVuelo := FLOOR(RANDOM() * 4000) + 100;
    RETURN horasVuelo;
END;
$$ LANGUAGE plpgsql;

-- Función para insertar aviones asociados a un modelo específico
CREATE OR REPLACE FUNCTION insertarAviones(idModelo integer, cantAviones integer) RETURNS real AS $$
DECLARE
    horasVuelo integer;
    anio integer;
    idAvion integer;
BEGIN
    -- Iteración para crear aviones asociados al modelo actual
    FOR j IN 1..cantAviones LOOP
    	horasVuelo := generarHorasVueloAleatorias();
        anio := generarAnioAleatorio();
		idAvion := obtenerNuevoIDAvion();
        -- inserta el avion asociado al modelo
		INSERT INTO avion VALUES(idAvion, idModelo, anio, horasVuelo);
		PERFORM insertarTrabajadorReparacion(idAvion);
    END LOOP;
    
    -- Devolver la cantidad de aviones insertados
    RETURN cantAviones;
END;
$$ LANGUAGE plpgsql;


-- NUEVO ID
CREATE OR REPLACE FUNCTION obtenerNuevoIDModelo() RETURNS integer AS $$
DECLARE
    nuevoID integer;
BEGIN
    -- Obtener el nuevo ID del modelo de avión
    nuevoID := (SELECT COALESCE(MAX("tipoModelo"), 0) FROM "modeloAvion") + 1;
    RETURN nuevoID;
END;
$$ LANGUAGE plpgsql;

-- DESCRIPCION ALEATORIA
CREATE OR REPLACE FUNCTION obtenerDescripcionAleatoria() RETURNS text AS $$
DECLARE
    descripcion_aux text;
BEGIN
	-- descripción aleatoria de la tabla modeloAvion de los primeros 3 registros
    SELECT descripcion INTO descripcion_aux FROM (
        SELECT descripcion FROM "modeloAvion" ORDER BY "tipoModelo" LIMIT 3
    ) AS subquery ORDER BY RANDOM() LIMIT 1;
    RETURN descripcion_aux;
END;
$$ LANGUAGE plpgsql;

-- CAPACIDAD ALEATORIA
CREATE OR REPLACE FUNCTION generarCapacidadAleatoria() RETURNS integer AS $$
DECLARE
    capacidad integer;
BEGIN
	-- capacidad aleatoria mayor o igual a 1000
    capacidad := FLOOR(RANDOM() * 3000) + 1000;
    RETURN capacidad;
END;
$$ LANGUAGE plpgsql;

-- FUNCION ENCARGADA DE LA CARGA MASIVA
CREATE OR REPLACE FUNCTION cargaMasiva(cantModelos integer) RETURNS real AS $$
DECLARE
	cantidad_avion CONSTANT integer := 10000;
    cantReg real := 0; -- Contador de registros insertados
    capacidad integer;
    idModelo integer;
	descripcion_nueva text;
BEGIN
    -- Iteración para crear los modelos de avión y asociar aviones a cada modelo
    FOR i IN 1..cantModelos LOOP
		capacidad := generarCapacidadAleatoria();
		descripcion_nueva := obtenerDescripcionAleatoria();
        idModelo := obtenerNuevoIDModelo();
        INSERT INTO "modeloAvion" VALUES (idModelo, descripcion_nueva || ' - ' ||idModelo, capacidad);
        cantReg := cantReg + 1;
		-- crea aviones asociados al modelo
        cantReg := cantReg + insertarAviones(idModelo, cantidad_avion);
    END LOOP;
    RETURN cantReg;
END;
$$ LANGUAGE plpgsql;

--------------------- PRINCIPAL -------------------------
-- Ejecutar la función con la cantidad de modelos a crear
SELECT cargaMasiva(1000);