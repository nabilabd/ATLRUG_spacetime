

library(sp)
library(magrittr)
devtools::dev_mode()
library(dplyr)
library(ggplot2)

data(meuse)

# examine the dataset
meuse %>% str
meuse %>% class


# to form an SPDF, identify the columns containing coordinates
coordinates(meuse) <- ~ x + y
meuse %>% class
meuse %>% str



# now has five slots. These can be accessed via helper functions: 
bbox
proj4string
coordinates



# more generally, as should be coming, Spatial* classes are structured 
# differently depending on they kinds of data they contain. These five 
# slots are characteristic of SpatialPointsDataFrame's.


# now, what can you do with SPDF's? Recall that the proj4string was empty. 
# we can assign it a projection (or, Coordinate Reference System). 

proj4string(meuse)
proj4string(meuse) <- CRS("+init=epsg:28992")
proj4string(meuse) 

# so now it returns a value. This can also be seen when inspecting the 
# object's structure: 
str(meuse)

# now, the `proj4string` argument is no longer empty. Don't worry right now 
# about the details of what's going on here. More on this in the 
# section on "Projections". 


# `sp` package very accomodating, often have more than one way to declare 
# objects. What I present here is what I've personally found easiest and 
# clearest, but to give an example: 

data(meuse)
meuse %>% class
coords <- meuse[, c("x", "y")]
coords %>% glimpse

# possible to make SpatialPoints obj
meuse_pts <- SpatialPoints(coords)
meuse_pts %>% str

meuse_pts2 <- SpatialPoints(coords, proj4string=CRS("+init=epsg:28992")) 
meuse_pts2 %>% str

# but here, there's no data, just coordinates. Not sure what you might want to 
# do with that. Here, we focus on SPDF's.


# Instead of just making the coordinates, we could directly make SPDF
meuse_spdf <- SpatialPointsDataFrame(coords, meuse)


# from here, can see a few things. namely, by just assigning the coordinates, 
# the package takes care of splitting coordinates from data (which is the point 
# of the classes, that some are coords, some are data). These classes really 
# just composed of different parts. Using lower-level constructors, it's possible 
# for you to manually construct these objects from the individual pieces (i.e., 
# the "data" part, the "coordinates" part, the "projection" part, etc), but 
# given the choice, you probably won't want to. 

# for more on what all is available
getClass("Spatial")



# Before continuing, just note that now as an SPDF, may need to convert it to 
# dataframe to do some things:
meuse %>% 
  ggplot(aes(x, y, color = elev)) + geom_point() + coord_equal()

# previously gave error, but the following code should works
meuse %>% 
  as.data.frame %>% 
  ggplot(aes(x, y, color = elev)) + geom_point() + coord_equal()









