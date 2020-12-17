# Aniket Das
# December 17, 2020
# Purpose: To build a plot to compare covariate balance between non replacement 
# PSM, genetic matching, and replacement PSM

# Load the Necessary Packages
library(arm)
library(MatchIt)
library(Matching)
library(foreign)
library(rio)
library(cobalt)
library(gridExtra)

# setting the seed to results are replicable
set.seed(123)

# Read the data into R
ptas <- import("C:/Users/anike/Downloads/R stuff/dataverse_files/baccini_survival2.dta")
ptas <- ptas[complete.cases(ptas),]

# The following will run a replacement PSM
matchptas <- matchptas <- matchit(pta_lead_sign ~ polity2 + rgdpch + openk + grgdpch, caliper = 0.5,
                                  data=ptas, replace = TRUE, method="nearest")

P1 <- love.plot(bal.tab(matchptas), stat = "mean.diffs", threshold = .1, 
          var.order = "unadjusted")

# the following will run genetic matching 
matchptas2 <- matchit(pta_lead_sign ~ polity2 + rgdpch + openk + grgdpch, caliper = 0.5, data=ptas, replace = TRUE, method="genetic", pop.size = 2000, wait.generations = 50, max.generations = 1000, unif.seed = 123, int.seed = 123)


# the following will run a non-replacement PSM
P2 <- love.plot(bal.tab(matchptas2), stat = "mean.diffs", threshold = .1, 
                var.order = "unadjusted")

matchptas3 <- matchptas <- matchit(pta_lead_sign ~ polity2 + rgdpch + openk + grgdpch, caliper = 0.5,
                                  data=ptas, replace = FALSE, method="nearest")

P3 <- love.plot(bal.tab(matchptas3), stat = "mean.diffs", threshold = .1, 
                var.order = "unadjusted")

# this will plot the covariate balance across all three matching methods
grid.arrange(P1, P2, P3, nrow = 1)


bal.tab(matchptas)
bal.tab(matchptas2)
bal.tab(matchptas3)