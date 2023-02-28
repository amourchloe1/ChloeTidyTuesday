## This is my first Tidy Tuesday script 
## Created by: Chloe Mintlow 
## Updated on 2023-02-26

#Load Data

#install.packages("tidytuesdayR") #read in tidytuesday package
library(tidyverse)
library(tidytuesdayR)
library(BobRossColors)


tuesdata <- tidytuesdayR::tt_load('2023-02-21') #read in data
tuesdata <- tidytuesdayR::tt_load(2023, week = 8)

bob_ross <- read_csv("https://raw.githubusercontent.com/jwilber/Bob_Ross_Paintings/master/data/bob_ross_paintings.csv")
bob_ross <- tuesdata$bob_ross
glimpse(bob_ross)
View(bob_ross)
bob_ross <- select(bob_ross, -1)
bob_ross <- bob_ross |> 
  mutate(across(Black_Gesso:Alizarin_Crimson, as.logical))
read_csv(bob_ross, here::here("data", "2023-02-21", "bob_ross.csv"))

View(bob_ross_paintings)
print(unique_bob_ross_colors)
scales::show_col(unique_bob_ross_colors$color_hex)

#Make plot 

glimpse(bob_ross)
Bob_Ross_Both<-inner_join(bob_ross, bob_ross_paintings) %>% #combined bob ross & bob ross painting data, removed NA values
  group_by(season)  

ggplot(bob_ross_paintings, 
       mapping = aes(x = season, y = num_colors)) + 
  geom_point() + 
  labs(x = "Season Number", 
       y = "Number of Colors used") + 
  theme_minimal() + 
  scale_color_bob_ross(painting = "peaceful_valley", type = "qualitative") + 
  ggtitle("The Number of Colors Used in Paintings Within Each Season")
#saved ggplot through plots --> save as pdf 

1         
