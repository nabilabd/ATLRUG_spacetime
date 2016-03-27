
source("R/1-data.R")

library(gstat)

data(meuse)

# compute sample and fitted variograms
coordinates(meuse) <- ~ x + y
lzn.vgm <- variogram(log(zinc)~1, meuse) 
lzn.fit <- fit.variogram(lzn.vgm, model=vgm(1, "Sph", 900, 1)) 


# kriging step
data(meuse.grid)
coordinates(meuse.grid) <- ~ x + y
lzn.kriged <- krige(log(zinc) ~ 1, meuse, meuse.grid, model=lzn.fit)

lzn.kriged %>% str
lzn.kriged %>% as.data.frame %>% tbl_df

# view results
library(scales)
lzn.kriged %>% as.data.frame %>%
  ggplot(aes(x=x, y=y)) + geom_tile(aes(fill=var1.pred)) + coord_equal() +
  scale_fill_gradient(low = "yellow", high="red") +
  scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) +
  theme_bw() + ggtitle("Kriged Results")


# kriging with vgm models automatically fit
library(automap)

auto_res <- autoKrige(log(zinc) ~ 1, meuse, meuse.grid)
auto_res[[1]] %>% as.data.frame %>% 
  ggplot(aes(x=x, y=y)) + geom_tile(aes(fill=var1.pred)) + coord_equal() +
  scale_fill_gradient(low = "yellow", high="red") +
  scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) +
  theme_bw() + ggtitle("(Automatically) Kriged Results")

