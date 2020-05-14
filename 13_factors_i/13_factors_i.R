##### Factors Part 1 (R for Data Science, chapter 15)
##### Amanda Pinkston
##### May 14, 2020

setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\13_factors_i")

library(tidyverse)

### Factors are used to work with categorical variables,
### variables that have a fixed and known set of possible values.
### They are also useful when you want to display character vectors
### in a non-alphabetical order.

### Functions (many from the package forcats within tidyverse):
### factor(), sort(), unique(), fct_inorder(), levels(),
### fct_reorder(), fct_relevel(), fct_reorder2(), fct_infreq(),
### fct_rev(), fct_recode(), fct_collapse(), fct_lump()

### read in the data--this is acled 2015-2019 Sudan.
### see API script at the bottom.
dat <- read_csv("2020-05-14_acled.csv")


### what type of variable is event_type currently?
class(dat$event_type)


### warning: if you use the function read.csv(),
### strings will be read in as factors unless you explicitly say not to, e.g.,
### read.csv("filename.csv", stringsAsFactors=FALSE)


### event_type is a categorical variable, what R calls a "factor"
### so let's make it a factor
dat$event_type <- factor(dat$event_type)

### check the variable type now
class(dat$event_type)

### what are the possible values for event_type?
levels(dat$event_type)

### what is the default ordering of the factor values?


### you can set the ordering however you want.
### sometimes you may want the ordering to follow the first appearance of each value

### you can do this when creating the factor:
first_appearance <- factor(dat$event_type, levels=unique(dat$event_type))
levels(first_appearance)


### or after the fact:
alpha <- factor(dat$event_type)
levels(alpha)

first_appearance <- alpha %>% fct_inorder()
levels(first_appearance)

### let's see a quick count of events by event_type
dat %>% count(event_type)

### how about a bar chart?
ggplot(dat, aes(event_type)) +
  geom_bar()

### what if we want to order the bar chart by number of events?
dat$event_type <- fct_infreq(dat$event_type)

ggplot(dat, aes(event_type)) +
  geom_bar()

### what if we want it to go the other way?
dat$event_type <- fct_rev(dat$event_type)

ggplot(dat, aes(event_type)) +
  geom_bar()


### or you can put it all in one line:
dat <- read_csv("2020-05-14_acled.csv") ### reload the data
dat %>% mutate(event_type = event_type %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(event_type)) +
  geom_bar()


### side note: str_wrap()
dat %>% mutate(event_type = event_type %>% str_wrap(15) %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(event_type)) +
  geom_bar() +
  labs(x="",
       y="Count",
       title="Sudan: Number of Events by Event Type, 2015-2019")


### let's plot average fatalities per year by admin1

fat_admin1 <- dat %>% group_by(admin1, year) %>%
  summarize(fatalities=sum(fatalities)) %>%
  ungroup() %>%
  group_by(admin1) %>%
  summarize(mean_fatalities = mean(fatalities))

ggplot(fat_admin1, aes(x=mean_fatalities, y=admin1)) +
  geom_point()


### order by mean fatalities

### within ggplot()
ggplot(fat_admin1, aes(x=mean_fatalities, y=fct_reorder(admin1, mean_fatalities))) +
  geom_point()

### or outside ggplot()
fat_admin1 %>% mutate(admin1 = fct_reorder(admin1, mean_fatalities)) %>%
  ggplot(aes(x=mean_fatalities, y=admin1)) +
  geom_point()


### what if we want to add "total" for all of Sudan?

### calculate/add the row
years_tab <- dat %>% group_by(year) %>%
  summarize(fatalities=sum(fatalities)) 

total_mean <- mean(years_tab$fatalities)

tab_with_tot <- fat_admin1 %>% add_row(admin1="Total", mean_fatalities=total_mean)


### plot
tab_with_tot %>% mutate(admin1 = fct_reorder(admin1, mean_fatalities)) %>%
  ggplot(aes(x=mean_fatalities, y=admin1)) +
  geom_point()


### what if we want the total on the bottom?


tab_with_tot %>% mutate(admin1 = admin1 %>% fct_reorder(mean_fatalities) 
                        %>% fct_relevel("Total")) %>%
  ggplot(aes(x=mean_fatalities, y=admin1)) +
  geom_point()


### let's look at number of events by event_type over time

### make the table
events_tab <- dat %>% group_by(event_type, year) %>%
  summarize(events=n())

### plot
ggplot(events_tab, aes(x=year, y=events, color=event_type)) +
  geom_line()


### make the plot nicer by ordering the legend according to the order of the lines
ggplot(events_tab, aes(x=year, y=events,
                       color=fct_reorder2(event_type,year,events))) +
  geom_line() +
  labs(color="Event Type")



### the end.



#### API script to download the data

#### 1. create the path name
base_path <- "https://api.acleddata.com/acled/read.csv?terms=accept"
country <- "country=Sudan"
year <- "year=2015|2016|2017|2018|2019"
path <- paste(base_path, country, year, "limit=0", sep="&")

### 2. create the name to give to the downloaded file
##### I attach the date so I know when it was downloaded
filename <- paste(Sys.Date(), "acled.csv", sep="_")

### 3. Download the file
download.file(url=path, destfile=filename)