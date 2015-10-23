# Operators
2 == 2
exp(1/4)
install.packages('gapminder')
library(gapminder)
head(gapminder)
tail(gapminder)

str(gapminder)
life <- gapminder$lifeExp
length(life)
gapminder[100, ]
install.packages('ggplot2')
install.packages('lazyeval')
install.packages('dplyr')
install.packages('tidyr')
library(ggplot2)
library(dplyr)
library(tidyr)
ggplot(data = gapminder, aes(x=year, y=lifeExp, color = continent)) + geom_point()
# set variable for global aesthetic defaults...
p <- ggplot(data = gapminder, aes(x=year, y=lifeExp, by=country, color = continent))
# ... then add layers
p + geom_point()
# can strip color out of global aesthetics and restrict only to one line
p <- ggplot(data = gapminder, aes(x=year, y=lifeExp, by=country))
p + geom_point() + geom_line(aes(color = continent))
# to see points on top of line, put them as last layer
p + geom_line(aes(color = continent)) + geom_point()
# SCALE
p <- ggplot(data = gapminder, aes(x=year, y=lifeExp, by=country, color = log(gdpPercap)))
p + geom_point()
# dev.new opens new graphics window
dev.new()
dev.cur()
dev.list()
str(gapminder)
# type on cheat sheet... 'hight' should be 'high', and change m.p. to fit data
p + geom_point() + scale_color_gradient2(
  low = "red", high = "blue", mid = "white", midpoint = 8)
# here (10) is the number of colors
p + geom_point() + scale_color_gradientn(colours = topo.colors(10))
# Facets - allow putting multiple panels on plot
# facet all the data by continent
p + geom_point() + facet_wrap(~ continent)
# 2 tricks for visualizing data when have lots of points on top of each other
# jitter - offsets points
p + geom_jitter()
# alpha - sets transparency of points
p + geom_point(alpha = 0.3)
# Can label things, year or country
p + geom_point() + geom_text(aes(label = year))
# Include subsets directly in plot
# ggplot(data = subset(blah blah), ...)
# args() gives argument info about function
# filter replaces which
# filter by rows
filter(gapminder, country == 'Canada')
# filter by cols with select, instead of gapminder[, 'country']
select(gapminder, country)
# doesn't work bc no column w/ name Canada
select(gapminder, Canada)
select(gapminder, starts_with('C'))
#
# pipe %>%
group_by(gapminder, continent) %>%
  summarise(mean_life = mean(lifeExp))
head(mutate(gapminder, gdp = gdpPercap * pop))
head(transmutate(gapminder, gdp = gdpPercap * pop))
head(arrange(gapminder, contient) %>%
       mean(., lifeExp))
gapminder <- tbl_df(gapminder)
# 1. For each continent, what country had the smallest population in 1952, 1972, and 2002?
filter(gapminder, year == 1952 | year == 1972 | year == 2002)
# or
# don't do this, will recycle every single one:
# filter(gapminder, year == c(1952, 1972, 2002)) %>%
#    arrange(desc(year))
# this is equivalent of the first one
filter(gapminder, year %in% c(1952, 1972, 2002))
gapminder %>%
  filter(year %in% c(1952, 1972, 2002)) %>%
  group_by(continent, year) %>%
  slice(which.min(pop)
  %>% View(.))
# or
# x <- gapminder %>%
# filter(year %in% c(1952, 1972, 2002)) %>%
#   group_by(continent, year) %>%
#   summarise(index = which.min(pop))
# filter(gapminder, year %in% c(1952, 1972, 2002)) %>%
#      group_by(continent, year) %>%
#      count(continent)
# 2. create a graph of the total population of each continent over time
#
# 3. calculate the mean gdpPercap for each country
#
# 4. calculate the mean gdp for each country

## Thurs. 10/15/15

meow <- c(1,2,3,4,10,11,12)
meow[c(5, length(meow))]
# create a double vector (numeric)
dbl_vec <- c(1.2,1.3,1.4,2.5)
str(dbl_vec)
typeof(dbl_vec)
# create an integer vector (numeric, but discrete)
int_vec <- c(1,2,3,4) # this just produces a double vector
typeof(int_vec)
# Logical vector
log_vec <- c(TRUE, FALSE, TRUE)
typeof(log_vec)
log_vec
sum(log_vec)
# character vector
chr_vec <- c('a', 'b', 'c')
chr_vec
typeof(chr_vec)

# coercion - converting

z <- read.csv(text = 'value\n12\n1\n.\n9') # equivalent of 12 1.9
str(z)
typeof(z[[1]])
# can't go first as double, that will just give you label names (factors)
as.double(z[[1]]) # 3 2 1 4 are factor levels
# need t
as.character(z[[1]])
as.double(as.character(z[[1]])) # . is NA

## To avoid this, when read a file setting stringsAsFactors = FALSE means that no character columns will be put into R as factors
z <- read.csv(text = 'value\n12\n1\n.\n9',
    stringsAsFactors = FALSE)

# 2 dimensional structures

# Matrix
a <- matrix(1:6, ncol=3, nrow=2,)
a
a[,3]
length(a)
dim(a)
nrow(a)
ncol(a)
x <- (c('a', 'b', 'c', 'd', 'e', 'f'))
a <- matrix(x, ncol = 3, nrow =2)
a
x <- c(x, 1,2,3)
x

# Data frames
str(gapminder)

# Always be thinking about what object am I working with, and what object am I sending to my function

############################################

# aes in 'global' settings
ggplot(data = gapminder, aes(x = year, y = lifeExp)) +
  geom_point()

# aes specific to a geom (in this case geom_point)
ggplot(data = gapminder, aes(x = year, y = lifeExp)) +
  geom_point()

# coloring by data
# aes in 'global' settings - coloring in continent
ggplot(data = gapminder, aes(x = year, y = lifeExp, color = continent)) +
  geom_point()

# aes specific to a geom (in this case geom_point)
ggplot(data = gapminder) +
  geom_point(aes(x = year, y = lifeExp, colour = continent))