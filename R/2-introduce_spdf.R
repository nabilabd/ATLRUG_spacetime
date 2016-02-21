
source("R/1-data.R")

library(magrittr)

# to form an SPDF, identify the columns containing coordinates
coordinates(meuse) <- ~ x + y
meuse %>% class
meuse %>% str


# Now has five slots. These can be accessed via helper functions: 
bbox(meuse)
identical(bbox(meuse), meuse@bbox)

coordinates(meuse) %>% head(10)
identical(coordinates(meuse), meuse@coords)

# difference between slot values and helper functions
proj4string(meuse)
meuse@proj4string
slot(meuse, "proj4string")

identical( meuse@proj4string, slot(meuse, "proj4string") )


# data argument
meuse@data %>% tbl_df
meuse %>% as.data.frame %>% tbl_df


# potential problems
library(ggplot2)

# there are two problems here...
meuse %>% 
  ggplot(aes(x, y, color = elev)) + geom_point() + coord_equal()

# but this works
meuse %>% 
  as.data.frame %>% 
  ggplot(aes(x, y, color = elev)) + geom_point() + coord_equal()


