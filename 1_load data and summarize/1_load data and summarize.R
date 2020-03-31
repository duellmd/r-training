###### Lesson 1: Load data and calculate some summary statistics
#### Amanda Pinkston
#### March 31, 2020

### packages
#install.packages("tidyverse") ### installs the package on your computer. you only need to do this once
library(tidyverse) ### when you start a new R session, load the the package.


### load the data. here, data is called "dat".
### you can call it whatever you want, but a standard name is a good practice
### because then your code is more portable

getwd() ### look at the folder where you are working
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\1_load data and make plots") ### set the file directory to the folder where your data and R scripts are for this lesson
### note the use of two \\ for windows. For mac, I belive it's one /

###read in the spreadsheet
dat <- read_csv("2015-01-01-2020-03-28-Nigeria.csv")

### check the type of object you have created
class(dat)
### tibbles and data.frames will be the main types of objects we work with

### look at your variable names
colnames(dat)

### check how many rows there are
nrow(dat)

### you can click on the "dat" object in the environment box to look at it or type:
view(dat)
### looks just like a spreadsheet

#### summarize the number of events and fatalities by year
tab1 <- dat %>% group_by(year) %>%
  summarize(events=n(), fatalities=sum(fatalities))

### you have a new tibble! take a look
view(tab1)
colnames(tab1)
nrow(tab1)

#### summarize the number of events and fatalities by year and region
tab2 <- dat %>% group_by(year, admin1) %>%
  summarize(events=n(), fatalities=sum(fatalities))


### take a look
view(tab2)
colnames(tab2)
nrow(tab2)



#### Exercise:
#1. Download data from acled that contains 2-3 countries and 5 years
#2. Create a folder for the exercise. Put the data in the folder and create a new R script.
#3. Set your working directory, and load the packages and data
#4. Summarize events and fatalities by country and year
#5. Summarize events and fatalities by event_type
#6. Summarize events and fatalities by country and event_type
#7. Think of another summary statistic you want to calculate--
###########we will tackle the problem in the next class or a future lesson
