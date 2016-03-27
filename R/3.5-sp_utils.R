
source("R/1-data.R")


# more functions, for fun

spDists # different from `dist` command


# returns whether or not there is a grid structure (or, "topology") imposed on the 
# object
gridded(meuse)

# even if it is gridded, it may not show immediately:
data(meuse.grid)
coordinates(meuse.grid) <- ~ x + y # has to be SPDF, not DF
gridded(meuse.grid)

# once gridded, has dimensions and indices for the grid cells:
meuse.grid %>% str
gridded(meuse.grid) <- TRUE
meuse.grid %>% str



