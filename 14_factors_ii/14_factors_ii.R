##### Factors Part 1 (R for Data Science, chapter 15)
##### Amanda Pinkston
##### May 14, 2020

setwd("C:\\Users\\Amanda\\Documents\\work stuff\\r-training\\14_factors_ii")

library(tidyverse)

### Last time, we went over how to create factors, put them in order,
### with applications for plots. Now we will go over modifying factor levels.

### Functions (many from the package forcats within tidyverse):
### factor(), sort(), unique(), fct_inorder(), levels(),
### fct_reorder(), fct_relevel(), fct_reorder2(), fct_infreq(),
### fct_rev(), fct_recode(), fct_collapse(), fct_lump()

### read in the data--using survey data from Pew.
dat <- read_rds("ATP W64.RDS")

### look at the religion variable
levels(dat$F_RELIG)
dat %>% count(F_RELIG)

### change some of the names
dat <- dat %>% mutate(relig_short = fct_recode(F_RELIG,
                                               "Catholic" = "Roman Catholic",
                                               "Mormon" = "Mormon (Church of Jesus Christ of Latter-day Saints or LDS)",
                                               "Orthodox" = "Orthodox (such as Greek, Russian, or some other Orthodox church)"))

dat %>% count(relig_short)


### lump together some of the levels
dat <- dat %>% mutate(relig_abe = fct_recode(relig_short,
                                               "Christian"="Protestant",
                                               "Christian"="Catholic",
                                               "Christian"="Mormon",
                                               "Christian"="Orthodox",
                                               "Other"="Buddhist",
                                               "Other"="Agnostic",
                                               "Other"="Atheist",
                                               "Other"="Nothing in particular",
                                               "Other"="Hindu"))

dat %>% count(relig_abe)


### another way to do it:
dat <- dat %>% mutate(relig_big4 = fct_collapse(relig_short,
                                                "Christian" = c("Protestant", "Catholic", "Mormon", "Orthodox"),
                                                "Other"=c("Jewish", "Buddhist"),
                                                "Non-religious"=c("Atheist", "Agnostic", "Nothing in particular")))

dat %>% count(relig_big4)
table(dat$relig_short, dat$relig_big4) ### check your work

### lump by size
dat <- dat %>% mutate(relig_lump = fct_lump(relig_short))

dat %>% count(relig_lump)

### compare:
dat %>% count(relig_short)


### indicate the number of categories you want
dat <- dat %>% mutate(relig_lump_3 = fct_lump_n(relig_short, 3))

dat %>% count(relig_lump_3)


#### ggplot tips
library(extrafont)
loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))

tab <- dat %>% group_by(relig_big4, F_PARTYSUM_FINAL) %>%
  summarize(count=n())

tab$relig_big4 <- factor(tab$relig_big4, levels=levels(fct_infreq(dat$relig_big4)))

ggplot(data=tab, aes(x=relig_big4, y=count, fill=F_PARTYSUM_FINAL)) +
  geom_bar(stat="identity", position="dodge") +
  labs(x="",
       y="Count",
       title="Sample size of religious groups by Party ID",
       subtitle="(Unweighted)",
       caption="Source: Pew Research") +
  scale_fill_manual(values=c("darkorange",
                             "darkseagreen",
                             "cornflowerblue"),
                    labels=c("Republican",
                             "Democrat",
                             "Refused")) +
  theme(legend.title = element_blank(),
        legend.position = "top",
        legend.text = element_text(family='Times'),
        text=element_text(family='Times'),
        panel.grid.major.x = element_blank())

ggsave("relig4 and party id.wmf", height=4, width=5)


### the end.



