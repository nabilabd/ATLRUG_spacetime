
library(sp)
devtools::dev_mode()
library(dplyr)

data(meuse)
data(meuse.grid)

tbl_df(meuse)
tbl_df(meuse.grid)

meuse.grid %>% tbl_df %>% arrange(x, y)

