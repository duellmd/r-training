###################################
## Data Wrangling                ## 
## Gray Barrett                  ##
## April 20, 2020                ##
###################################

#### This week we'll work on changing the structure of our dataset, as well as making it more tidy.

# As usual, set your working directory and load necessary package
setwd("~/Downloads")
library(tidyverse)



#### Tidying Data ------------------------------------------------------------

# This week's data is simply ACLED data for DRC for 2020. Look at the bottom of this script for full details on how to API it.

df <- read_csv("df.csv")

# This is what we want our data to look like:
head(df)

# Variables are in the columns, observations are in rows, and values are in the cells
# Below are a few examples of data that is not tidy. Code at the bottom shows how I made these datasets.



# SEPARATE ----------------------------------------------------------------

read_csv("df1.csv")
head(df1)
# In this case, the data is smashed together -- country and event date are combined into one field. Very annoying. Let's take a look to see if they are joined in an easily-separable way.

# Looks like in this case, the columns we want to separate are joined by "//"
# Luckily, this makes it easier to separate them.

df1 <- df1 %>% 
  separate(., col = "new_country", into = c("country", "event_date"), sep = "//")

# Separate takes a column we're interested and breaks it into constituent parts

View(df1)

# Much better



# UNITE -------------------------------------------------------------------

# Unite does the opposite, taking constituent columns and putting them together 
read_csv("df2.csv")

# In this case, instead of the country field being in one field, it's been separated into four:
View(df2)

# Luckily, all the field we need are right next to one another. That allows us to use the inherent order in the data. Instead of selecting each individual column and typing it out, like this -- c("country1", "country2", "country3", "country4") -- we can simply use country1:country4

# Then, we'll use Unite to join these columns together.

df2 <- df2 %>% 
  unite("country", country1:country4, sep = " ")

View(df2)

# Note that you can change 'sep' to whatever you want, including character number. For example, if you put "2", then it will separate after the second character/letter (reading from left-right). If you want it to start from the right side, simply put a "-" in front of the number. We'll deal with strings more later on.



# NAs ---------------------------------------------------------------------

# What happens when we want to remove NAs?
# We can drop from the whole dataset:
df_drop <- df %>% 
  drop_na()
View(df_drop)

# Not helpful! This dropped all the rows with ANY NA values.

# What if we just want to drop if a certain column has NA?
df3 <- df %>% 
  drop_na(assoc_actor_1)
View(df3)

# No clue why we'd want to drop if associate actor 1 was blank, but you get the idea.



# FILL --------------------------------------------------------------------

# Last tip is how to use the fill function.
# Say that we have PTS data for a country for 2019, and we want to fill in the values for 2020 using that 2019 number. (We want to use PTS-2019 as a placeholder until PTS-2020 comes through).

ap <- read_csv("ap.csv")
ap <- ap %>% 
  group_by(country) %>% 
  fill(pts)
  

# That's it!



# Exercise ----------------------------------------------------------------

## Read in the CSV named "drc_modified", separate out the Actors field into four columns for actor1, actor2, assoc actor 1, and assoc actor 2.
## Separate the event_date field into three new columns: year, month, and day
## Combine month and year into a new column, called "month_year"
## If you wanted to group this data into quarters, how would you do it? Try to add a new column with quarters













# Code for replicating datasets -------------------------------------------

## First, set the path (note that you can change dates by typing in the dates here)
#path_acled <- "https://api.acleddata.com/acled/read.csv?terms=accept&event_date=2020-01-01|2020-04-11&event_date_where=BETWEEN&limit=0"

## Download the CSV
#download.file(path_acled,"acled_temp.csv")

## Read in the CSV and filter to the country we're interested in; write the final CSV
#acled <- read.csv("acled_temp.csv", head = T)
#df <- acled %>% 
#  filter(country == "Democratic Republic of Congo")


#df1 <- read_csv("drc.csv")
#df1 <- df %>% 
# unite(., "new_country", c("country", "event_date"), sep = "//")
#write_csv(df1, "df1.csv")

#df2 <- read_csv("drc.csv")
#df2 <- df2 %>% 
#  separate(., col = "country", into = c("country1", "country2", "country3", "country4"), sep = " ")
#write_csv(df2, "df2.csv")
