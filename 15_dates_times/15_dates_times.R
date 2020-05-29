#####################
## Dates and Times ## 
## Gray Barrett    ##
## May 29, 2020    ##
#####################

#### Dates and Times
setwd("~/Downloads/CSO/Training/r-training-master")
library(tidyverse)
path <- "https://api.acleddata.com/acled/read.csv?terms=accept&country=Democratic_Republic_Of_Congo&event_date=2018-01-01|2020-0-29&event_date_where=BETWEEN&limit=0"
download.file(path,"acled_temp.csv")
df <- read.csv("acled_temp.csv", head = T)

# Most of the work with dates and times involves the lubridate package from tidyverse
# install.packages("lubridate")
library(lubridate)

# First, let's convert our event date field into a factor
class(df$event_date)

# We specify the format for the date -- this helps down the road
df$date <-ymd(df$event_date)
class(df$date)

# By converting it into the "Date" data type, now we can manipulate and pull out elements that we're interested in:
years <- year(df$date)
head(years) # Neat-o
# Too bad ACLED already has the date field

# But it doesn't have month or day!
df$month <- month(df$date)
df$day <- day(df$date)
head(df$day) # How neat is that

# You could use this if you accidentally forgot to filter your ACLED data or only wanted a couple of days for some reason
# Any good use cases?

# Say you wanted only events that happened on Mondays or on a specific day of the year?
df$weekday <- wday(df$date)
head(df$weekday)
# Weekdays, spelled out:
df$weekday <- wday(df$date, label = T)
head(df$weekday)
df$weekday <- wday(df$date, label = T, abbr = F)
head(df$weekday)

# When do most events occur?
df %>% 
  ggplot(aes(x = weekday)) +
  geom_bar()

df$month <- month(df$date, label = T, abbr = F)

df %>% 
  ggplot(aes(x = month)) +
  geom_bar()+
  theme(axis.text.x = element_text(angle = 90))


# Durations ---------------------------------------------------------------

today() # Pretty obvious what this does
# You can also find durations
dur <- today() - max(df$date) # Automatically in days
as.duration(dur) # Automatically in weeks

# We can also use this to tell us how many weeks, days, minutes, etc are in each unit
dur <- as.numeric(dur)

# These can be useful for figuring out durations between two points in time
dhours(dur)
ddays(28)

# You can also add things to them
(tomorrow <- today() + 1)



# Periods -----------------------------------------------------------------

# Lubridate also has periods, which might be useful:

days(1)
weeks(5)
months(1:2)
years(1) / days(1) # You can also do basic functions with these

# TL;DR: Lubridate's a helpful package that you shouldn't have to deal with too much if you're primarily using ACLED. Still, it's another great set of tools to know!