# OSMArCalles

Calles de Argentina en OpenStreetMap. 

Repositorio de código y archivos relativos al análisis de nombres de calles y proyectos de Maproulette

# Concordancia de etiquetas addr:street y nombres de calle

- Fuente: Descargando errores detectados en: http://osmose.openstreetmap.fr/en/issues/open, seleccionando la provincia, el ítem 2060 - Street numbers, Severity: Normal or higher, guardar en formato geojson full. 

- Proyecto: https://maproulette.org/browse/projects/48589

# Abreviaturas
Construí un listado de abreviaturas existentes en la provincia de Buenos Aires y las utilicé para armar una consulta en todo el país y luego un desafío de maproulette para hacer la revisión. Detallo los pasos y comparto el código de R

- Consulta y descarga de calles de la Provincia de Buenos Aires en R.
- El listado de calles con etiqueta "highway=residential" incluye alrededor de 160 mil tramos con nombre.
- El listado se abrió en LibreOffice y se buscó en cada celda la posición del punto con la función =HALLAR(".";CELDA;1)
- Se ordenó de menor a mayor encontrando en los primeros lugares las calles con nombres abreviados.
- Tomando esta lista de abreviaturas, se construyó una consulta de overpass para buscar en Argentina las calles con cualquier etiqueta "highway=" que incluyeran alguna de ellas.
- Consulta: https://overpass-turbo.eu/s/19vl
- Desafío en MR para corregir las abreviaturas (finalizado): https://maproulette.org/browse/challenges/20132

- Sobre esta base y la revisión en el país se armó un listado de abreviaturas para revisar por provincia.
- Construí un script en R que busca calles que tienen un punto en su primer palabra y además que tienen alguna de las abreviaturas sin punto y sin distinción de mayúsculas.
- Guardo el resultado en un archivo geojson que se puede cargar en maproulette y un mapa interactivo para ver por provincia.
- Desafío para corregir abreviaturas en todo el país. Las tareas que restan requieren conocimiento local: https://maproulette.org/challenge/26817
- 1 de Mayo y otros ordinales: Con este desafío se busca corregir abreviaturas de ordinales como por ejemplo "1° de Mayo" https://maproulette.org/challenge/27387

# Nombres de provincia

Construí una consulta que busca en calles con nombre de las provincias de Córdoba, Entre Ríos, Neuquén, Río Negro, Santa Fe y Tucumán la falta de acentuación o el agregado de acentos incorrectos

- Consulta: https://overpass-turbo.eu/s/19BL
- Desafío en MR para corregir estos errores: https://maproulette.org/browse/challenges/19972

# Calles con la etiqueta addr:street=*
- Consulta: https://overpass-turbo.eu/s/1aBE

# Calles con la etiqueta ele=*
La etiqueta refiere a la altura sobre el nivel del mar y se encuentran usos como numeración de las calles.
- Consulta: https://overpass-turbo.eu/s/1bX8
