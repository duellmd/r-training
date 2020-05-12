#####################
## Strings Part II ## 
## Gray Barrett    ##
## May 6, 2020     ##
#####################

#### Strings! Part II!
setwd("~/Downloads/CSO/Training/r-training-master")
library(tidyverse)

path <- "https://api.acleddata.com/acled/read.csv?terms=accept&country=Democratic_Republic_Of_Congo&event_date=2018-01-01|2020-04-18&event_date_where=BETWEEN&limit=0"
download.file(path,"acled_temp.csv")
df <- read.csv("acled_temp.csv", head = T)

# String Basics II -----------------------------------------------------------

## Extracting Matches ##
# Say we are interested in filtering our data to find only specific matches.
# For instance, Margaret and I were working on a project on violence against healthcare workers in DRC.
# We could either use Excel/Tableau and do a query, or we can do this in R

# First, we create a word bank (a vector) of search terms we are interested in
health <- c("health", "clinic", "ebola", "doctor", "MSF", "care")

# Then, we collapse that into a singular regular expression
health_match <- str_c(health, collapse = "|")

# Next, we run the str_extract function on our dataset using our word bank
df$matches <- str_extract(df$notes, health_match)

head(df$matches)
# Hm. Buncha NAs

df %>% 
  group_by(matches) %>% 
  summarise(n = n())
# Ah, this is useful, though!

# Now, we can drop the stuff we don't want and have a much smaller dataset
dat <- df %>% 
  drop_na()

# This is neat, but what if there is more than one word, and we want to know what those words are?
# str_extract_all will take out all the words that match. If we use the simplify command it will
# store these as a matrix; otherwise, it'll store them as a list.
df$matches_plus <- str_extract_all(df$notes, health_match, simplify = T)


# Replacement -------------------------------------------------------------
# Say we wanted to get rid of some redundant features of our data, like the (Democratic Republic of Congo at the end of the actor1 field)
actor1s <- unique(df$actor1)

# We can use str_replace to tell it to replace the thing in the first quote with nothing
str_replace(actor1s, "(Democratic Republic of Congo)", "")
# Why isn't this working?

str_replace(actor1s, "\\(Democratic Republic of Congo\\)", "")
# Much better

# https://regex101.com/ More resources/help available here
# Regular expressions are extremely useful and powerful, and using them can save you tons of time if working with messy data