# Base De Datos II
## PL/PGSQL, PROCESAMIENTO Y OPTIMIZACIÓN DE CONSULTAS

1. Agregar tuplas en forma masiva a las tablas modeloAvion y Avion de forma tal que 
por cada modeloAvion insertado se agreguen 10000 aviones y que la estadística 
V(capacidad, modeloAvion) >= 1000. Además por cada avión agregado agregar una 
reparación del mismo (con algún DNI de trabajador ya preexistente). Se debe 
presentar el script de la solucion.

2. Hacer una selección de las reparaciones para aviones cuya capacidad es = X (tomar 
para X un valor válido de los que se encuentren en su base de datos)

3. Analizar el plan de ejecución de la consulta del punto anterior. Documentar en su 
informe

4. Podría cambiar en algo el esquema físico de la base de datos de forma tal que se 
consiga algún plan de ejecución que acelere la consulta

5. Implementar el cambio propuesto en el punto 4

6. Volver a analizar la consulta del punto 2, viendo si el plan de ejecución cambió. 
Documentar el nuevo plan logrado y comparar con el anterior explicando los cambios 
encontrados
