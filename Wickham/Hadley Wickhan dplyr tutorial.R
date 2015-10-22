setwd('/Users/John/R_projects/')
library(dplyr)
library(ggplot2)
flights <- tbl_df(read.csv('flights.csv', stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)
weather <- tbl_df(read.csv('weather.csv', stringsAsFactors = FALSE))
weather$date <- as.Date(weather$date)
planes <- tbl_df(read.csv('planes.csv', stringsAsFactors = FALSE))
airports <- tbl_df(read.csv('airports.csv', stringsAsFactors = FALSE))

# filter df for all the rows with color == blue
df <- data.frame(
  color = c('blue', 'black', 'blue', 'blue', 'black'),
  value = 1:5)
filter(df, color == 'blue')
filter(df, value %in% c(1,4))

# Find all flights:

str(flights)

# To SFO or OAK

filter(flights, dest %in% c('SFO', 'OAK'))

# or

filter(flights, dest == 'SFO' | dest == 'OAK')

# NOT THIS!
filter(flights, dest == 'SFO' | 'OAK')

# In January

filter(flights, date < '2011-02-01')

# Delayed by more than an hour

filter(flights, dep_delay > 60)

# That departed between midnight and five AM

filter(flights, dep >= 0000 & dep <= 0500)
#or
filter(flights, hour >= 0 & hour <= 5)
#or with filter can supply multiple arguments to it, and those arguements are all anded together
filter(flights, hour >= 0, hour <= 5)

# Where the arrival delay was more than twice the departure delay

filter(flights, arr_delay > 2 * dep_delay)

## SELECT

# three ways to select the delay variables from this dataset

#
select(flights arr_delay, dep_delay)
select(flights arr_delay:dep_delay)
select(flights ends_with('delay'))
select(flights contains('delay'))
              
## ARRANGE

# Order the flights by departure date and time
arrange(flights, date, hour, minute)

# Which flights were most delayed?
arrange(flights, desc(dep_delay))
arrange(flights, desc(arr_delay))

# Can arrange on kind of compound expressions, e.g.
# Which flights caught up the most time during the flight?
arrange(flights, desc(arr_delay - dep_delay))

## MUTATE

# Compute speed in mph from time (in minutes) and distance (in miles). Which flight flew the fastest?
flights <- mutate(flights, fl_speed = dist / (time / 60))
str(flights)
arrange(flights, desc(fl_speed))
select(fl_speed)
fl_speed

# Add a new variable that shows how much time was made up or lost in flight.
mutate(flights, delta = arr_delay - dep_delay)

## Useful trick if want to pull out certain digits from a long number ##
# How did I compute hour and minute from dep?
# In R can assign your own operators using %[characters]%
# The result of a modulo division is the remainder of an integer division of the given numbers, e.g., 27 / 16 = 1, remainder 11 => 27 mod 16 = 11
# If have a departure where first two digits are hour and second two digits are minutes, can use integer division operator %/% and modulus (remainder) operator %% to extract those pieces out.

mutate(flights,
       hour = dep %/% 100,
       minute = dep %% 100)


# (Hint: Unless you make your screen really wide you may need to use select() or View() to see your new variable)
# View shows all your variables in a nice scrollable table
View(flights)
# Or can just select the variables you want to see
select(flights, dep:fl_speed)


#######
# 27:40
# Group by and Summarize
df <- data.frame(
  color = c('blue', 'black', 'blue', 'blue', 'black'),
  value = 1:5)
# df has two columns, color and value, and five rows.
df
# summarize() will return a one row data frame
summarise(df, total = sum(value))
# What you want to do is group your data first, and then summarize will operate by group.
# Create a new data frame, which is the old data frame grouped by color
by_color <- group_by(df, color)
by_color
# Now summarize() will operate by group - for each group it will compute the total by summing up the value variable.
summarise(by_color, total = sum(value))

# Four useful ways of grouping the flights data: by date, by hour, by plane, and by destination.

by_date <- group_by(flights, date)
by_hour <- group_by(flights, date, hour)
by_plane <- group_by(flights, plane)
by_dest <- group_by(flights, dest)

## How might you summarize the distribution of arrival delays for each day?
# Median of departure delay will give a new data frame with 365 rows (# days in year) and 2 columns, day and year.
# Also can do mean, max, and 90th quantile
summarize(filter(by_date),
          med = median(dep_delay, na.rm = TRUE),
          mean = mean(dep_delay, na.rm = TRUE),
          max = max(dep_delay, na.rm = TRUE),
          q90 = quantile(dep_delay, 0.9, na.rm = TRUE))

# To avoid having to keep typing na.rm = TRUE, filter out all the flights that are not missing departures
summarize(filter(by_date, !is.na(arr_delay)),
          med = median(arr_delay),
          mean = mean(arr_delay),
          max = max(arr_delay),
          q90 = quantile(arr_delay),
# The proportion of flights that were delayed is the average of all the ones with delays greater than zero
          delayed = mean(arr_delay > 0),
# To set thresholds, e.g., those with delays greater than 15 minutes
          delay15 = mean(arr_delay > 15)
        )

# In any real data manipulation task you're probably not just going to use one verb, but are going to string multiple verbs together.
# First group it
by_date <- group_by(flights, date)
# Then filter it
no_missing <- filter(flights, !is.na(arr))
# Then summarize it
delays <- summarize(no_missing,
          med = median(arr_delay),
          mean = mean(arr_delay),
          max = max(arr_delay),
          q90 = quantile(arr_delay),
          delayed = mean(arr_delay > 0),
          delay15 = mean(arr_delay > 15)
        )

# Want some way to express the stringing together of multiple verbs more naturally or more simply, which is the idea of having a data pipeline.

# Downside of functional interface is that it's hard to read multiple operations, you have to read it in an unnatural way, inside out, plus the arguments to filter are quite far away:
# To parse this code snippet, start with the innermost piece, the flights data
hourly_delay <- filter( # Finally filter it to only look at the hours that have more than 10 flights
  # Third, summarize the data to get the average delay and number of observations in that hour
  summarize(
    # Second, group the filtered flights data by date and hour
    group_by(
      # First filter flights data to remove any missing delays
      filter(
        flights,
        !is.na(dep_delay)
        ),
      date, hour
      ),
    delay = mean(dep_delay),
    n = n()
    ),
  n > 10
)

# Data piplines: pipe operator %>% makes the code a lot easier to read.
# It takes the thing on the left hand side of the pipe and puts it as the first argument as the thing on the right hand side:
# %>% is an asymmetric operator, the data is flowing from left to right
## HINT: PRONOUNCE %>% AS "THEN": 
# Take flights, then
hourly_delay <- flights %>%
  # filter it to remove any missing values for dep_delay, then
  filter(!is.na(dep_delay)) %>%
  # group it by date and hour, then
  group_by(date, hour) %>%
  # then summarize it, computing the average delay and the number of observations in the group, then
  summarize(delay = mean(dep_delay), n = n()) %>%
  # filter it for observations that are greater than 10
  filter(n > 10)

# Pipe operators allows formation of chains of complicated data transformation operations that are made up of very simple pieces. 
# The goal is to make something complex by joining together many simple things that are easy to understand in isolation.

# Create data pipelines to answer the following questions:

# Which destinations have the highest average delays?

flights %>%
  # Remove NAs
  filter(!is.na(arr_delay)) %>%
  # Group_by is a kind of fundamentally like statistical operator, 
    # are saying, what is the unit of interest in this analaysis?
    # In this case it's the destination of a flight
  group_by(dest) %>%
    # Then for each destination are going to summarize it using the mean delay:
  # Whenever do a group-wise summary should always record the number of observations in each group
    summarize(mean(arr_delay), n = n()) %>% 
     # because when you start looking at these averages a destination that has the highest average delay but only one flight flew there is probably not as interesting. 
  # So maybe filter out the flights with < 10 observations
      filter( n > 10)%>%
  # And if want to focus on the most delayed flights, arrange it in descending mean
  arrange(desc(mean)) %>%
  # Another useful thing instead of printing it is to pipe it into View if you wanted to see more of the data.
     View()
  
# Another useful thing is to pipe it into str() to see what variables you've created and if they're the right type and so on.
arrange(desc(mean)) %>%
      str()
# Constructed the above pipeline just by typing every step, but
# generally when creating pipelines want to do it a step at a time.
# That's one reason why the default printing is really important,
# because you can print out the result at every stage and see if it looks right or not.


# Which flights (i.e., carrier + flight) flew every day of the year?

# First group_by carrier and flight #.
flights %>%
  group_by(carrier, flight) %>%
  # To find all flights that flew every day of the year, could do summarize by counts
  summarize(n = n()) %>%
  arrange(desc(n)) %>%
  # Filter by 365
  filter(n == 365)

# Or save some typing by using tally instead of summarize
flights %>%
  group_by(carrier, flight) %>%
  tally(sort = TRUE) %>%
  filter(n == 365)

# or summarize by distinct dates (in case some flights flew twice in one day and not on another day), are 365 distinct dates
flights %>%
  group_by(carrier, flight) %>%
  # dplyr's n_distinct() function
  summarize(n = n_distinct(date)) %>%
  filter(n == 365)
  
# What destinations do they fly to? Just add dest to group_by

flights %>%
  group_by(carrier, flight, dest) %>% 
  summarize(n = n_distinct(date)) %>%
  filter(n == 365)

# On average, how do delays (of non-cancelled flights) vary over the course of a day? 
# (Hint: hour + minute /60)

flights %>%
  # First filter out the not cancelled. 
  filter(cancelled == 0) %>%
  # Normally after filtering out  clearly wrong things, the first step is going to be grouping it.
  group_by(hour, minute) %>%
  # Then summarize by counting the # of observations in each group so can disregard the delayed flights, and then do the mean departure delay
  summarize(n = n(), mean = mean(dep_delay))
   
# Alternate way to do this:
per_hour <- flights %>%
  filter(cancelled == 0) %>%
  # Create a new variable called time, which is just hour + minute divided by 60, gives like a floating point number that smoothly varies over the course of the day
  mutate(time = hour + minute / 60) %>%
  group_by(time) %>%
  summarize(arr_delay = mean(dep_delay, na.rm = TRUE),  n = n())
  
# Plot
qplot(time, arr_delay, data = filter(per_hour, n > 30), size = n) + scale_size_area()

# plot with white line every hour
ggplot(filter(per_hour, n > 30), aes(time, arr_delay)) +
  geom_vline(xintercept = 5:24, colour = 'white', size = 2), +
  geom_point()


                        