CREATE OR REPLACE FUNCTION cargaMasiva(cantModelos integer ) RETURNS real AS $$
<< outerblock >>
DECLARE
	cantAviones integer : 10000; 
	descripcion VARCHAR(100);
	cantReg real := 0;
	capacidad integer;
	idModelo integer;
BEGIN
    
	FOR i IN 1..canModelos LOOP

		   --obtengo un nuevo id
           idModelo = (SELECT MAX("tipoModelo") FROM "modeloAvion") + 1
		   
		   --seleccion un descripcion ramdon y le concateno 1
		   descripcion = (SELECT CONCAT(TRIM(descripcion), '1') AS descripcion_concatenada FROM "modeloAvion" ORDER BY RANDOM()
                         LIMIT 1)  		   
		   
		   --obtiene un valor de 3 digitos entero random
		   capacidad = SELECT FLOOR(RANDOM() * 4000) + 100 
		   
		   --inserto modeloAvion
		   INSERT INTO "modeloAvion" VALUES (idModelo,descipcion,capacidad)
		   
		   cantReg := cantReg + 1;
           FOR i IN 1..cantAviones LOOP
		     horasVuelo = SELECT FLOOR(RANDOM() * 4000) + 100
			 anio = SELECT FLOOR(RANDOM() * 2000) + 999
		     idAvion = (SELECT MAX("nroAvion") FROM avion) + 1
		     INSERT INTO avion VALUES(idAvion, idModelo, año )
		        
		   END LOOP;
		   cantReg := cantReg + cantAviones;
	END LOOP; 
	  
    RETURN cantReg;
END;
$$ LANGUAGE plpgsql;