library(ggplot2)
library(dplyr)
library(gapminder)
# the first and second arguments are the x & y coordinates, then the data frame
qplot(displ, hwy, data = mpg)
# add color aesthetic, map it to drive variable
qplot(displ, hwy, data = mpg, color = drv)
# Can add statistic, some summary of the data, e.g. a smoother (technically called loess) by adding geom argument that includes the points, so can see the data, and the smooth geom. 95th percent confidence interval is indicated by the gray zone.
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))
# For one dimensional data, only specifying a single variable plots a histogram. Instead of color argument, specify the fill argument for what type of drive it is.
qplot(hwy, data = mpg, fill = drv)
# Facets are like panels in Lattice. Instead of color-coding different groups can have separate panel plots for subsets of the data indicated by a factor variable.
# Format for facets variable is # panel columns variable on right hand side, and # rows of matrix variable on left hand side, separated by tilde. # If only one column or row, use a period.
# Three dot plots on one row
qplot(displ,  hwy,  data = mpg, facets = .~ drv)
# Three histograms in one column
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)
# To plot on a log scale:
qplot(log(eno), data = maacs, fill = mopos)
# To do a density smooth, add geom 'density':
qplot(log(eno), data  =  maacs, geom = "density")
# To split out the mouse pos./neg. peaks into colors 
qplot(log(eno), data = maacs, geom =  "density", color = mopos)
# for a simple 2D scatter plot of log(eno) vs. log(pm25)
qplot(log(pm25), log(eno), data = maacs)
# To separate out the allergic and non-allergic groups by the data point shape argument
qplot(log(pm25), log(eno), data  =  maacs, shape = mopos)
# To separate out the two groups by color:
qplot(log(pm25), log(eno), data = maacs, color = mopos)
# To smooth the linear relationship between the two groups using standard linear regression model instead of loess, use lm:
qplot(log(pm25), log(eno), data = maacs, color = mopos, geom = c("point", "smooth"), method = "lm")
# Instead of overlapping and color coding the data, can split it out into two plots using facets argument. Will get two columns by specifying the mouse pos. variable:
qplot(log(pm25), log(eno), data = maacs, color = mopos, geom = c("point", "smooth"), method = "lm", facets = .~  mopos)

############# 9/29/15
#1
gapminder %>% 
  group_by(country) %>%
 summarize(mean_gdpPercap = mean(gdpPercap))
#2 What countries have the best and worst life expectancies in each continent?
by country
get gdp
mean gdp

gapminder %>% 
  group_by(country) %>%
  mutate(gdp = pop *cgdpPercap)

#3 Create a graph of the total population of eah continent over time
total_pop_df <-
gapminder %>% 
  group_by(country, year) %>%
  summarize(total_pop = sum(pop))

ggplot(data = total_pop_df, aes(x = year, y = total_pop, colour = continent)) +
  geom_point()

by country
by year
total pop

#4. For each coninent, what country had the smallest population in 1952, 1972, and 2002? (google for help if you need to!)
#pseudo code
# by continent
# subset 1952, 1972, 2002
# minimum population

if have list of items you want to compare things against, use %in%
# year, are you 1952? year, are you 1972? year, are you 2002?
  
  gapminder <- tbl_df(gapminder)
gapminder %>%
  # gapminder %>%
  # filter(year == 2002) %>%
  # group_by(continent) %>%
  # mean(., pop)
  #
  # equivalent of
  #
  # mean(group_by((filter(gapminder, year == 2002)), continent)$pop)
  #
  filter(year %in% c(1952, 1972, 2002)) %>%
  group_by(continent, year) %>%
  # have things grouped, and for each group want min. value for each grouping. Want the whole row of data that has the min. value. Slice cuts up your data by row.
# which gets you an index, position in an object that something exists. which.min = what is the position of the minimum value? 
  slice(which.min(pop)) %>%
# This will slice whole row of data. To select column
select(country, year, pop)

# Extra questions
#1 How many countries are there on each continent?

gapminder %>%
  group_by(continent) %>%
  slice(which.min(pop)) %>%
  
#2 What countries have the best and worst life expectancies in each continent? (for each year)

# Challenge
# 3. Which country experienced the sharpest 5-year drop in life expectancy?
# hint: lead() and lag() functions

  
##########################

library(gapminder)
library(ggplot2)
library(dplyr)

# 1. Use points and colors to identify continents

ggplot(data = gapminder, aes(x = continent, fill = continent)) +
  geom_histogram()

# 2. The per capita gdp has a very large range; use a transformation to linearize the data

str(gapminder)
#lgdp <- log10(gapminder[6])
#ggplot(data = gapminder, aes(x = lgdp, y=lifeExp, colour = continent)) +
  geom_point()
# Don't know how to automatically pick scale for object of type data.frame. Defaulting to continuous
# Error: geom_point requires the following missing aesthetics: x

ggplot(data = gapminder, aes(x = log10(gdpPercap), y=lifeExp, colour = continent)) +
  geom_point()

# 3. Include a simple linear fit to the transformed data

ggplot(data = gapminder, aes(x = log10(gdpPercap), y=lifeExp, colour = continent)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE)

# 4. Plot the density functions of life expectancy for each continent

ggplot(data = gapminder, aes(x = lifeExp, fill = continent)) +
  geom_density() +
  facet_wrap( ~ year, ncol = 4)

# 5. Fix the bottom continent labels

ggplot(data = gapminder, aes(x = continent, y = lifeExp)) +
  geom_boxplot() +
  facet_wrap( ~ year, ncol = 4) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 6. 

ggplot(data = gapminder, aes(x = lifeExp, fill = continent)) +
  geom_density()

# 7. Plot the mean life expectancy on a density plot for Asia

ggplot(data = gapminder, aes(x = lifeExp, fill = (continent[3]))) +
  geom_density() +
  geom_vline(aes(xintercept = mean(lifeExp)))
             
             
# 8a. Create a data frame of the mean life expectancies for each continent

mean_df <-
gapminder %>% 
  group_by(continent) %>%
  summarize(mean_lifeExp = mean(lifeExp))
  
# 8b. Plot the density plot of life expectancies for each continent and draw a vertical line to mark the mean life expectancy for each continent.

density
facets for continent
mean life exp lines

ggplot(data = gapminder, aes(x = lifeExp, fill = continent)) + #add data layer
  geom_density(alpha = 0.5) +
  # want geom_vline to act on something other than the default data set
  geom_vline(data = mean_df, aes(xintercept = mean_lifeExp)) +
  facet_wrap( ~ continent) #facet wrap by continent (do last)


# Find the mistakes

hw_gapminder <- read.csv('./R_projects/hw_gapminder.csv')

mean_lifeExp <- mean(hw_gapminder$lifeExpe) #Typo... should be lifeExp
mean_lifeExp <- mean(hw_gapminder$lifeExp)

# need 2nd concatenate
small_set <- hw_gapminder[c(1, 2, 3, 4, 1300:1304), ('country', 'continent', 'year')]
small_set <- hw_gapminder[c(1, 2, 3, 4, 1300:1304), c('country', 'continent', 'year')]

mean_gdp <- mean(hw_gapminder$gdpPercap)
summary(hw_gapminder$gdpPercap)
# has 5 NAs that need to be removed
mean_gdp <- mean(hw_gapminder$gdpPercap, na.rm=TRUE)


# need == for equivalence
max_country <- hw_gapminder$country[which(hw_gapminder$lifeExp = max(hw_gapminder$lifeExp))]
# I get Japan, but also 142 levels
max_country <- hw_gapminder$country[which(hw_gapminder$lifeExp == max(hw_gapminder$lifeExp))]


The desired outcomes are:
  
  mean_lifeExp

## [1] 59.47444

small_set

##                    country continent year
## 1              Afghanistan      Asia 1952
## 2              Afghanistan      Asia 1957
## 3              Afghanistan      Asia 1962
## 4              Afghanistan      Asia 1967
## 1300 Sao Tome and Principe    Africa 1967
## 1301 Sao Tome and Principe    Africa 1972
## 1302 Sao Tome and Principe    Africa 1977
## 1303 Sao Tome and Principe    Africa 1982
## 1304 Sao Tome and Principe    Africa 1987

mean_gdp

## [1] 7210.019

max_country

## [1] "Japan"

q()

############
## 10/6/15
hw_gapminder <- read.csv('./R_projects/hw_gapminder.csv')
gm <- gapminder

# Select rows 10 to 20 of the country and life expectancies in gapminder

rows 10:20
cols counry, lifeExp

#gm(c('country', 'lifeExp'),[10:20,])) doesn't work
gm[10:20, c('country', 'lifeExp')]

# Select rows 1 to 10, 20, and 100
gm[c(1:10, 20, 100), ]

# What are the 3 subsetting operators?
# object[] = multiple values
# object$ = named values
# object[[]] = lists(mostly)

# PEPPER PACKETS = sbsetting nested objects

# have to build inside out

shaker
pepper packet (pp)
grains (g)

pp1 <- c('g1', 'g2', 'g3')
pp2 <- pp1
pp3 <- pp1

# put pepper packets in shaker, using a list
pp2

shaker <- list(pp1, pp2, pp3) # list shaker has 3 objects
shaker

# get vector pepper packet 1; get the 1st element in the list shaker 1
shaker[[1]]

# get the 3rd grain out of pepper packet 1
shaker[[1]][3] #vector w/in a list, so single bracket

is.list(shaker)
typeof(shaker) #type of object stored in that list, a vector

shaker[1]
shaker[[1]]
shaker[1][2] # there is no 2
shaker[3]

# [] simplifies (preserves the type of the origial object, just makes it a smaller piece of it) your object by taking it the smallest one

##############################
# 10/13/15
#
# find country and year with largest decrease in life expectancy
gapminder %>%
  group_by('country') %>%
  # can't trust that it's already arranged by year, so do yourself
  arrange(year) %>%
  # mutate will create a new column, diff
  mutate(diff = lifeExp - lead(lifeExp)) %>% # lag says look at previous row's value, lead says next ??
# Now want to know this for each continent
  # group new data by continent to look within each continent to look for outliers (smallest one)
group_by('continent') %>%
# to look at just one row, use slice to slice out select rows to find the smallest or largest decrease in life expectancy
  slice(which.min(diff))
# give slice a condition and it subsets out only those rows we want, smallest value with greatest negative
# (works like filter)

## Write out in a paragraph all the things you want to do: hey data, I want you to do this, then do this...
## Put comment in front of every sentence, and write line of code that corresponds to that sentence

########
# For Loops
#

c(7, 10, 11, 52, 55, 83, 101, 9)
# reference ith number of vector
# foo[1] is 7, foo[4] is 52


##############
# 10/15/15
#
animals <- c('cats', 'dog', 'ponies', 'koi', 'chicken', 'moose')
for (i in animals) {
  len <- nchar (i)
  print(len)
}

for (i in 1:length(animals)) {
  len <- nchar(animals[i])
  print(len)
}

square <- vector(length = 10)
series <- 1:10
for (i in series) {
 square <- i^2
 print(square)
}

series <- 1:10
add_them <- 0
for (i in series) {
  browser()
  add_them <- i + add_them
  print(add_them)
}


#######################
# Tue 10/20/2015
#
# Podcasts - 
# 'Not so standard deviations'
# 'R Talk'
#

# 1) Print each value of this matrix.

mat <- matrix(1:100, nrow = 10, ncol = 10)
for (i in 1:length (mat)) {
  print(i)
}

# 2) Multiply each value in this matrix by 7 and store it in a 10 x 10 matrix

mat <- matrix(1:100, nrow = 10, ncol = 10)
nat <- matrix(NA, nrow = 10, ncol = 10)
for (i in 1:length(mat)){
  nat[i] <- mat[i]*7
}
nat

# 3a) Print these values as part of a string that looks something like 'n = 16'.

#Try to describe in words how I creating the vector of numbers that you are going to use.

set.seed(1)
x <- round(runif(min = 10, max = 100, n = 15))
for (i in 1:length(x)){
  print(paste('n =', x[i]))
}

# 3b) Now modify this loop to store these strings in a new vector called counts.

set.seed(1)
x <- round(runif(min = 10, max = 100, n = 15))
for (i in 1:length(x)){
  counts <- (paste('n =', x[i]))
  print(counts)
}

# 4) Make a vector for which each entry is 2 raised to the power of it’s index (ex: the 3rd item in the vector is equal to 2^3).
#For example your loop should return a vector that looks something like this:
#  2, 4, 8, 16, 64, …, 1024

for (i in 1:10) {
  two_power <- 2 ^ i
  print(two_power)
}

# 5) Make a matrix where each entry, using indexes i for row and j for column, is equivalent to i*j. Your final output should look like:

m <- matrix(NA, 12, 12)
for (n in 1:length(m)) {
  i <- slice.index(m,1)
  j <- slice.index(m,2)
  m[n] <- i[n]*j[n]
}
m

# 6) Make a vector where each entry is TRUE or FALSE, based on whether it’s index is even or odd.

x <- 1:10
y <- vector()
y <- x %% 2 == 0
y

# 7) Run this code to set yourself up for question 7.

taxa <- c('Coral', 'fish', 'Fish', 'Phytoplankton', 'coral', 'phytoplankton', 
          'zooplankton', 'Zooplankton', 'Echinoderms', 'echinoderms', 
          'Cephalopods', 'cephalopods')

taxa_values <- sample(taxa, size = 100, replace=TRUE)
set.seed(1)
counts <- round(runif(min = 10, max = 500, n = 100))

taxa_counts <- data.frame(taxa = taxa_values, abundance = counts)

# Convert duplicate upper and lower case to all upper
taxa_caps <- toupper(taxa_values)
taxacap_counts <- data.frame(taxa = taxa_caps, abundance = counts)

# 7a) Using dplyr, calculate the mean abundance of each taxonomic group, what do you notice about the output? Is it what you would expect?

aggregate(taxacap_counts['abundance'], by = taxacap_counts['taxa'], mean)

# OK, figured out dplyr way
group_by(taxacap_counts, taxa) %>%
  summarize(mean = mean(abundance))

# 7b) Hopefully not. What’s going on? Can you fix it?

# I dunno, was it the upper/lower case duplicates?

###################
# Thurs 10/22/15
#

# Functions
#
# verbname <- function((inputarg))
x <- 2:200
max(x) - min(x)
max_minus_min <- function (x) {
  dif <- max(x) - min(x)
  return(dif)
}
max_minus_min(x)

max_minus_min(gapminder$lifeExp)
max_minus_min(gapminder$gdpPercap)
max_minus_min(gapminder$country)
max_minus_min(gapminder$lifeExp)
max_minus_min(gapminder[c('lifeExp', 'gdpPercap', 'pop')])

# write function that squares a value
sqnum <- function(x){
  x^2
}
sqnum(3)

# write function that raises a value to any power
powernum <- function(x, y){
 pow <- x^y
 return(pow)
}
# 2^3
powernum(2,3)
