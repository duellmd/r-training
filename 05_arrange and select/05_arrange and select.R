####### Lesson 5
###### More Data Wrangling Functions
###### April 14, 2020
###### Amanda Pinkston



##### Remember our list of data wrangling functions from last time:
# read_csv()
# view()
# unique()
# group_by()
# filter()
# arrange()
# select()
# mutate()
# summarize()


### Today we will work on:
## arrange rows with arrange()
## select columns with select()

library(tidyverse) ### packages

### set working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\05_arrange and select")

### read in the ucdp/prio conflict data
dat <- read_rds("UcdpPrioConflict_v19_1.rds")
dat <- as_tibble(dat)

### last time we learned about filter, so let's use that to select data from the most recent year
max(dat$year)
dat_2018 <- dat %>% filter(year==max(dat$year))

#### note functions min() and max()

########################################################
### ok, let's play around with arrange()
########################################################

### how is the data currently arranged? (location)

### let's arrange by side_b
dat_2018 %>% arrange(side_b) %>% view()

### arrange by intensity level
dat_2018 %>% arrange(intensity_level) %>% view()

### no, i want the highest intensity level on top (i.e., descending order)
dat_2018 %>% arrange(desc(intensity_level)) %>% view()


### what's the longest running conflict that's still going on?
dat_2018 %>% arrange(start_date) %>% view()

### can i sort by region and start_date? yes.
dat_2018 %>% arrange(region, start_date) %>% view()


#######################################################
#### now, select()
#######################################################

### use select() to select columns. kind of like filter() for rows,
### but here you are always dealing with character strings (i.e., column names)

### let's review what the column names are
names(dat)

### give me a dataset with just side_a, side_b, location and start_date
dat_2018 %>% select(side_a, side_b, location, start_date) %>% view()
names(dat_2018_reduced)
### notice that the order of the columns has changed from the original dataset

### you can also use select() to re-order columns
### let's saw i want to keep all the columns, but start_date and intensity near the front
dat_2018 %>% select(conflict_id, location, start_date, intensity_level, everything()) %>% view


### select all columns between conflict_id and year
dat_2018 %>% select(conflict_id:year) %>% view()
# OR
dat_2018 %>% select(-(intensity_level:version)) %>% view


### select all columns between conflict_id and year but not territory_name
dat_2018 %>% select(conflict_id:year, -territory_name) %>% view()

### select all columns between location and year plus start_date but minus territory name
dat_2018 %>% select(location:year, start_date, - territory_name) %>% view()

### there are some useful helper functions:
## starts_with("abc"): matches names that begin with “abc”

## ends_with("xyz"): matches names that end with “xyz”

## contains("ijk"): matches names that contain “ijk”

## num_range("x", 1:3): matches x1, x2 and x3.

### select all columns that refer to side_a
dat_2018 %>% select(starts_with("side_a")) %>% view()

### select all columns that refer to a date
dat_2018 %>% select(contains("date")) %>% view()

### select all columns that give an id or a date
dat_2018 %>% select(ends_with("id") | contains("date")) %>% view()

### finally, renaming variables
dat_2018 %>% rename(territory = territory_name,
                    region_num = region) %>% view()


#### Exercise 5
#### Load the ACLED data you have been working with for exercises
#### Filter for just the most recent year and one of the countries
#### Arrange events by fatalities, highest to lowest. What types of events or actors have the highest-fatality events?
#### Arrange events so that the ones missing admin3 are at the top (hint: use is.na())
#### Arrange events by actor1 and actor2 (at the same time--you should have ordered pairs)
#### Is it hard to see if you have ordered pairs? Move the actor1 and actor2 columns so that they are together, and arrange them again.
#### Rename actor1 and actor2 to actor_1 and actor_2
#### Select all the variables that end with "1" except for admin1
#### Select all the variables that include "event" except for "event_id_cnty" and "event_id_no_cnty"
#### Select all the variables from event_date to fatalities

