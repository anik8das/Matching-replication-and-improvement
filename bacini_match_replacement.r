# Aniket Das
# December 17, 2020
# Purpose: To match panels of autocratic countries that sign the CAT to those 
# that do not.
# Data Input: For_Matching.dta
# Data Output: Matched.dta

# Set the working directory to that used for the PTA paper.
setwd("C:/Users/anike/Downloads/R stuff/dataverse_files")

# Load the Necessary Packages
library(arm)
library(MatchIt)
library(Matching)
library(foreign)

# Read the data into R
ptas <- read.dta("baccini_survival2.dta")
attach(ptas)
ptas <- ptas[complete.cases(ptas),]

# The following will run a nearest neighbor matching algorithm on the collapsed Baccini
# data with replacement and will run matching diagnostics.
matchptas <- matchit(pta_lead_sign ~ polity2 + rgdpch + openk + grgdpch, caliper = 0.5, data=ptas, replace = FALSE, method="nearest")

summary(matchptas)

plot(matchptas, type="jitter")
plot(matchptas, type="hist")
plot(matchptas, type="QQ")

matchPTAs<-match.data(matchptas)
write.dta(matchPTAs, file="baccinimatched2.dta")
