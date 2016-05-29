
hemisq <- "https://upload.wikimedia.org/wikipedia/commons/5/5c/Adams_hemisphere_in_a_square.JPG"
lcc <- "https://upload.wikimedia.org/wikipedia/commons/0/0f/Lambert_conformal_conic_projection_SW.jpg"
albers <- "https://upload.wikimedia.org/wikipedia/commons/1/1f/Albers_projection_SW.jpg"
werner <- "https://upload.wikimedia.org/wikipedia/commons/5/55/Werner_projection_SW.jpg"
merca <- "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Mercator_projection_SW.jpg/1920px-Mercator_projection_SW.jpg"

func3d <- paste0("https://images.duckduckgo.com/iu/?u=http%3A%2F%2F", "www.mathworks.com", 
                 "%2Fhelp%2Fexamples%2Fmatlab%2FThreeDPlotsGSExample_01.png&f=1")

library(downloader)
download(hemisq, destfile = "images/hemi_square_proj.jpg")
download(lcc, destfile = "images/lcc_proj.jpg")
download(albers, destfile = "images/albers_proj.jpg")
download(werner, destfile = "images/werner_proj.jpg")
download(merca, destfile = "images/mercator_proj.jpg")

download(func3d, destfile = "images/spat_func.jpg")

