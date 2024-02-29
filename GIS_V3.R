

install.packages("pacman")


pacman::p_load(sf, tidyverse, terra, raster, mapview, sp)


# Load the data

pa <- read.csv("Data/occ_sub.csv")

# Create a simple feature object

pa_sf <- st_as_sf(pa, coords = c("coords.x1", "coords.x2"), crs = 4326)

pa_sf
plot(pa_sf$geometry)

#Read in and plot Aulax sp.

aulax_sf <- pa_sf[pa_sf$Genus_code == "AU",]
plot(aulax_sf$geometry)

#Load fire shape file

fire <- st_read("All_Fires_20_21_gw/All_Fires_20_21_gw.shp")

#Filter out older dates, I want between 2010 - 2021

fire_2010_2021 <- filter(fire, between(YEAR, 2010, 2021))

#disable S2 geometry library to fix error code: Error in wk_handle.wk_wkb(wkb, s2_geography_writer(oriented = oriented,  : 
# Loop 0 is not valid: Edge 174 has duplicate vertex with edge 177
sf_use_s2(F) 

#Join aulax and fires
summary(aulax_sf$X)
aulax_fires_sf <- aulax_sf[fire_2010_2021,]
summary(aulax_fires_sf$X)

#create data frame showing aulax data points that are NOT found in aulax_fires
aulax_no_fires_sf <- aulax_sf[!aulax_sf$X %in% aulax_fires_sf$X, ]

#visualise the difference, not necessary for code
plot(aulax_sf$geometry)
plot(aulax_no_fires_sf$geometry)
plot(aulax_fires_sf$geometry)

#plot no fires using ggplot
ggplot() + 
  geom_sf(data = aulax_no_fires_sf)

ggplot() +
  geom_sf(data = fire_2010_2021)

#view using mapview

mapview(aulax_no_fires_sf)
mapview(fire_2010_2021)

mapview(aulax_no_fires_sf) + mapview(fire_2010_2021, col.regions = "red")


