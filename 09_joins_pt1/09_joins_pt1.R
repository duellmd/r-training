##### Chapter 13: Joins (Merging datasets)
##### Amanda Pinkston
##### April 28, 2020

 
### Today we learn some terms and functions for "joining" (merging) datasets.
### Key terms: mutating join, keys
### Key functions: inner_join(), left_join(), right_join(), full_join()

### A "mutating join" adds new variables to one data frame from matching observations in another
### Recall that in a typical data structure, variables are columns and observations are rows

### Observations are matched via a "key".
### A key is a variable (or set of variables) that uniquely identifies an observation.

library(tidyverse) ### load libraries

## set working directory
setwd("C:\\Users\\Amanda Pinkston\\Documents\\work stuff\\r training\\09_joins_pt1")

### read in the first data set: pop density data for admin1-level in Colombia
pop_den <- read_csv("Popden_admin1.csv")

### read in the second data set: ACLED data for Colombia
acled <- read_csv("Colombia ACLED.csv")


### We are going to want to join by Admin1 Name

### First problem: ACLED data is an event dataset... some admin1's will have many observations, others will have none

### What is our PRIMARY dataset?
### I.e., the one with complete observations to which we want to add more variables?
### Answer: pop_den

### So the first step is to summarize ACLED data by Admin1, to make it compatible with the primary dataset
### Let's say we want to know total events, # non-violent protests, # other events, and # fatalities
acled_tab <- acled %>% group_by(admin1) %>% ### group by admin1
  filter(event_type != "Strategic developments") %>% ## filter out events that are strategic events
  summarize(total_events=n(),
            protests=sum(event_type=="Protests"),
            violent_events=sum(event_type != "Protests"),
            fatalities=sum(fatalities))

## Now we can join the data.

### Options are:
### inner_join(x, y) keeps only observations that are in both x and y
### left_join(x, y) keeps all observations in x, drops non-matching observations of y
### right_join(x, y) keeps all observations in y, drops non-matching observations of x
### full_join(x, y) keeps all observations of both x and y, regardless of match

### Let's start with a left join.
### Assuming that all admin1s are accounted for in pop_den,
### we want to add variables from acled_tab.

### What is the key?
names(pop_den)
names(acled_tab)

pop_den_acled <- left_join(x=pop_den, y=acled_tab, by="admin1")

### take a look
view(pop_den_acled)

### notice some NAs for some observations on the acled_tab variables.
### Are these actually missing from acled_tab, or are was there a problem with the keys?

### Check your knowledge: why might there be mistakes if acled_tab were the primary dataset?

### What if we want to calculate the rate of fatalities per capita over time?
### Let's do the same summary as in acled_tab, but also group by quarter
library(lubridate) ### library for the date functions

acled_tab_qtr <- acled %>% mutate(date=as.Date(event_date, format="%d-%b-%y"), ### create a date column
                                  quarter=quarter(date)) %>% ### create a quarter column
  group_by(admin1, year, quarter) %>% ### group by admin1 and quarter
  filter(event_type != "Strategic developments") %>% ## filter out events that are strategic events
  summarize(total_events=n(),
            protests=sum(event_type=="Protests"),
            violent_events=sum(event_type != "Protests"),
            fatalities=sum(fatalities))

### For the pop_den data, let's assume that the population estimate is valid for Q1 in 2019, and that there is some
### growth function over time. Here I re-make the dataset.
pop_est_qtr <- pop_den %>% select(admin1, PopEst) %>%
  mutate(quarter="q1") %>%
  spread(quarter, PopEst) %>%
  mutate(q2=q1+q1*.01,
         q3=q2+q2*.01,
         q4=q3+q3*.01,
         q5=q4+q4*.01) %>%
  gather(quarter, pop_est, c(q1:q5))

view(pop_est_qtr)

### ok, how do we join now? need to create a combo key: admin1, year, and quarter
### no matching quarter/year variable--need to create one

pop_est_qtr <- pop_est_qtr %>% mutate(year = ifelse(pop_est_qtr$quarter=="q5", 2020, 2019), ## create a year variable
                                      quarter_join = as.numeric(substring(pop_est_qtr$quarter, 2)), ## strip the quarter number from the quarter string
                                      quarter_join = ifelse(quarter_join == 5, 1, quarter_join)) ## change quarter #5 to a #1

#### ok, our keys our admin1, year, and quarter
#### our primary dataset is pop_est_qtr
pop_acled_qtr <- left_join(pop_est_qtr, acled_tab_qtr, by=c("admin1", "year", "quarter_join"="quarter")) %>%
  arrange(admin1)


