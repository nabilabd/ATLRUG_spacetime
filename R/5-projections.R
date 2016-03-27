
source("R/1-data.R")

# Recall that the proj4string was empty. we can assign it 
# a value (or, Coordinate Reference System). 

# start with example
data(meuse)
coordinates(meuse) <- ~ x + y

proj4string(meuse)
proj4string(meuse) <- CRS("+init=epsg:28992")
proj4string(meuse) 

# so now it returns a value. This can also be seen when inspecting the 
# object's structure: 
str(meuse) # Q: what's the projection corresponding to this? 

# for available projections
projInfo() %>% tbl_df

# Here, a certain epsg code used. To inspect all possible codes that 
# can be used:
library(rgdal)
epsg <- make_EPSG()
epsg %>% glimpse

# for more, Melanie Wood has useful overview. Also, see: 
# http://www.remotesensing.org/geotiff/proj_list/


# Now, at least two ways to specify projection. An alternative is 
# to explicitly assign the whole string. See: 
# http://spatialreference.org/. Can try with `epsg` above, or 
# rdh coordinate example

# can either specity epsg code or the full proj4 string
full_string <- proj4string(meuse)
epsg[which(epsg$code == 28992), "prj4"]

data(meuse)
coordinates(meuse) <- ~ x + y

proj4string(meuse)
proj4string(meuse) <- full_string
proj4string(meuse)


### can convert between projections.
library(rgdal)

rdh_coords <- meuse %>% as.data.frame %>% select(x, y) 
rdh_coords %>% glimpse
coordinates(rdh_coords) <- ~ x + y
proj4string(rdh_coords) <- CRS("+init=epsg:28992")

# convert to long/lat coords
longlat_coords <- rdh_coords %>% spTransform(CRS("+init=epsg:4326"))
longlat_coords %>% str
longlat_coords %>% as.data.frame %>% glimpse


# useful functions
spDists
spDistsN1



