##### Chapter 13: Joins (Merging datasets)
##### Amanda Pinkston
##### April 30, 2020

 
### Today we learn some more terms and functions for "joining" (merging) datasets.
### Key terms: filtering join
### Key functions: semi_join(), anti_join()

### A "filtering join" matches observations in the same way as a mutating join,
### but affect the observations (rows) not the variables (columns)

### Somewhat confusing, becuase rows are routinely dropped in mutating joins if there
### are no matching observations. The difference with a filtering join is that no variables
### are added.

library(tidyverse) ### load libraries

## set working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r training\\10_joins_pt2")



### let's read in the first joined table we created last time
pop_den_acled <- read_csv("join table 1.csv")

### take a look at the data
view(pop_den_acled)


### See the NA's on the merged ACLED columns.
### Could be that there were no ACLED events for that Admin1
### (in which case, no error, just change NAs to 0s)
### But could also be that there was a mismatch in the keys,
### in which case we do have an error.

### This time, we will go over some functions for identifying the propblems,
### And next week, we will learn about functions for fixing them.

### Load up the original data
### read in the first data set: pop density data for admin1-level in Colombia
pop_den <- read_csv("Popden_admin1.csv")

### read in the second data set: ACLED data for Colombia
acled <- read_csv("Colombia ACLED.csv")

### turn the acled into a table by admin1, same as last time
acled_tab <- acled %>% group_by(admin1) %>% ### group by admin1
  filter(event_type != "Strategic developments") %>% ## filter out events that are strategic events
  summarize(total_events=n(),
            protests=sum(event_type=="Protests"),
            violent_events=sum(event_type != "Protests"),
            fatalities=sum(fatalities))


### the function anti_join(x, y) drops all observations in x that have a match in y,
### leaving us with the ones that don't have a match. Perfect for debugging.

### Here, we know that the pop_den data includes all admin1s.
### So the mistakes are when there is an admin1 in acled_tab that are not matched.

anti_join(x=acled_tab, y=pop_den, by="admin1") %>%
  select(admin1) ### just show us the admin1s that didn't match

### Now we need to find what the keys look like for pop_den;
### reverse the order of x and y
anti_join(x=pop_den, y=acled_tab, by="admin1") %>%
  select(admin1) ### just show us the admin1s that didn't match

### Hmm... what's up with Valle Del Cauca?
pop_den$admin1
acled_tab$admin1

### so some string functions that are usually very helpful:
### turn everything to lower case
### get rid of all punctuation

### let's go ahead and do that (with more to come next week)
pop_den$admin1 <- tolower(pop_den$admin1)
pop_den$admin1 <- str_remove_all(pop_den$admin1, "[\\.,]")

### do it for the acled data, then need to recreate acled_tab
acled$admin1 <- tolower(acled$admin1)
acled$admin1 <- str_remove_all(acled$admin1, "[\\.,]")

acled_tab <- acled %>% group_by(admin1) %>% ### group by admin1
  filter(event_type != "Strategic developments") %>% ## filter out events that are strategic events
  summarize(total_events=n(),
            protests=sum(event_type=="Protests"),
            violent_events=sum(event_type != "Protests"),
            fatalities=sum(fatalities))

### will everything in acled_tab get matched up?
anti_join(x=acled_tab, y=pop_den, by="admin1") %>%
  select(admin1) ### perfect

### now do the merge again
pop_den_acled <- left_join(x=pop_den, y=acled_tab, by="admin1")

### check the table
view(pop_den_acled)

###turn the remaining NAs into 0s
pop_den_acled <- pop_den_acled %>%
  replace_na(list(total_events=0, protests=0, violent_events=0, fatalities=0))


### ok, now semi_join(). This is good for matching filtered summary tables back to the original rows.
### semi_join() keeps all observations in x that have a match in y

### Suppose we want to know in which admin1s the most deadly VAC actor1s operate in:
top_vac_actors <- acled %>% filter(event_type == "Violence against civilians") %>%
  group_by(actor1) %>%
  summarize(fatalities=sum(fatalities)) %>%
  arrange(desc(fatalities)) %>%
  head(10) ## take the top 10

### typical: unidentified actor is at the top :/
### filter them out and take the subsequent top 10
top_vac_actors <- acled %>% filter(event_type == "Violence against civilians") %>%
  group_by(actor1) %>%
  summarize(fatalities=sum(fatalities)) %>%
  arrange(desc(fatalities)) %>%
  slice(2:11) ### select rows 2 through 11


### Now we filter the ACLED data based on the top VAC actor1s and summarize
acled_vac_tab <- semi_join(x=acled, y=top_vac_actors, by="actor1") %>%
  group_by(admin1) %>%
  summarize(events=n()) %>%
  arrange(desc(events))
