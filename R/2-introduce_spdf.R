
source("R/1-data.R")

library(magrittr)

# to form an SPDF, identify the columns containing coordinates
coordinates(meuse) <- ~ x + y
meuse %>% class
meuse %>% str

# objects of S4 class have "slots". 
isS4(meuse)
slotNames(meuse) # not same as "names"
str(meuse)

identical( slot(meuse, "data"), meuse@data )


# So has five slots. Can also be accessed via helper functions, but not always consistent
bbox(meuse)
identical(bbox(meuse), meuse@bbox)

coordinates(meuse) %>% head(10)
identical(coordinates(meuse), meuse@coords)

proj4string(meuse)
slot(meuse, "proj4string")


# col id's of coordinates
meuse2 <- meuse %>% as.data.frame %>% select(cadmium:elev, x:y, everything())
meuse2 %>% glimpse
coordinates(meuse2) <- ~ x + y
meuse2 %>% str

### A couple of things to be aware of 

# data argument
slot(meuse, "data") %>% tbl_df
as.data.frame(meuse) %>% tbl_df


# potential problems
library(ggplot2)

# there are two problems here... (class; not having the colms)
meuse %>%  # also problem if using meuse@data
  

# but this works
meuse %>% 
  as.data.frame %>% 
  ggplot(aes(x, y, color = elev)) + geom_point() + coord_equal()


