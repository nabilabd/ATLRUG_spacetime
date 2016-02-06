## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(sp)
  library(gstat)
  library(devtools)
  library(magrittr)
})
dev_mode()
library(dplyr, warn=F, quietly = T)

# re-initialize the two datasets
initialize <- function() {data(meuse); data(meuse.grid)}

data(meuse)
coordinates(meuse) <- ~ x + y

lzn.vgm <- variogram(log(zinc) ~ 1, meuse) # calculates sample variogram values
lzn.fit <- fit.variogram(lzn.vgm, vgm(1, "Sph", 900, 1))

## ------------------------------------------------------------------------

data(meuse.grid)
coordinates(meuse.grid) <- ~ x + y

# krige predictions
lzn.kriged <- krige(log(zinc) ~ sqrt(dist), meuse, meuse.grid) # NB: different results if model=lzn.fit is set
orig_kriging_res <- lzn.kriged %>% as.data.frame %>% tbl_df
orig_kriging_res

# lm works with dataframes, so prepare data
meuse_df <- as.data.frame(meuse)
mgrid_df <- as.data.frame(meuse.grid)

# calculate linear model predictions
linmod <- lm(log(zinc) ~ sqrt(dist), data = meuse_df)
model_res <- predict.lm(linmod, mgrid_df)

# compare predictions
orig_kriging_res2 <- orig_kriging_res %>% 
  mutate(mod_res = unname(model_res), difference = mod_res - var1.pred)

# the linear model and kriging results are the same
range(orig_kriging_res2$difference) # diff taken since the two columns aren't showing as "equal"


## ---- eval=FALSE---------------------------------------------------------
## proj4string(my_df) <- CRS("+init=epsg:EPSG_CODE")
## proj4string(my_df) <- CRS("PROJ4_STRING")

## ------------------------------------------------------------------------
# reloading data so it is a dataframe and not SpatialPoints df
data(meuse) 
meuse %>% glimpse
coordinates(meuse) <- ~ x + y # specify coordinates

# note that no projection is assigned yet to the SPDF:
slotNames(meuse)
slot(meuse, "proj4string")

# assigning epsg value results in proj4string assignment
proj4string(meuse) <- CRS("+init=epsg:28992") # see below about the number
slot(meuse, "proj4string") 

## ------------------------------------------------------------------------
data(meuse.grid)
coordinates(meuse.grid) <- ~ x + y
proj4string(meuse.grid) <- CRS("+init=epsg:28992") # or, 3857

lzn.vgm2 <- variogram(log(zinc) ~ 1, meuse) # calculates sample variogram values
lzn.fit2 <- fit.variogram(lzn.vgm, vgm(1, "Sph", 900, 1))

proj_kriging_res <- krige(log(zinc) ~ 1, meuse, meuse.grid, model=lzn.fit2)
projected_res <- proj_kriging_res %>% as.data.frame %>% tbl_df
projected_res


## ---- eval=FALSE---------------------------------------------------------
## data("meuse")
## coordinates(meuse) <- ~ x + y
## proj4string(meuse) <- CRS("+init=epsg:4326")

## ------------------------------------------------------------------------
# select coordinates, and form SPDF
rdh_coords <- meuse %>% as.data.frame %>% select(x, y) 
rdh_coords %>% glimpse
coordinates(rdh_coords) <- ~ x + y
proj4string(rdh_coords) <- CRS("+init=epsg:28992")

# convert to long/lat coords
longlat_coords <- rdh_coords %>% spTransform(CRS("+init=epsg:4326"))
longlat_coords %>% str
longlat_coords %>% as.data.frame %>% glimpse

## ------------------------------------------------------------------------
session_info()

