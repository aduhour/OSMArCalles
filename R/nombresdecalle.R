##

##  Analizar nombres de calles en argentina
library(tidyverse)
library(sf)
library(osmdata)
library(tmap)

## Obtener el polígono del área a consultar

prov <- "Misiones"

recuadro <- getbb(prov,featuretype = "state")

## Guardar todas las calles etiquetadas como highway=*
## en el recuadro seleccionado.
## Las agrupo según las categorías de
## https://wiki.openstreetmap.org/wiki/ES:Key:highway

caminos <-opq(bbox = recuadro, timeout = 120) %>%
          add_osm_feature(key = "highway", value = c("residential","primary",
                                             "secondary","tertiary",
                                             "motorway","trunk", "unclassified")) %>%
          osmdata_sf() %>%
          


conexiones <-opq(bbox = recuadro, timeout = 120) %>%
  add_osm_feature(key = "highway", value = c("trunk_link",
                                             "motorway_link","primary_link",
                                             "secondary_link","tertiary_link")) %>%
  osmdata_sf()

especiales <- opq(bbox = recuadro, timeout = 120) %>%
          add_osm_feature(key = "highway", value = c("service","living_street",
                                                     "pedestrian","track",
                                                     "raceway","road")) %>%
          osmdata_sf()


veredas <- opq(bbox = recuadro, timeout = 120) %>%
  add_osm_feature(key = "highway", value = c("footway","cicleway",
                                             "bridleway","steps",
                                             "path")) %>%
  osmdata_sf()

  
## Reunir todas las calles y caminos en una sola tabla

caminos <- caminos$osm_lines
conexiones <- conexiones$osm_lines
especiales <- especiales$osm_lines
veredas <- veredas$osm_lines


calles <- bind_rows(veredas,caminos) %>%
          bind_rows(conexiones)%>%
          bind_rows(especiales)

## Guardar en archivo y borrar

st_write(calles, paste("data/calles",prov,".geojson",sep = ""))

rm(caminos, conexiones,especiales,veredas)
  
## Seleccionar las columnas del nombre, 
##el valor de la clave highway
## y el id de OSM del objeto.




calles <- select(calles,name,osm_id, highway) %>%
  filter(!is.na(name)) # filtrar las calles que no tienen nombre

# Seleccionar el límite provincial
# Obtiene los límites de todas las provincia que limitan con la de Bs As 
# incluyendo parte de Uruguay

# Seleccionar el límite provincial

limite <- opq(bbox = recuadro) %>%
  add_osm_feature(key = "admin_level", value = "4") %>%
  osmdata_sf() %>%
  unname_osmdata_sf()

limite <- limite$osm_multipolygons %>%
  select(osm_id, name, admin_level) %>%
  filter(name==prov)


# Establecer el sistema de referencia (aseguramos que todos los 'simple
# features' tienen el mismo)

st_crs(calles) <- 4326
st_crs(limite) <- 4326

# Recortar las calles descargadas según el polígono de la provincia

calles <- st_intersection(calles,limite)

# Crea un vector con los nombres de calle existentes  
nombres <- calles$name

# Y lo escribe en un archivo csv.

write.csv(nombres,file = paste("data/nombres",prov,".csv",sep = ""))


## Búsqueda de abreviaturas

# Agrego una columna con la primera palabra del nombre de la calle

calles <- mutate(calles, primera_palabra = word(calles$name))


# Filtra las calles cuya primera palabra tiene un punto
con_punto <- filter(calles,str_detect(primera_palabra,"\\.")) # %>%

# Muestra en una tabla cuántas hay por cada una
table(con_punto$primera_palabra)


## Abreviaturas

# Listado de abreviaturas armado con las encontradas en provincia de Buenos Aires
# y posterior revisión nacional.

lista_de_abreviaturas <- c("^av","Dr","1ro", "Agrim", "Alte","AVDA","Bs", 
                           "Bto", "Cdr","Cmte","Cnel","Cno","Conc",
                           "Cons","Const","Cont","Cptn","Crio","Ctda",
                           "Dr","Enf","Est","Fte","Gob","Grl","Inf","Inst",
                           "Jr","Laz","Malv","Paje","Pbro","Pbro","Pbto",
                           "Pbtro","PJE","Preb","Prof","Prol","Psj","Psje",
                           "Pto","Reg","Sdor","Sen","Sgo","Srta","Sta","Vec", "Ppal",
                           "Almte", "Arq", "Bdo", "Blvd", "Bme", "Brig", "Bv",
                             "Cap","Cda","Cjal","Cmdte","Cque","Ctan","Cte",
                             "Diag","Dip","Dr","Dra","Escr","Fco","Gdor","Gral",
                             "Hna","Hno","Hnos","ing","Int","Mñor","Mtra","Mtro",
                             "Ntra","Of","Pcia","Pdte","Pje","Pres","Presb",
                             "Prov","Pte","Rep","Rvdo","Sgto","Sold","Sra",
                             "Sr","Subof","Tte")


# Crear el patrón de abreviaturas, el separador "|^(?i)" indica que busca que
# exista un nombre de calle que comience con alguna de las abreviaturas
# sin distinguir mayúsculas.

patron <- paste(lista_de_abreviaturas,collapse = "|^(?i)")

sin_punto <- filter(calles,str_detect(primera_palabra, patron))%>%
              filter(str_length(primera_palabra)<5)

# Hacer una tabla de cuántas veces aparece cada abreviatura sin punto

table(sin_punto$primera_palabra)

# crea un vector lógico viendo cuáles elementos están repetidos

filasdup <- con_punto$primera_palabra %in% sin_punto$primera_palabra

# Une las dos listas sin las repetidas

abreviadas <- bind_rows(sin_punto,con_punto[!filasdup,])

table(abreviadas$primera_palabra)

# Exportar abreviadas como geojson

st_write(abreviadas, paste("mapas/abreviadas",prov,".geojson",sep=""))

# Agrupar las abreviaturas

resumen <- abreviadas %>%
  group_by(primera_palabra) %>%
  summarise(n = n()) %>%
  mutate(porcentaje_abreviatura=n/sum(n))

# Gráfico de barras de las abreviaturas

grafabreviadas <- ggplot(abreviadas) +
  geom_bar(mapping = aes(x=primera_palabra, fill = primera_palabra))
abreviadas <- sin_punto

grafabreviadas

# Crea un mapa interactivo de las calles abreviadas en la provincia


tmap_mode("view")
mapaabreviadas <- tm_shape(abreviadas) +
  tm_lines(col = "blue",lwd = 10)+
  tm_basemap("OpenStreetMap") +
  tm_layout(title = paste("Calles con nombres abreviados en ",prov,sep = "")) +
  tm_scale_bar() +
  tm_shape(limite) + tm_borders()

# Y lo guarda en un archivo

tmap_save(mapaabreviadas,paste("mapas/abreviadas",prov,".html",sep = ""), 
          add.titles = T)
