

# Loading the libraries

library(sf)
library(ggplot2)
theme_set(theme_bw())
library(tidyverse)
library(osmdata)
library(ggtext)
library(ggrepel)



# Unzip KMZ file 

file <- "Oloisukut.kmz" 
unzip(file)



# Reading the kml file 

kml <- "doc.kml"
st_layers(kml)



# Reading different layers 

villa <- sf::st_read(kml,"Villa sites")
forest <- sf::st_read(kml,"Nyakwere Forest")
phase_2 <- sf::st_read(kml, "Phase 2 critical forest protection area")
phase_1 <- sf::st_read(kml,"Phase 1 core conservation area")



# Joining phase 1 and phase 2

sf::sf_use_s2(F)
r <- st_union(phase_1,phase_2)

conserv <- r %>% 
  st_buffer(0.07) %>% 
  st_convex_hull() %>% 
  st_union()
conserv



# Roads

bbox <- st_bbox(conserv)
highway <-
  opq(bbox)%>%
  add_osm_feature(key = "highway")%>%
  osmdata_sf()

roads <-highway$osm_lines%>%
  st_intersection(conserv)



# Map 
ggplot(roads, fill = name) + geom_sf(linetype = 3)+
  geom_sf(data = roads,
          color = "black",
          linetype = "twodash",
          size = 0.5)

