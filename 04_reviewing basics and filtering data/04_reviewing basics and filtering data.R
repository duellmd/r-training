##### Lesson 4: Reviewing basics and filtering data
##### April 13, 2020
##### Amanda Pinkston


### This is from https://r4ds.had.co.nz/index.html -- an excellent resource.

### There are math operations you can perform in the console:

4 + 5
6 * 9
(4 + 5) * 6
24 / 6

### Plus a lot of functions that are built into r

log(167)
exp(log(167))



#### Assignment
#####################

### You can create new objects with <-

### This is the assignment statement

### It's format is this: object_name <- value

### When reading that code say “object name gets value” in your head.


#### Object names

### Object names must start with a letter, and can only contain letters, numbers, _ and .

acled
acled_nigeria
acled.nigeria
acled2020


### You can inspect an object by typing its name:

my_char_vector <- "this is a vector of characters"
my_char_vector

my_numeric_vector <- c(1,2,3,4)
my_numeric_vector


### Functions
########################

### R has a lot of built in functions. They are called like this:

### function_names(arg1 = val1, arg2 = val2, ...)

seq(1,100,1)
?seq

#### we have been using these functions, among others:
##### ggplot(), group_by(), read_csv(), gather(), summarize()


### Quotation marks and parentheses must always come in a pair.
### RStudio does its best to help you, but it’s still possible to mess up and end up with a mismatch.
### If this happens, R will show you the continuation character “+”:

#my_char_vector <- "this is a vector of characters

#### the + character means that R is waiting for more input. Usually this is a quote or parens

##### Key functions in tidyverse for data wrangling:

# read_csv()
# view()
# unique()
# group_by()
# filter()
# arrange()
# select()
# mutate()
# summarize()


### We're going to practice filter()

#### For this, you need to know logical operators

#### and: &
#### or: |
#### not: !
#### is equal to: == (note double =)
#### is not equal to: !=
#### greater than: >
#### less than: <
#### greater than or equal to: >=
#### less than or equal to: <=
#### is missing: is.na()
#### is not missing: !is.na()
#### is in: %in%, e.g.
countries <- c("Nigeria", "Mexico", "China")
"Nigeria" %in% countries
"Afghanistan" %in% countries
!"Afghanistan" %in% countries

#### Some examples
"a" == "a"
1 == 1 
1 == 2 
1 != 2
1 < 2 
1 < 2 & 1 > 0
1 < 2 | 1 > 3
1 < 2 & 1 < 1.5 & 1 < 1.2
(1 < 2 & 2 < 3) | 3 < 2
1 !=2 & !(2==3)
"a" %in% c("a", "b", "c")
1 %in% c(1,2,3)
1 %in% c(4,5,6)


#### Now some filter exercises

library(tidyverse)

setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\04_reviewing basics and filtering data")

dat <- read_csv("2015-01-01-2020-03-28-Nigeria.csv")

#### let's read the red stuff
#### .default = col_character() means that the default type for a given column is character
#### for those that are specified, they are not the default, they are something else
#### in this case, they are all "doubles" which is a number
#### it says we can do spec(,,,) for a full column specification
#### so let's try it
spec(dat)

### ok, here is a filter example.
### let's say we want only 2015 and 2016

### what years are included in the entire dataset?
unique(dat$year) ### note how to refer to a column: object$column_name

dat_15_16_method_a <- dat %>% filter(year %in% c(2015,2016))
#did it work?
unique(dat_15_16_method_a$year)

dat_15_16_method_b <- dat %>% filter(year == 2015 | year == 2016)

dat_15_16_method_c <- dat %>% filter(year >= 2015 & year < 2017)

dat_15_16_method_d <- dat %>% filter(!year %in% c(2017, 2018, 2019, 2020))


#### Exercise:
## 1. load acled data that has at least five years and two countries, country A and country B
## 2. Include country A only
## 3. Include the most recent year of data only
## 4. Exclude events that do not have admin3 information
## 5. Exclude events that have fewer than 100 fatalities
## 6. Exclude events without a specified associated actor 1
## 7. Include only four types of sub-events: Attack, Mob violence, Violent demonstration, and Armed clash
## 8. Include only events that happen in the capital region of each country


