## ------------------------------------------------------------------------
library(sp)
library(tidyr)
library(ggplot2)
library(magrittr, warn.conflicts = FALSE)

## ------------------------------------------------------------------------
data(meuse)
class(meuse)
str(meuse)

## ------------------------------------------------------------------------
coordinates(meuse) <- ~ x + y
class(meuse)


## ------------------------------------------------------------------------
str(meuse)

## ------------------------------------------------------------------------
meuse %>% coordinates %>% head
meuse %>% bbox
summary(meuse)

## ---- eval=FALSE---------------------------------------------------------
## meuse_df <- cbind( attr(meuse, "data"), meuse@coords) # just coerce to df

## ------------------------------------------------------------------------
# bubble chart
bubble(meuse, "zinc", col = c("#00ff0088", "#00ff0088"), 
       main="zinc concentrations (ppm)")

## ------------------------------------------------------------------------
# I think the blue stands out better against the white background
meuse %>% as.data.frame %>% 
  ggplot(aes(x, y)) + geom_point(aes(size=zinc), color="blue", alpha=3/4) + 
  ggtitle("Zinc Concentration (ppm)") + coord_equal() + theme_bw()

## ------------------------------------------------------------------------
## Project the data from Rijksdriehoek (RDH) (Netherlands topographical) map 
## coordinates to Google Map coordinates; RDH coordinates have an EPSG code of 
## 28992 and Google map coordinates have an EPSG code of 3857

# But from the documentation of proj4string: Note that only “+proj=longlat” is 
# accepted for geographical coordinates, which must be ordered (eastings, 
# northings). So use sp

# plan: convert rdh to longlat, then assign longlat, then transform to rdh
# TODO: incorporate this into a post on using ggmap with spatial data.
library(rgdal)

ESPG <- make_EPSG()
ESPG[which(ESPG$code == 28992), ]
rdh_proj <- ESPG[which(ESPG$code == 28992), "prj4"]

#proj4string(meuse) = "+proj=longlat +datum=WGS84"

## ------------------------------------------------------------------------
data(meuse.grid)
summary(meuse.grid)

meuse.grid %>% str
meuse.grid %>% class

## ------------------------------------------------------------------------
# this is clearly gridded over the region of interest
meuse.grid %>% as.data.frame %>% 
  ggplot(aes(x, y)) + geom_point(size=1) + coord_equal()
 
# to compare, recall the bubble plot above; those points were what there were 
# values for. this is much more sparse
meuse %>% as.data.frame %>% 
  ggplot(aes(x, y)) + geom_point(size=1) + coord_equal()

## ------------------------------------------------------------------------
coordinates(meuse.grid) = ~x+y
gridded(meuse.grid) = TRUE
meuse.grid %>% class

## ------------------------------------------------------------------------
image(meuse.grid["dist"])
title("distance to river (red=0)")

# ggplot version
meuse.grid %>% as.data.frame %>%
  ggplot(aes(x, y)) + geom_tile(aes(fill=dist)) + 
  scale_fill_gradient(low = "red", high="yellow") + coord_equal() + theme_bw() + 
  ggtitle("Distance to River")

## ------------------------------------------------------------------------

library(gstat)

zinc.idw <- krige(zinc ~ 1, meuse, meuse.grid)
zinc.idw %>% class
zinc.idw %>% as.data.frame %>% head

## ------------------------------------------------------------------------
spplot(zinc.idw["var1.pred"], main="zinc inverse distance weighted interpolations")

#same spplot with ggplot 
library(scales)

zinc.idw %>% as.data.frame %>% 
  ggplot(aes(x=x, y=y, fill=var1.pred)) + geom_tile() + theme_bw() + 
  coord_equal() + scale_fill_gradient(low = "red", high="yellow") + 
  ggtitle("zinc inverse distance weighted interpolations") + 
  scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) 

## ------------------------------------------------------------------------
# graphical check of hypothesis from above graphs
plot(log(zinc) ~ sqrt(dist), data=meuse, pch=16, cex=.5)
abline(lm(log(zinc) ~ sqrt(dist), meuse))

# or with ggplot:
# meuse %>% as.data.frame %>% 
#   ggplot(aes(sqrt(dist), log(zinc))) + geom_point() + 
#   geom_smooth(method="lm", se=FALSE)

## ------------------------------------------------------------------------
# inspect variation of log(zinc) by distance (i.e., from the river)
lzn.vgm <- variogram(log(zinc)~1, meuse) # calculates sample variogram values
lzn.fit <- fit.variogram(lzn.vgm, model=vgm(1, "Sph", 900, 1)) # fit model
plot(lzn.vgm, lzn.fit) # plot the sample values, along with the fit model

## ------------------------------------------------------------------------
lzn.vgm
lzn.vgm %>% class
lzn.fit %>% class

## ------------------------------------------------------------------------
# inspect variation of log(zinc) by square root of distance 
lznr.vgm <- variogram(log(zinc) ~ sqrt(dist), meuse)
lznr.fit <- fit.variogram(lznr.vgm, model=vgm(1, "Exp", 300, 1))
lznr.fit %>% class
plot(lznr.vgm, lznr.fit)

## ------------------------------------------------------------------------
lzn.kriged <- krige(log(zinc) ~ 1, meuse, meuse.grid, model=lzn.fit)

## ------------------------------------------------------------------------
# sp plotting
spplot(lzn.kriged["var1.pred"])

## ------------------------------------------------------------------------
# kriging results in ggplot
lzn.kriged %>% as.data.frame %>% 
  ggplot(aes(x=x, y=y)) + geom_tile(aes(fill=var1.pred)) + 
  coord_equal() + scale_fill_gradient(low = "red", high="yellow") + 
  scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) + 
  theme_bw() 


## ------------------------------------------------------------------------
lzn.condsim <- krige(log(zinc)~1, meuse, meuse.grid, model=lzn.fit, 
                     nmax=30, nsim=4)
# sp plotting
spplot(lzn.condsim, main="three conditional simulations")

## ------------------------------------------------------------------------
# with ggplot2. (no need to call components with "@" or "attr(., "data"), e.g.) 
#lzn_cond_df <- cbind(attr(lzn.condsim, "data"), attr(lzn.condsim, "coords"))
lzn.condsim %>% as.data.frame %>% 
  gather(sim, value, sim1:sim4) %>% 
  ggplot(aes(x=x, y=y)) + geom_tile(aes(fill=value)) + 
  facet_grid(.~sim) + coord_fixed(ratio = 1) + 
  scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) + 
  scale_fill_gradient(low = "red", high="yellow") + 
  ggtitle("Three conditional simulations") + theme_bw()

