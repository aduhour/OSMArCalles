# OSMArCalles

Calles de Argentina en OpenStreetMap. #Kaart

Repositorio de código y archivos relativos al análisis de nombres de calles y proyectos de Maproulette

# Abreviaturas
- Consulta y descarga de calles de la Provincia de Buenos Aires.
- El listado de calles con etiqueta "highway=residential" incluye alrededor de 160 mil tramos con nombre.
- El listado se abrió en LibreOffice y se buscó en cada celda la posición del punto con la función =HALLAR(".";CELDA;1)
- Se ordenó de menor a mayor encontrnado en los primeros lugares las calles con nombres abreviados.
- Se construyó una consulta de overpass para buscar en Argentina las calles con cualquier etiqueta "highway=" que incluyeran alguna de las abreviaturas.
- Consulta: https://overpass-turbo.eu/s/19vl
