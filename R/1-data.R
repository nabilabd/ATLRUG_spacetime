
library(sp)
library(devtools)
dev_mode()
library(dplyr)

data(meuse)
data(meuse.grid)

tbl_df(meuse)
tbl_df(meuse.grid)

meuse.grid %>% tbl_df %>% arrange(x, y)

library(ggplot2)

ggplot(meuse, aes(x, y)) + geom_point(size=1) + coord_equal()
ggplot(meuse.grid, aes(x, y)) + geom_point(size=1) + coord_equal()


# # example of spatial data in matrix
# data(volcano)
# filled.contour(volcano, color.palette = terrain.colors, asp = 1)
# title(main = "volcano data: filled contour map")
