##### Exercise 5 Solutions
##### Amanda Pinkston
##### April 16, 2020

#### Exercise 5
#### Load the ACLED data you have been working with for exercises
#### Filter for just the most recent year and one of the countries
#### Arrange events by fatalities, highest to lowest. What types of events or actors have the highest-fatality events?
#### Arrange events so that the ones missing assoc_actor_1 (changed from admin3 in original exercise)
############# are at the top (hint: use is.na())
#### Arrange events by actor1 and actor2 (at the same time--you should have ordered pairs)
#### Is it hard to see if you have ordered pairs? Move the actor1 and actor2 columns so that they are together, and arrange them again.
#### Rename actor1 and actor2 to actor_1 and actor_2
#### Select all the variables that end with "1" except for admin1
#### Select all the variables that include "event" except for "event_id_cnty" and "event_id_no_cnty"
#### Select all the variables from event_date to fatalities


library(tidyverse)

setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\05_arrange and select")

dat <- read_csv("2020-04-14_acled.csv")

#### Filter for just the most recent year and one of the countries
dat_filter <- dat %>% filter(country=="Burkina Faso" & year == max(year))

#### Arrange events by fatalities, highest to lowest.
#### What types of events or actors have the highest-fatality events?
dat_filter %>% arrange(desc(fatalities)) %>% 
  select(event_type, actor1, actor2, fatalities)

#### Arrange events so that the ones missing assoc_actor1 are at the top (hint: use is.na())
dat_filter %>% arrange(desc(is.na(assoc_actor_1))) %>% view()

#### Arrange events by actor1 and actor2 (at the same time--you should have ordered pairs)
dat_filter %>% arrange(actor1, actor2) %>% 
  select(actor1, actor2) %>% view()

#### Move the actor1 and actor2 columns so that they are together, and arrange them again.
dat_filter %>% select(actor1, actor2, everything()) %>%
  arrange(actor1, actor2) %>% view()

#### Rename actor1 and actor2 to actor_1 and actor_2
dat_filter %>% rename(actor_1 = actor1,
                      actor_2 = actor2) %>% names()

#### Select all the variables that end with "1" except for admin1
dat_filter %>% select(ends_with("1"), -admin1) %>% names()

#### Select all the variables that include "event" except for "event_id_cnty" and "event_id_no_cnty"
dat_filter %>% select(contains("event"), -contains("cnty")) %>% names()

#### Select all the variables from event_date to fatalities
dat_filter %>% select(event_date:fatalities) %>% names()
