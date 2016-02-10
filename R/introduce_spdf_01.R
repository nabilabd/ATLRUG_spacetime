

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

# now, the `proj4string` argument is no longer empty. More on this in the 
# section on "Projections". 








# now as an SPDF, may need to convert it to dataframe to do some things
meuse %>% 
  ggplot(aes(x, y, color = elev)) + geom_point()

# previously gave error, but the following code should works
meuse %>% 
  as.data.frame %>% 
  ggplot(aes(x, y, color = elev)) + geom_point()









