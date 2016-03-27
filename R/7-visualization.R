
source("R/1-data.R")


# spatial plotting available in base system

library(maps)

map("world")
map("usa")
map("state", "Georgia")


# there are drawbacks, though. How to identify e.g., landmarks? 
# no axes to pinpoint locations. Can use ggplot2

library(ggplot2)

## using ready-made datasets

# plot the specified region
plot_region <- function(.data) {
  ggplot(.data, aes(long, lat, group=group)) + 
    geom_path() + coord_map()
}

us <- map_data("state")
ga <- map_data("state", "georgia")
cty_ga <- map_data("county", "georgia")

plot_region(us)
plot_region(ga)
plot_region(cty_ga)

## can use custom datasets


# more recently, have: ggmap, leaflet, gganimate

##############################################################
## ggmap
##############################################################

# takes idea further by extending ggplot2. also able to 
# download maps from online services, to superimpose with data
# (the example below is modified `spacetime` vignette) 

data(wind)
library(ggmap)

# add columns of numerical coordinates
wind.loc[, c("y","x")] <- 
  wind.loc %>% 
  select(Latitude, Longitude) %>% 
  sapply(function(colm) colm %>% as.character %>% char2dms %>% as.numeric)

# specify spatial coordinates, and which projection used
coordinates(wind.loc) = ~ x + y
proj4string(wind.loc) = "+proj=longlat +datum=WGS84"


#' slightly enlarge the default bounding box for sp objects
#' 
#' @param . an SPDF object
re_bound <- . %>% bbox %>% as.data.frame %>% 
  mutate(diff = max - min, min = min -.2 * diff, max = max + .2 * diff) %>% 
  select(-diff) %>% as.matrix %>% set_rownames(c("x", "y"))

# obtain map and form positions for station labels
my_map <- wind.loc %>% re_bound %>% get_map(., source = "osm")
offsets <- wind.loc %>% as.data.frame %>% select(Station, x, y) %>% 
  mutate(y = y + .1)

# map of Ireland's stations, for context
# todo: fix axes and labels
my_map %>% 
  ggmap(base_layer = ggplot(aes(x=x, y=y), data = wind.loc %>% as.data.frame)) + 
  geom_point(size=3, color="red") + 
  annotate("text", x = offsets$x, y = offsets$y, label=offsets$Station, size=4)


# these can be especially useful if can aggregate in 
# spatially-meaningfully way. see ggmap vignette with houston crime data

##############################################################
## leaflet
##############################################################

# otherwise, if have point sources, then this allows zooming in

library(leaflet)




##############################################################
## gganimate
##############################################################

library(gganimate)

# for differences by a variable, perhaps most commonly: time






