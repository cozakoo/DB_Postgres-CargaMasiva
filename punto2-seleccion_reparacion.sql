SELECT 
MA."descripcion" AS Modelo_Avion,
TR."nroAvion" AS Avion,
FA."descripcion" AS Falla,
TRA."nombre" AS Trabajador,
TR."fechaInicioReparacion" AS Fecha_inicio

FROM "modeloAvion"
	MA
JOIN "avion" AV 
ON AV."tipoModelo" = MA."tipoModelo"

JOIN "trabajadorReparacion" TR 
ON TR."nroAvion" = AV."nroAvion"

JOIN "falla" FA 
ON FA."tipoFalla" = TR."tipoFallaReparada"

JOIN "trabajador" TRA 
ON TRA."dni" = TR."dniTrabajador"
	
WHERE MA."capacidad" = 1158

ORDER BY 1, 2, 3
