
source("R/1-data.R")


# `sp` package very accomodating, often have more than one way to declare 
# objects. What I present here is what I've personally found easiest and 
# clearest, but to give an example: 

data(meuse)
meuse %>% class
coords <- meuse[, c("x", "y")]
coords %>% glimpse

# different ways to make a SpatialPoints object

meuse_pts <- SpatialPoints(coords)
meuse_pts %>% str

meuse_pts2 <- SpatialPoints(coords, proj4string=CRS("+init=epsg:28992")) 
meuse_pts2 %>% str

meuse_pts3 <- coords 
coordinates(meuse_pts3) <- ~ x + y # automatic conversion
meuse_pts3 %>% str


# Instead of identifying columns with coordinates, could directly make SPDF
meuse_spdf <- SpatialPointsDataFrame(coords, meuse)
meuse_spdf %>% str

# but, now coords.nrs isn't set. and the names for @coords are from the coord 
# data frame, not the columns of @data. So nothing linking those coordinates 
# to any columns of the original df.

# from here, can see a few things. namely, by just assigning the coordinates, 
# the package takes care of splitting coordinates from data (which is the point 
# of the classes, that some are coords, some are data). These classes really 
# just composed of different parts. Using lower-level constructors, it's possible 
# for you to manually construct these objects from the individual pieces (i.e., 
# the "data" part, the "coordinates" part, the "projection" part, etc), but 
# given the choice, you probably won't want to. 

# for more on what all is available
getClass("Spatial")


