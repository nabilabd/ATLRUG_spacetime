
hemisq <- "https://upload.wikimedia.org/wikipedia/commons/5/5c/Adams_hemisphere_in_a_square.JPG"
lcc <- "https://upload.wikimedia.org/wikipedia/commons/0/0f/Lambert_conformal_conic_projection_SW.jpg"
albers <- "https://upload.wikimedia.org/wikipedia/commons/1/1f/Albers_projection_SW.jpg"
werner <- "https://upload.wikimedia.org/wikipedia/commons/5/55/Werner_projection_SW.jpg"
merca <- "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Mercator_projection_SW.jpg/1920px-Mercator_projection_SW.jpg"

func3d <- paste0("https://images.duckduckgo.com/iu/?u=http%3A%2F%2F", "www.mathworks.com", 
                 "%2Fhelp%2Fexamples%2Fmatlab%2FThreeDPlotsGSExample_01.png&f=1")
twit <- "http://twittermood.s3.amazonaws.com/images/poster-large.png"
nyc_picks <- "http://toddwschneider.com/data/taxi/taxi_pickups_map_hires.png"
nyc_drops <- "http://toddwschneider.com/data/taxi/taxi_dropoffs_map_hires.png"


library(downloader)
download(hemisq, destfile = "images/hemi_square_proj.jpg")
download(lcc, destfile = "images/lcc_proj.jpg")
download(albers, destfile = "images/albers_proj.jpg")
download(werner, destfile = "images/werner_proj.jpg")
download(merca, destfile = "images/mercator_proj.jpg")
download(func3d, destfile = "images/spat_func.jpg")
download(twit, destfile = "images/twitter_moods.jpg")
download(nyc_picks, destfile = "images/nyc_picks.jpg")
download(nyc_drops, destfile = "images/nyc_drops.jpg")

## interpolation regions

data("meuse.grid")


##################
# Spatial Domain
##################

# to compare, recall the bubble plot above; those points were what there were values for. this is much m
plot1 <- meuse %>% as.data.frame %>%
  ggplot(aes(x, y)) + geom_point(size=1) + coord_equal() + 
  ggtitle("Points with measurements") + 
  scale_x_continuous(breaks = 1000 * c(179:181))

# this is clearly gridded over the region of interest
plot2 <- meuse.grid %>% as.data.frame %>%
  ggplot(aes(x, y)) + geom_point(size=.2) + coord_equal() + ggtitle("Points at which to estimate")

library(gridExtra) 
grid.arrange(plot1, plot2, ncol = 2)

ggsave("images/spat_domain.jpg")


