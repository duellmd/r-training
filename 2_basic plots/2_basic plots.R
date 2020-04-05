### Lesson 2: Basic Plots
#### Amanda Pinkston
#### April 5, 2020

library(tidyverse) ### load packages


### set the working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\2_basic plots") 

### read the data
dat <- read_csv("2015-01-01-2020-03-28-Nigeria.csv")


#### last time, we summarized by variables that were already in the data
tab <- dat %>% group_by(year) %>%
  summarize(events=n(), fatalities=sum(fatalities))


#### there was a quesiton about sorting the tibble
tab %>% arrange(desc(events)) ## arrange by events, most to least
tab %>% arrange(fatalities) ### arrange least to most


#### here's how to plot tab1 as a line graph:
ggplot(data=tab, aes(x=year, y=events)) +
  geom_line()


#### let's show events by event_type
tab <- dat %>% group_by(year, event_type) %>%
  summarize(events=n(), fatalities=sum(fatalities))

ggplot(data=tab, aes(x=year, y=events, color=event_type)) +
  geom_line()

#### let's plot fatalities instead, add a title,
#### change the axis titles, and get rid of the legend title
ggplot(data=tab, aes(x=year, y=fatalities, color=event_type)) +
  geom_line() +
  labs(title="Fatalities by Event Type, 2015-2020",
       x="Year",
       y="Fatalities") +
  theme(legend.title=element_blank())


### what if we want to show events and fatalities?

### first, need to re-organize the data
tab <- tab %>% gather(key="category",
                      value="value",
                      c(events, fatalities))


### now let's plot
ggplot(data=tab, aes(x=year, y=value, color=category)) +
  geom_line()


###### hmmm, looks weird
### this is because it's summing for each year.
### two options to fix:
### 1. make a bar plot instead (not ideal, because we want to show trends over time)
ggplot(data=tab, aes(x=year, y=value, fill=category)) +
  geom_bar(stat="identity", position=position_dodge())

#### 2. resummarize the data over the event_type column,
#### and make a line plot... you can keep the pipe going!
tab %>% group_by(year, category) %>%
  summarize(value=sum(value)) %>%
  ggplot(aes(x=year, y=value, color=category)) +
  geom_line()


### what if I want my data back into wide format
### (because maybe you are doing a regression or something)
### remember what tab looks like:
tab

tab <- tab %>% spread(event_type, value)


### Here are some things that people want to know how to do

### there was a question about ordering by quarter.
### here's how to do that:
library(zoo) ### load the zoo package
dat$date <- as.Date(dat$event_date, format="%d %B %Y")
dat$quarter <- as.yearqtr(dat$date)

### then plot by quarter and plot
dat %>% group_by(quarter) %>%
  summarize(events=n(), fatalities=sum(fatalities)) %>%
  ggplot(aes(x=quarter, y=events)) +
  geom_line() +
  geom_point() +
  theme(axis.text.x=element_text(angle=-45, hjust=0.001))


### Exercise for next time:
### 1. Use the same data file you had for the previous exericse
### 2. Create a table that shows the number of events by year and country
### 3. Make a line plot that shows the number of events on the y-axis, year on the x-axis,
####### and country as line color
### 4. Create a table that shows the number of events by event_type and country
### 5. Make a bar graph that shows the number of events by event_type and country

