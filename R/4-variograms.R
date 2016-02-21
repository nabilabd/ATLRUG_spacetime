
source("R/1-data.R")
library(gstat)

# start with an example: calculate sample vgm
coordinates(meuse) <- ~ x + y

lzn.vgm <- variogram(log(zinc)~1, meuse) 
plot(lzn.vgm)

# inspect visual properties
show.vgms()

# fit a model 
lzn.fit <- fit.variogram(lzn.vgm, model=vgm(1, "Sph", 900, 1)) 

# compare
plot(lzn.vgm, lzn.fit)

# examine structure: vgm model and fit

lzn.vgm 
lzn.vgm %>% str

vgm(1, "Sph", 900, 1)
lzn.fit


# other models available. Behavior varies based on arguments:
vgm()
vgm(2, "Sph", 900, 1)
vgm(2, "Exp", 850, 1)

