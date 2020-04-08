#### Manipulating Data Frames
#### Amanda Pinkston
#### April 7, 2020

#### First: let's see the bar charts!


### ok, load tidyverse
library(tidyverse)

### set your working directory
setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\03_manipulating data frames")

### load the data file
dat <- read_csv("2015-01-01-2020-03-28-Nigeria.csv")

### The goal today is to learn how to refer to specific rows or columns
### so that you can manipulate them. Also some miscellaneous goodies.

### First, let's group by event_type, and
### summarize by total events, total fatalities and median fatalities
tab <- dat %>% group_by(event_type) %>%
  summarize(events=n(), fatalities_tot=sum(fatalities), fatalities_median=median(fatalities))

### Ok, let's take a look.
view(tab %>% arrange(fatalities_tot))

### most of the fatalities are violence against civilians.
### who is committing the violence?
### just look at VAC events, and then group by interaction code
### so first, subset

#vac <- dat[dat$event_type==""].... hmm, what are the event_types called exactly?
unique(dat$event_type)
### take 2: the traditional way
vac <- dat[dat$event_type=="Violence against civilians",] 
### the rows and columsn of data frames (and tibbles) are referenced like this:
### name_of_data.frame_object[rows, columns]

#OR the piping way:
vac <- dat %>% filter(event_type=="Violence against civilians")

### now, group by interaction code and year,
### and summarize events and fatality totals
vac_tab <- vac %>% group_by(year, interaction) %>%
  summarize(events=n(), fatalities=sum(fatalities))

### take a look
view(vac_tab)

### let's plot trends for each interaction code over time
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=interaction)) +
  geom_line() +
  geom_point()

### the problem is that R is reading interaction as a number.
### we need to change it to a factor
vac_tab$interaction <- factor(vac_tab$interaction)
### note how the column was called and manipulated

### ok, try the plot again
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=interaction)) +
  geom_line() +
  geom_point()

### why is everything so low in 2020? not a full year of data. get rid of it.
vac_tab <- vac_tab %>% filter(year < 2020)
#OR
vac_tab <- vac_tab %>% filter(year != 2020)
#OR
vac_tab <- vac_tab[vac_tab$year != 2020,]

### try again
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=interaction)) +
  geom_line() +
  geom_point()

### ok, this is good if it's just for look-sees, but what if we want to
### show it to someone who is not so familiar with ACLED interaction codes?

### many options, we'll do 3:
### 1. create a table with the interaction code and corresponding descriptive label,
### then merge with vac_tab
inter_label <- data.frame(interaction=c(17,27,37,47,78),
                             description=c("State forces", "Rebels", "Terrorists",
                                           "Ethnic militias", "External forces"))
vac_tab <- merge(vac_tab, inter_label, by="interaction")

### when you do the plot, do color by description
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=description)) +
  geom_line() +
  geom_point()

### 2. add a description column to vac_tab with ifelse statements
### then plot as in method 1
vac_tab$description <- ifelse(vac_tab$interaction==17, "State forces",
                              ifelse(vac_tab$interaction==27, "Rebels",
                                     ifelse(vac_tab$interaction==37, "Terrorists",
                                            ifelse(vac_tab$interaction==47, "Ethnic militias",
                                                   ifelse(vac_tab$interaction==78, "External forces",
                                                          "Error")))))
### plot
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=description)) +
  geom_line() +
  geom_point()

### 3. set the labels directly in the plot
ggplot(data=vac_tab, aes(x=year, y=fatalities, color=description)) +
  geom_line() +
  geom_point() +
  scale_color_discrete(name=element_blank(),
                       labels=c("State forces", "Rebels", "Terrorists",
                                "Ethnic militias", "External forces"))


#### last trick: facet_wrap
### Let's say I want to do plotfatalities by event_type over time,
### but also by region
### first, let's group and summarize the data (remembering to cut 2020)
tab <- dat %>% filter(year < 2020) %>%
  group_by(admin1, year, event_type) %>%
  summarize(fatalities=sum(fatalities))

### we're going to make a plot of fatalities over time by event type
### with a separate plot for each region
g <- ggplot(data=tab, aes(x=year, y=fatalities, color=event_type)) +
  geom_line() +
  geom_point() +
  facet_wrap(~admin1)

g

### and then we'll make it look a little nicer:
g + labs(title="Fatalities by Event Type and Region in Nigeria",
       x="Year",
       y="Fatalities") +
  theme(legend.title=element_blank()) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))


#### Exercise:
### Load the data you used for the previous exercise (should have two countries, five years)
### create a new dataframe (or tibble) that includes only interaction codes with a 7 in them
######### hint: create a vector with all the applicable interaction codes
########### and use ifelse with %in% (also use google to figure out what %in% means)
### from this dataframe calculate the number of fatalities by country, year, and actor1
### for each country, keep the top 3 actor1s (top-3 in fatalities), and call the others "Other"
####### hint: arrange() can take multiple arguments
### for each country, plot fatalites by the top 3 actors + "other" over time
### give you plot a title =)


  
