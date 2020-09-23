## Set work directory
setwd("C:/Users/Adherly/Desktop/Proyecto de Progra")

## Cargar librerias
library(sf)
library(raster)
library(mapview)
library(dplyr)
library(sp)
library(mapedit)

Cargar los shapes de provincia
prov <- st_read("Data/Provincias.shp")

Cargar los raster previamente descargados
dem1 <- raster("Data/ASTGTM_S18W071_dem.tif") 
dem2 <- raster("Data/ASTGTM_S18W072_dem.tif")

3. Unir 2 raster con mergedem <- merge(dem1, dem2)
dem <- merge(dem1, dem2)
mapview(list(dem, prov))

4. Filtrar solo la provincia deseada
ilo <- dis %>% 
  filter( DISCOD98 == "180301" )

5. Comprobar si es el area deseada
mapview(list(dem, ilo))

6. Importante: Objeto Simple Feature a Spatial: as(tu simple feature, "spatial")
sp_ilo <- as(ilo, "Spatial")

7. Hacer una máscara para nuestra región
ilo_mask<- mask(dem, sp_ilo)
plot(ilo_mask)

ilo_crop <- crop(dem, sp_ilo) 
plot(ilo_crop) 
9. Hacer mask del crop
ilo_dem <- mask(ilo_crop, sp_ilo) 
plot(ilo_dem)

Conviertiendo un objeto sf a ee con la librería rgee para luego extrar datos.
area_ee <- sf_as_ee(area_sf)
library(rgee)
12. Extrayendo datos con rgee
pro_clim <- ee.ImageCollection("NOAA/CDR/ATMOS_NEAR_SURFACE/V2")

install.packages("rgee")

remotes::install_github("r-spatial/rgee")



