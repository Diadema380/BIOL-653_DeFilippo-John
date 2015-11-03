
# load the packages
library(ggplot2)
library(dplyr)
# clear graphics
graphics.off()

# Discrete-time logistic population growth exercise

# 1

# a) Given a starting population N1 of 2 individuals, a per capita growth rate of r=1, and carrying capacity of k=1000, how many individuals should there be in the next generation?

################################################################
#
# dgrowth()
#
################################################################
# 
# A function to calculate population size based on equation for discrete-time logistical growth, N(t) = N(t−1) + r ∗ N(t−1) ∗ (1 − N(t−1) / K)
#
# Args: ninit, r, k, ngen
#
# Values: 
#    ninit = starting populaton
#    r = per capita growth rate
#    k = carrying capacity 
#    ngen = number of generations (t, time step)
#
# Define function:
  
dgrowth <- function(ninit, r, k, ngen) {
  # create a storage vector by repeating NAs for the number of generations
  n <- rep(NA, ngen)
  # initialize the storage vector to the starting population
  n[1] <- ninit
  # iterate through a loop from N(t) to number of generations
  # because equation is (t-1), N(t) starts at 2
  for (i in 2:ngen) {
    # equation for discrete-time logistical growth
    n[i] <- n[i-1] + r*n[i-1] * (1-(n[i-1]/k))
    }
  # return the vector
  return(n)
}

# b) Now calculate the population when t = 2 (generation 2)

pop_size <- dgrowth(ninit = 2, r = 1, k = 1000, ngen = 2)
pop_size

# c) One more time! Calculate the population when t = 3.

pop_size <- dgrowth(ninit = 2, r = 1, k = 1000, ngen = 3)
pop_size

# 2. Instead, let’s write a function in R that allows you to calculate the size a population given a starting population size N1, per capita growth rate r, carrying capacity k, and number of generations that you would like, in this case ngen=100. 

# read your mind

# 3

# a) First, let’s make a data frame where we bind one column of time values with our vector/column of population size at time step t (calcuated using our handy function). This time let’s look at 100 time steps.

ngen = 100
pop_100 <- 
time_100 <- 

pop_size <- dgrowth(ninit = 1, r = 1, k = 1000, ngen = 100)
pop_df <- data.frame(cbind(N = pop_size, time = 1:ngen))
pop_df

# b) Great! Time to plot!

ggplot(data = pop_df, aes(x = 1:ngen, y = pop_size)) + 
  geom_line()

# 4 Awesome! Ok. Now let’s do some exploring. Let’s take advantage of our newly minted function and our recent knowledge of for loops! I mentioned at the beginning of this exercise that changing the value of r changes the rate of population growth

# Let’s calculate the population growth for 100 generations, starting at a population size of 1, and carrying capacity k of 1000. But, let’s play with values of r.

# a) Set your input values in preparation for an upcoming for loop! We will be calculating a set of predicted populations based on values of r from 0.7 to 3 by an increment of 0.1. (remember to look up functions you haven’t seen before!)

ninit = 1
ngen  = 100
k = 1000
r_vals = seq(from = 0.7, to = 3, by = 0.1)

# b) Before we begin, let’s take a detour to learn a new function that can be super handy. Sometimes you create one vector or dataframe and then want to add rows to it. Describe what is happening in the code below 

# assign result of dgrowth function for one value of an argument
pop1 <- dgrowth(r = 1, ninit = 1, k = 1000, ngen = 4)
# put dgrowth results and time stops for each gen into a data frame
pop_df1 <- data.frame(N = pop1, time = 1:4)

# assign result of dgrowth function for a different value of the argument
pop2 <- dgrowth(r = 2, ninit = 1, k = 1000, ngen = 4)
# ditto above to a new data frame
pop_df2 <- data.frame(N = pop2, time = 1:4)
# stick the second data frame onto the end of the first data frame
pops_df <- rbind(pop_df1, pop_df2)
pops_df

# (add comments as notes for future you!)

# Aren't you concerned with disturbing the time-space continuum?

# c) Ok, back to looping. Let’s start by just making a loop that calculates the populations for 100 generations using our different values of r. You can look at the example for loops

# repeat the from/to/by sequence just in case
r_vals = seq(from = 0.6, to = 3, by = 0.1)
# create a list to store each iteration of dgrowth for the different values of r
varr_pop <- list()
# loop dgrowth through each value of r_vals
for (j in 1:length(r_vals)){
   varr_pop[[j]] <- dgrowth(r=r_vals[j], ninit = 1, k = 1000, ngen = 100)
}
# let's see it
varr_pop

# d) Now let’s store each new set of values in a data.frame called pops.

# Create a dataframe with an initial population using r = 1. This is the 
# data.frame that we will add rows to.

pops <- data.frame(r = 0.6, t = 1:ngen, N = dgrowth(r = 1, ninit = ninit, k = k, ngen = ngen))

for(________){
  N    <- ________
  popr <- data.frame(________)
  pops <- ________
}

# create a list to store each iteration of dgrowth for the different values of r
pop_list <- list()
N_list <- list()
# loop dgrowth through each value of r_vals
for (j in 1:length(r_vals)){
  N <- dgrowth(r=r_vals[j], ninit = 1, k = 1000, ngen = 100)
  N_list[[j]] <- N
  # create a variable that represents ngen
  lgen <- length(N)
  # create the data frame and for each interation store in index of list
  pop_df <- data.frame(r =r_vals[j], gen = 1:lgen, N = N)
  pop_list[[j]] <- pop_df
}

# let's see it
pop_list

# e) Yay! Time for more plots! See if you can make this one!

# This works to plot an individual plot...
ggplot(data = pop_list[[11]], aes(x = gen, y = N)) + 
  geom_line()

#... but not in a loop
graphics.off()
for (i in 1:length(pop_list)){
  ggplot(data = pop_list[[i]], aes(x = gen, y = N)) + 
    geom_line()
}

# ggplot has complained about lists before, so even though each list index is a data frame, let's try putting each list index into a new data frame and plot that
new.df <- data.frame(r = NA, gen = NA, N = NA)
for (i in 1:length(pop_list)){
  new.df <- pop_list[[i]]
  ggplot(data = new.df, aes(x = gen, y = N)) + 
    geom_line()
}

# still bupkis

# f) One last bit of fun. Let’s use some dplyr to grab the last 10 rows for each group of r values.

# I made a list of data frames to avoid having to use rbind, but can't use dplyr on a list, sooo... rbind it is

# create a new data frame with rows for r, gen, and NA
new_popdf <- data.frame(r = NA, gen = NA, N = NA)
# create a storage data frame for each iteration of a loop
popdf.st <- data.frame()
# every index of pop_list contains a data frame for a value of r... loop through it
for (i in 1:length(pop_list)){
  # put the data frame for the value of r into the storage data frame
  popdf.st <- pop_list[[i]]
  # rbind the rows of the storage data frame into the new data frame
  new_popdf <- rbind(new_popdf, popdf.st)
}
# let's see it
new_popdf

# get the last 10 rows for each group of r, which are gen 91-100
popdf.r <- filter(new_popdf, gen > 90)
# let's see it
popdf.r

# Now let’s plot those values and see what we get!

plot.r <- ggplot(data = popdf.r, aes(x = r, y = N)) + 
  geom_point()

# let's see it
plot.r

# 'Woot!', 'Great!', 'Awesome!', 'Yay', 'fun'...? I must be using the wrong version of R :-(
