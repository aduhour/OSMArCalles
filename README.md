# OSMArCalles

Calles de Argentina en OpenStreetMap. 

Repositorio de código y archivos relativos al análisis de nombres de calles y proyectos de Maproulette

# Abreviaturas
Construí un listado de abreviaturas existentes en la provincia de Buenos Aires y las utilicé para armar una consulta en todo el país y luego un desafío de maproulette para hacer la revisión. Detallo los pasos y comparto el código de R

- Consulta y descarga de calles de la Provincia de Buenos Aires en R.
- El listado de calles con etiqueta "highway=residential" incluye alrededor de 160 mil tramos con nombre.
- El listado se abrió en LibreOffice y se buscó en cada celda la posición del punto con la función =HALLAR(".";CELDA;1)
- Se ordenó de menor a mayor encontrando en los primeros lugares las calles con nombres abreviados.
- Tomando esta lista de abreviaturas, se construyó una consulta de overpass para buscar en Argentina las calles con cualquier etiqueta "highway=" que incluyeran alguna de ellas.
- Consulta: https://overpass-turbo.eu/s/19vl
- Desafío en MR para corregir las abreviaturas: https://maproulette.org/browse/challenges/20132
