
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

