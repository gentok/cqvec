################################################################################# 
## File Name: CQ_VEC_combine_president_county_wAlaska.R                        ##
## Date: 10 Apr 2019                                                           ##
## Author: Gento Kato                                                          ##
## Purpose: Add Alaska to County Level Data                                    ##
################################################################################# 

#################
## Preparation ##
#################

## Clear Workspace
rm(list=ls())

## Library Required Packages
library(rprojroot); library(readstata13); library(foreign)
library(questionr); library(psych); library(haven)
library(openxlsx)

## Set Working Directory (Automatically) ##
if (rstudioapi::isAvailable()==TRUE) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path)); 
} 
projdir <- find_root(has_file("thisishome.txt"))
cat(paste("Working Directory Set to:\n",projdir))
setwd(projdir)

###############
## Load Data ##
###############

## President Data ##
pdc <- readRDS("cqvec_president_county.rds")

## Alaska Data Creation ##
newAKdt <- function(year, nrows=29) {
  d <- pdc[pdc$year==year,][1:nrows,]
  d$State <- "Alaska"
  d$CensusPop <- d$Area <- d$TotalVotes <- 
    d$RepVotes <- d$DemVotes <- d$ThirdVotes <- 
    d$OtherVotes <- d$PluralityVotes <- d$PluralityParty <- 
    d$RepVotesTotalPercent <- d$DemVotesTotalPercent <- 
    d$ThirdVotesTotalPercent <- d$OtherVotesTotalPercent <- 
    d$RepVotesMajorPercent <- d$DemVotesMajorPercent <- 
    d$RaceNotes <- d$TitleNotes <- d$OtherNotes <- NA
  return(d)
}
## Data File Names Function ##
pnames <- function(y) paste("president_Alaska/AK ",y,".xlsx",sep="")

##############
## Add Data ##
##############

# For 2000
dAK2000 <- read.xlsx(pnames(2000),
                     sheet = "By Borough",
                     rows = seq(1,30,1),
                     cols = seq(1,20,1))
dtemp <- newAKdt(2000)
dtemp$Area <- dAK2000$NAME
dtemp$TotalVotes <- dAK2000$ED.Total.Votes
dtemp$RepVotes <- dAK2000$`Bush/Cheney.R`
dtemp$DemVotes <- dAK2000$`Gore/Lieberman.(D)`
dtemp$RepVotesMajorPercent <- (dtemp$RepVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
dtemp$DemVotesMajorPercent <- (dtemp$DemVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
pdc <- rbind(pdc,dtemp)

# For 2004
dAK2004 <- read.xlsx(pnames(2004),
                     sheet = "By CE",
                     rows = seq(1,30,1),
                     cols = seq(1,19,1))
dtemp <- newAKdt(2004)
dtemp$Area <- dAK2004$`ED/Muni`
dtemp$TotalVotes <- dAK2004$Total.Votes
dtemp$RepVotes <- dAK2004$Bush
dtemp$DemVotes <- dAK2004$Kerry
dtemp$RepVotesMajorPercent <- (dtemp$RepVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
dtemp$DemVotesMajorPercent <- (dtemp$DemVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
pdc <- rbind(pdc,dtemp)

# For 2008
dAK2008 <- read.xlsx(pnames(2008),
                     sheet = "08 Pres Raw",
                     rows = seq(1,30,1),
                     cols = seq(47,62,1))
dtemp <- newAKdt(2008)
dtemp$Area <- dAK2008$Municipality
dtemp$TotalVotes <- dAK2008$Total.Voters
dtemp$RepVotes <- dAK2008$McCain
dtemp$DemVotes <- dAK2008$Obama
dtemp$RepVotesMajorPercent <- (dtemp$RepVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
dtemp$DemVotesMajorPercent <- (dtemp$DemVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
pdc <- rbind(pdc,dtemp)

# For 2012
dAK2012 <- read.xlsx(pnames(2012),
                     sheet = "By CE",
                     rows = seq(1,30,1),
                     cols = seq(1,8,1))
dtemp <- newAKdt(2012)
dtemp$Area <- dAK2012$`ED/Muni`
dtemp$TotalVotes <- dAK2012$Total.Votes
dtemp$RepVotes <- dAK2012$`Romney/Ryan.(REP)`
dtemp$DemVotes <- dAK2012$`Obama/Biden.(DEM)`
dtemp$RepVotesMajorPercent <- (dtemp$RepVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
dtemp$DemVotesMajorPercent <- (dtemp$DemVotes / (dtemp$RepVotes+dtemp$DemVotes))*100
pdc <- rbind(pdc,dtemp)

###############
## Save Data ##
###############

saveRDS(pdc,file="cqvec_president_county_wAlaska.rds")