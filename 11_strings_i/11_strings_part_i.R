####################
## Strings Part I ## 
## Gray Barrett   ##
## May 6, 2020    ##
####################

#### Strings!
setwd("~/Downloads/CSO/r-training-master")
library(tidyverse)
# library(stringr) You don't need to load it in separately, but stringr is the R package in the tidyverse that will help us sort out these strings

# String Basics -----------------------------------------------------------

# What is a string?
string1 <- "This is a string."
string2 <- 'This is also a string.'
# NB: there is no difference between using single and double quotes in R. I'd just use one of them and stick with it!
# If you want to include a quote in a quote (meta), then you can use both types. Like this:
string3 <- "This is also also a 'string'"

# Always forget to close strings! If you don't, you can always hit ESC to stop the command
# In order to use just one quotation mark in the string, you can use \ to escape it. For example:
double_quote <- "\""
writeLines(double_quote)

# or
double_quote <- '"'
writeLines(double_quote)

# One more:
x <- c("\"", "\\")
writeLines(x)
#Notice what it did here -- because one \ indicates that you want to escape the quotes, then you need to use two to indicate the string form of \

# We can also store a set of strings in a character vector like this:
countries <- c("Nigeria", "Democratic Republic of Congo", "Somalia", NA)
countries


# Stringr is a great package that helps sort these out. All of the functions within stringr begin with "str"
# For example, str_length gives us the number of characters in each string
str_length(countries) # Note that the spaces count as characters

# Combining Strings -------------------------------------------------------

# We can combine the elements of a string like this:

str_c(c("Nigeria", "Democratic Republic of Congo", "Somalia"), collapse = ", ")

extra_country <- "Ethiopia"

# What happens if we do this?
str_c(extra_country, countries)
# What is happening here?

# Let's try another approach
str_c(c(extra_country, countries))

# What about another way? Since we have an NA in our dataset, why not stick Ethiopia in there?
(df <- str_replace_na(countries, replacement = extra_country))

# Let's form them into a list of countries:
country_list <- str_c(df, collapse = ", ")
writeLines(country_list)


# Subsetting --------------------------------------------------------------

# Say we only want a part of the string in a certain column. str_sub will let us subset the string based on the number of characters:
str_sub(countries, 1, 14) # This takes the following arguments: str_sub(character/string name, starting character number, ending character number)
# If we wanted to start at the end, we can do that as well
str_sub(countries, -6, -1) # Does R start at 1 or 0?


# Changing Cases ----------------------------------------------------------

# What about modifying cases?
str_to_lower(countries) # Self-explanatory
str_to_upper(countries) # This one, too!
str_to_title(countries) # What's this one do?

x <- str_wrap(countries)
x
writeLines(x)


# Matching ----------------------------------------------------------------

# str_view is good for testing our matching functions to make sure we are getting what we want
str_view(df, "Dem") # Neat
str_view(df, "^E") # What are these doing?
str_view(df, "a$")

# str_detect gives us a TRUE or FALSE for each value, depending on whether it's in the data
str_detect(df, "Dem") 
str_detect(df, "^E") 
str_detect(df, "a$")

# How would we turn these into binaries?
(y <- as.numeric(str_detect(df, "a$")))

# What proportion of the countries in our list end in "a"?
mean(str_detect(df, "a$")) # 75%

# What proportion of the countries in our list end in vowels?
mean(str_detect(df, "[aeiou]$")) # all of them!

# What if I want to keep only those that end in an "a"?
str_subset(df, "a$")

# Note that this is identical to this:
dat <- as.tibble(df)
dat %>% 
  filter(str_detect(country, "a$"))


## Next time we will work through how to apply this to some ACLED data. Please send me and Amanda common problems you have that you think can be alleviated through the use of R's string functions!
