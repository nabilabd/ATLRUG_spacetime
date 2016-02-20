
source("R/1-data.R")
library(gstat)

# start with an example
coordinates(meuse) <- ~ x + y

lzn.vgm <- variogram(log(zinc)~1, meuse) # calculate sample vgm
lzn.fit <- fit.variogram(lzn.vgm, model=vgm(1, "Sph", 900, 1)) # fit model 

plot(lzn.vgm, lzn.fit)

# examine structure: vgm model and fit

lzn.vgm 
lzn.vgm %>% str
plot(lzn.vgm)

lzn.fit


# other models available. Behavior varies based on arguments:
vgm()
vgm(1, "Sph", 900, 1)
vgm(2, "Sph", 900, 1)
vgm(2, "Exp", 900, 1)

# inspect visual properties
show.vgms()

