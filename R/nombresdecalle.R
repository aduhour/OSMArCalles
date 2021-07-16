##

##  Analizar nombres de calles en argentina

library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)
library(osmdata)
library(units)
library(mapview)
library(ggmap)
library(ggspatial)
library(tmap)
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


## Seleccionar las columnas del nombre y el id de OSM del objeto
calles <- calles$osm_lines %>%
          select(name,osm_id)

# Establecer el sistema de referencia (aseguramos que todos los 'simple
# features' tienen el mismo)

st_crs(calles) <- 4326

# Cortar los objetos descargados.

calles <- st_intersection(calles, poligono)

# Grafico de las calles. Lleva tiempo para la provincia de Buenos Aires
plot(calles) #lerdo

# Crea un vector con los nombres de calle existentes  
nombres <- calles$name
  
# Lo escribe en un archivo csv.

write.csv(nombres,file = "nombres.csv")


