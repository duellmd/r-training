##### Exercise #3 Solution
##### Amanda Pinkston
##### April 8, 2020


##### load the packages
library(tidyverse)
library(httr) ### for using APIs

##### set the working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\03_manipulating data frames")

##### load the data with the ACLED API
##### I usually download by country and year, which is what is shown here,
##### but you can filter the data by any variable in the dataset

### 1. create the URL
##### note the use of %20, which is the html encoding for a space (e.g., Burkina%20Faso)
##### and since I want multiple years and multiple countries, I put | between them (which means OR)

base_path <- "https://api.acleddata.com/acled/read.csv?terms=accept"
country <- "country=Mali|Burkina%20Faso|Niger"
year <- "year=2015|2016|2017|2018|2019"
path <- paste(base_path, country, year, "limit=0", sep="&")

### 2. create the name to give to the downloaded file
##### I attach the date so I know when it was downloaded
filename <- paste(Sys.Date(), "acled.csv", sep="_")

### 3. Download the file
download.file(url=path, destfile=filename)

### 4. Load it into R
acled <- read_csv(filename)

##### OK, on to the exercise:


### 1. Load the data you used for the previous exercise (should have two countries, five years) -- done



### 2. create a new dataframe (or tibble) that includes only interaction codes with a 7 in them

inter7 <- c(17, 27, 37, 47, 57, 67, 78)

dat <- acled %>% filter(interaction %in% inter7)

### check to make sure it worked. one quick check is to make sure the number of rows decreased
nrow(acled) #4831
nrow(dat) #2018



### 3. From this dataframe calculate the number of fatalities by country, year, and actor1
tab <- dat %>% group_by(country, year, actor1) %>%
  summarize(fatalities=sum(fatalities))


### 4. For each country, keep the top 3 actor1's (top-3 in fatalities), and call the others "Other"
######### First, we need ot summarize y country and actor1
tab2 <- tab %>% group_by(country, actor1) %>%
  summarize(fatalities=sum(fatalities))

######### Then take a slice of the first three rows for each country:
############### 4A. Filter by country, order by fatalities, select the actor1 column,
###############    and put the actor1 value for the top three rows in a vector
burkina_actor1 <- tab2 %>% filter(country=="Burkina Faso") %>% ### filter by country
  arrange(desc(fatalities)) %>% ### decreasing order by fatalities
  slice(1:3) %>% ### slice off the top three rows
  pull(actor1) ### pull the values from the actor1 column

#### repeat for each country

mali_actor1 <- tab2 %>% filter(country=="Mali") %>% ### all you need to change is the country name
  arrange(desc(fatalities)) %>% 
  slice(1:3) %>%
  pull(actor1)

niger_actor1 <- tab2 %>% filter(country=="Niger") %>% ### all you need to change is the country name
  arrange(desc(fatalities)) %>% 
  slice(1:3) %>%
  pull(actor1)


### 4B. put these top-3 actor1's together
actor1_top3 <- c(burkina_actor1, mali_actor1, niger_actor1)


###### Alternatively, do eveything at once
actor1_top3 <- dat %>% group_by(country, actor1) %>%
  summarize(fatalities=sum(fatalities)) %>%
  group_nest() %>% ### nests by the first group_by variable
  mutate(top3 = map(data, function(df) { ### add a column called top3
    df %>% arrange(desc(fatalities)) %>% ### for each country, arrange actors in decreasing order of fatalities
      slice(1:3) %>% ### take the top 3 rows
      pull(actor1) ### pull the actor1 values
  })) %>%
  unnest(top3) %>% ### unnest the top3 column
  pull(top3) ### pull the values from that column
  

### 4C. now, recode your original tab data
tab$actor1_recode <- ifelse(tab$actor1 %in% actor1_top3, tab$actor1, "Other")

### 4D. summarize over "Other"
tab <- tab %>% group_by(country, year, actor1_recode) %>%
  summarize(fatalities=sum(fatalities))

### wrap the actor1 names so they aren't too long
tab$actor1_wrap <- str_wrap(tab$actor1_recode, width=20)


### last task: for each country, plot fatalites by the top 3 actors + "other" over time
ggplot(data=tab, aes(x=year, y=fatalities, color=actor1_wrap)) +
  geom_line() +
  geom_point() +
  labs(title="Top 3 Perpetrators of Attacks on Civilians by Country, 2015-2019",
       x="Year",
       y="Fatalities") +
  facet_wrap(~country) +
  theme(axis.text.x=element_text(angle=45, vjust=.7)) + ### adjust the years so they don't overlap
  theme(legend.title=element_blank()) ### cut the legend title
