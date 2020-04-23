############################
## Data Wrangling Part II ## 
## Gray Barrett           ##
## April 24, 2020         ##
############################

#### Part II!

# As usual, set your working directory and load necessary packages
setwd("~/Downloads/CSO/r-training-master/08_data wrangling ii")
library(tidyverse)
library(readr) # Another good way to import data


# This week's data is ACLED for Nigeria from 2018-2020. Let's API it!
df <- read_csv("df.csv")

# First, set the path, including dates and country name. ACLED has a good guide on their website for how to to this.
path_acled <- "https://api.acleddata.com/acled/read.csv?terms=accept&country=Nigeria&event_date=2018-01-01|2020-04-18&event_date_where=BETWEEN&limit=0"

# Download and read in the CSV
download.file(path_acled,"acled_temp.csv")
df <- read.csv("acled_temp.csv", head = T)

# Select only the variables we want
df <- df %>% 
  select(country, actor1, actor2, year, fatalities) %>%
  group_by(year, actor1) %>% 
  summarise(fatalities_per_year = sum(fatalities))

# As in previous lessons, this is the data structure we're most familiar with:
View(df)

# Each actor-year gets a row, since this is our unit of analysis


# Pivot Wider -------------------------------------------------------------

# However, what if we wanted to switch this from long to wide format for some reason?
# pivot_wider from tidyverse will let us do that

df <- df %>% 
  pivot_wider(names_from = year, values_from = fatalities_per_year)

# What have we done?
head(df)

# What a mess. Still, sometimes it's helpful to see data arrayed in this way.


# Pivot Longer ------------------------------------------------------------

# Wait... how do we get it back?
##We can either re-load the data from the CSV or use the inverse function, pivot_longer.

# First, though, notice that the names of the columns are all wonky -- they are the names of the years in quotes.
names(df) <- str_replace(names(df), "`", "")

# We can try to get rid of the quote, but this won't do anything, and the following throws an error
dat <- df %>% 
  pivot_longer(names_from = c(`2018`, `2019`, `2020`),  names_to = "year", values_to = "fatalities_per_year")

## Well, since we want to pivot everything except the actor field, let's do that.
dat <- df %>% 
  pivot_longer(-actor1, names_to = "year", values_to = "fatalities_per_year")

head(dat)

# Nice.

### Next lesson is joins, unions, and intersections!