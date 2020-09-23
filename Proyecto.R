## Set work directory
setwd("C:/Users/Adherly/Desktop/Proyecto de Progra")

## Cargar librerias
library(sf)
library(mapview)
library(sp)
library(raster)
library(rgee)
library(dplyr)
library(mapedit)

#Cargar los shapes de provincia
prov <- st_read("Data/Provincias.shp")

# Cargar los raster previamente descargados
dem1 <- raster("Data/ASTGTM_S18W071_dem.tif") 
dem2 <- raster("Data/ASTGTM_S18W072_dem.tif")

# Unir 2 raster con mergedem <- merge(dem1, dem2)
dem <- merge(dem1, dem2)
mapview(list(dem1, prov))

# Filtrar solo la provincia deseada
ilo <- dis %>% 
  filter( DISCOD98 == "180301")

# Comprobar si es el area deseada
mapview(list(dem, ilo))

# Importante: Objeto Simple Feature a Spatial: as(tu simple feature, "spatial")
sp_ilo <- as(ilo, "Spatial")

# Hacer una máscara para nuestra región
ilo_mask<- mask(dem, sp_ilo)
plot(ilo_mask)

ilo_crop <- crop(dem, sp_ilo) 
plot(ilo_crop) 

# Hacer mask del crop
ilo_dem <- mask(ilo_crop, sp_ilo) 
plot(ilo_dem)

#Hallar la altitud media para 
altitud_media <- raster::extract(ilo_dem, sp_ilo, fun = mean)

# Ahora con el uso de mapview y editMap seleccionaremos una area relativa
area <- mapview(ilo_dem) %>% editMap()    
area_sf <- area$all
plot(area_sf)

mapview(list(ilo_dem, area_sf))
# Conviertiendo un objeto sf a ee, ee_Initialize()
area_ee <- sf_as_ee(area_sf)       ##No pudimos avanzar 

# Extraer datos de ee_pp: pp_ins
pp_ins <- ee$ImageCollection("JAXA/GPM_L3/GSMaP/v6/operational")$ 
  filterDate("2018-08-06", "2018-08-07")$ first()
pp_stack <- ee_as_raster(imag = ee_cc, region = area_ee$geometry())
pp_area_ins <- pp_stack[[1]]
plot(pp_area_ins)
mapview(list(pp_area_ins, ilo_dem))
