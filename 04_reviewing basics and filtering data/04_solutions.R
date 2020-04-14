##### Exercise #4 Solution
##### Amanda Pinkston
##### April 14, 2020


##### load the packages
library(tidyverse)
library(httr) ### for using APIs

##### set the working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\04_reviewing basics and filtering data")

### download data with the API

#### 1. create the path name
base_path <- "https://api.acleddata.com/acled/read.csv?terms=accept"
country <- "country=Mali|Burkina%20Faso"
year <- "year=2015|2016|2017|2018|2019"
path <- paste(base_path, country, year, "limit=0", sep="&")

### 2. create the name to give to the downloaded file
##### I attach the date so I know when it was downloaded
filename <- paste(Sys.Date(), "acled.csv", sep="_")

### 3. Download the file
download.file(url=path, destfile=filename)

### 4. Load it into R
dat <- read_csv(filename)


##### Filtering exercises

#### Exercise:
## 2. Include country A only

country_a <- dat %>% filter(country=="Mali")

## 3. Include the most recent year of data only

most_recent_year <- dat %>% filter(year == max(year))

## 4. Exclude events that do not have admin3 information

includes_admin3 <- dat %>% filter(!is.na(admin3))

## 5. Exclude events that have fewer than 100 fatalities

fatalities_100_plus <- dat %>% filter(fatalities >= 100)

## 6. Exclude events without a specified associated actor 1

include_assoc_actor_1 <- dat %>% filter(!is.na(assoc_actor_1))

## 7. Include only four types of sub-events: 
## Attack, Mob violence, Violent demonstration, and Armed clash

subs <- dat %>% filter(sub_event_type %in% c("Attack", "Mob violence", "Violent demonstration", "Armed clash"))

## 8. Include only events that happen in the capital region of each country

capitals <- c("Bamako", "Centre")
capital_events <- dat %>% filter(admin1 %in% capitals)
