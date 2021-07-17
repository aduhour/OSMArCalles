##

##  Analizar nombres de calles en argentina

library(dplyr)
library(tidyr)
library(sf)
library(osmdata)
library(magrittr)

## Obtener el polígono del área a consultar
poligono <- getbb("Buenos Aires", featuretype = "state", format_out = "polygon" )
recuadro <- getbb("Buenos Aires",featuretype = "state")

## Guardar todas las calles etiquetadas como highway residential en el recuadro
## seleccionado

calles <- opq(bbox = recuadro) %>%
          add_osm_feature(key = "highway", 
                          value = "residential") %>%
  osmdata_sf()

# Seleccionar el límite provincial
# Obtiene los límites de todas las provincia que limitan con la de Bs As 
# incluyendo parte de Uruguay

limitebsas <- opq(bbox = recuadro) %>%
              add_osm_feature(key = "admin_level", value = "4") %>%
  osmdata_sf()

## Seleccionar las columnas del nombre y el id de OSM del objeto
calles <- calles$osm_lines %>%
          select(name,osm_id)

limitebsas_linea <- limitebsas$osm_lines %>%
                    select(osm_id)

# Establecer el sistema de referencia (aseguramos que todos los 'simple
# features' tienen el mismo)

st_crs(calles) <- 4326
st_crs(limitebsas_linea) <- 4326


# Grafico de las calles. El procedimiento es lento para la provincia de Buenos Aires
# por el gran número de calles.

plot(calles)

# Gráfico del límite provincial

plot(limitebsas_linea)

# Crea un vector con los nombres de calle existentes  
nombres <- calles$name
  
# Lo escribe en un archivo csv.

write.csv(nombres,file = "nombres.csv")


