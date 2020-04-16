##### Lesson 6: Mutate and Summarize
##### Amanda Pinkston
##### April 16, 2020


### Today we look at mutate() and summarize(),
### to wrap up our section on data transformation.

### load libraries
library(tidyverse)

### set working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\06_mutate and summarize")


### load data
dat <- read_csv("world bank data.csv")


#### It's often useful to add new columns that are functions of existing columns.
#### This is what mutate() is for.

### take a look at the column names
names(dat)

### we have gdp and population total. let's do gdp per capita:
dat %>% mutate(gdppc = gdp_current_us / pop_tot) %>% view

### we have fuel exports as a percentage of merchandise exports and
### merchandise exports in current USD. let's calculate the value of
### fuel exports in current USD:
dat %>% mutate(fuel_exports_current_us = fuel_exports_pct_merch_exports / 100 * merch_exports_current_us) %>%
  view()

### you can refer to columns that you just created.
dat %>% mutate(fuel_exports_current_us = fuel_exports_pct_merch_exports / 100 * merch_exports_current_us,
               fuel_exports_per_capita = fuel_exports_current_us / pop_tot) %>%
  view()

### if you only want to keep the new variables, use transmute()
dat %>% transmute(country, year,
                  fuel_exports_current_us = fuel_exports_pct_merch_exports / 100 * merch_exports_current_us,
                  fuel_exports_per_capita = fuel_exports_current_us / pop_tot) %>%
  view()

#### Frequently useful functions:

### Arithmetic operators: +, -, *, /, ^

### Aggregate functions, such as sum(), mean()

### Modular arithmetic: %/% (integer division) and %% (remainder).
######## Modular arithmetic allows you to break up integers into pieces.

### Logs: log(), log2(), log10();
######## Logs are useful for data that ranges across orders of magnitude, also
######## converts multiplicative relationshps to additive, which is great for
######## linear regression.

### Offsets: lead() and lag() allow you to compute running differences,
######## e.g., x - lag(x) or find when values change (x != lag(x))
x <- c(1:10)
x
lag(x)
lag(x,2)
lead(x)

### Cumulative and rolling aggregates: cumsum(), cumprod(), cummin(), cummax(), cummean()
##### E.g.:
x
cumsum(x)
cummean(x)


### Logical comparisons (what we learned about in filter())
####### <, <=, >, >=, ==, !=

### Ranking, such as min_rank()
y <- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))

###################################################
############## OK, moving on to summarize()
#####################################################

### summarize() collapses data into a single row.
### most powerful when used in combination with group_by()
### can use all the same functions above that you would use for mutate()

dat %>% group_by(country) %>%
  summarize(avg_gdp = mean(gdp_current_us),
            avg_pop = mean(pop_tot)) %>%
              view()

### add a mutate()!
dat %>% group_by(country) %>%
  summarize(avg_gdp = mean(gdp_current_us),
            avg_pop = mean(pop_tot)) %>%
  mutate(avg_gdppc = avg_gdp / avg_pop) %>%
  view()

## add an arrange()
dat %>% group_by(country) %>%
  summarize(avg_gdp = mean(gdp_current_us),
            avg_pop = mean(pop_tot)) %>%
  mutate(avg_gdppc = avg_gdp/ avg_pop) %>%
  arrange(avg_gdppc) %>%
  view()

### note the NAs at the bottom. If appropriate, use na.rm = T
dat %>% group_by(country) %>%
  summarize(avg_gdp = mean(gdp_current_us, na.rm = T),
            avg_pop = mean(pop_tot)) %>%
  mutate(avg_gdppc = avg_gdp/ avg_pop) %>%
  arrange(avg_gdppc) %>%
  view()

### combine with filter: let's look only at oil countries
dat %>% group_by(country) %>%
  summarize(avg_fuel_exports = mean(fuel_exports_pct_merch_exports, na.rm = T),
            avg_gdp = mean(gdp_current_us, na.rm = T),
            avg_pop = mean(pop_tot),
            avg_gdppc = avg_gdp / avg_pop) %>%
  filter(avg_fuel_exports > 10) %>%
  arrange(desc(avg_fuel_exports)) %>%
  view()

### find the two years with the highest gdp for each country
dat %>% group_by(country) %>%
  filter(rank(desc(gdp_current_us)) <= 2) %>%
  select(country, year, gdp_current_us) %>%
  arrange(country) %>%
  view()

### let's see if there's a relationship between fuel exports and gdp
dat %>% group_by(country) %>%
  summarize(avg_fuel_exports = mean(fuel_exports_pct_merch_exports, na.rm = T),
            avg_gdp = mean(gdp_current_us, na.rm = T)) %>%
  ggplot(aes(x=avg_fuel_exports, y=log(avg_gdp))) +
  geom_point() +
  geom_smooth(se=FALSE)

### last trick: show country codes instead of points
dat %>% group_by(country, country_code) %>%
  summarize(avg_fuel_exports = mean(fuel_exports_pct_merch_exports, na.rm = T),
            avg_gdp = mean(gdp_current_us, na.rm = T)) %>%
  ggplot(aes(x=avg_fuel_exports, y=log(avg_gdp))) +
  geom_text(aes(label=country_code)) +
  geom_smooth(se=FALSE)


### trends over time with dates: as.Date(acled$event_date, format="%m/%d/%Y")
### summarize with dates:
library(lubridate)

acled_data <- read_csv("2015-01-01-2020-03-28-Nigeria.csv")

### to summarize the number of events and fatalities by week:
acled_data %>% mutate(date=as.Date(event_date, format="%d %B %Y")) %>%
  group_by(week = week(date)) %>%
  summarize(events=n(), fatalities=sum(fatalities)) %>% view()

## or
acled_data %>% mutate(date=as.Date(event_date, format="%d %B %Y")) %>%
  group_by(week = floor_date(date, unit="week")) %>%
  summarize(events=n(), fatalities=sum(fatalities)) %>% view()

### same for quarter, month
