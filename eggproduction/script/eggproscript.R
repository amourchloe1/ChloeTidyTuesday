## My Tidy Tuesday

## Load Libraries
library(here)
library(tidytuesdayR)
library(tidyverse)

## Get Data
tuesdata <- tidytuesdayR::tt_load('2023-04-11')
tuesdata <- tidytuesdayR::tt_load(2023, week = 15)

eggproduction <- tuesdata$`egg-production`
cagefreepercentages <- tuesdata$`cage-free-percentages`

# View Data
View(cage)

# Make a Plot 
eggcageplot <- %>%
  ggplot()