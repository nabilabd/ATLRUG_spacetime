
source("R/1-data.R")

library(gstat)
library(tidyr)
library(lubridate)
library(spacetime)

####################
# ST data formats
####################

data(wind)

wind <- wind %>% tbl_df
wind

wind2 <- wind %>% mutate(year = 1900 + year)
wind2 %>% 
  unite(Date, year, month, day, sep = "-") %>% 
  mutate(Date = as.character(ymd(Date))) %>% 
  gather(Site, Value, RPT:MAL)


# above format can be easily contrasted with the following "long form"

library(plm)

data(Produc)
Produc <- Produc %>% tbl_df
Produc


########################################
# ST data classes
########################################

# idea here is that, similar to wtih spatial classes, not 
# necessarily immediately obvious what the different columns 
# refer to. This is an important distinction. 

library(spacetime)

# the difference between these two is that the latter has data
STF
STFDF

STIDF
STSDF


# alternatively, can dump the data into an object, and manually 
# not worry about details of the exact class
stConstruct


## load data

library(readr)

# site coords, and complete sitedates, from 2006
csn_sites <- read_rds("~/ATLRUG_spacetime/data/csn_sites.rds")
speciated <- read_rds("~/ATLRUG_spacetime/data/speciated_2006.rds")

pm_data <- speciated %>% filter(Species == "PM25") %>% 
  mutate(Date = ymd(Date)) %>% left_join(csn_sites)

# ST objects

pm_stobj <- stConstruct(
  x = pm_data,
  space = c("LON", "LAT"),# or, 5:6
  time = "Date" # or number index # can't be character
) 

pm_stobj %>% str

# if you want different format, coercion takes care of details

# here, there is an index denoting the ST locations (?)
pm_stobj %>% as("STSDF") %>% str

pm_stobj %>% as("STFDF") %>% str

# easier than expanding yourself
full_agres <- speciated %>% filter(Species == "PM25") %>% 
   complete(SiteID, Date, Species) %>% left_join(csn_sites)

