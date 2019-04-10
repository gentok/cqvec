################################################################################# 
## File Name: CQ_VEC_combine_president.R                                       ##
## Date: 10 Apr 2019                                                           ##
## Author: Gento Kato                                                          ##
## Purpose: Import and combine US House Data                                   ##
################################################################################# 

#################
## Preparation ##
#################

## Clear Workspace
rm(list=ls())

## Library Required Packages
library(rprojroot); library(readstata13); library(foreign)
library(questionr); library(psych); library(haven)

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
pyears <- seq(2000,2016,4)

## President Data (only National)
pnames <- paste("president/president_",pyears,".csv",sep="")
pdnlist <- list()
for(i in 1:length(pyears)){
  d <- read.csv(pnames[i],skip=55,stringsAsFactors=F,na.strings = c("N/A",""))
  pdnlist[[as.character(pyears)[i]]] <- d
}
pdn <- pdnlist[[1]]
pdn$year <- pyears[1]
for(i in 2:length(pyears)){
  pdnadd <- pdnlist[[i]]
  pdnadd$year <- pyears[i]
  pdn <- rbind(pdn,pdnadd)
}
numcol <- which(names(pdn) %in% c("ElectoralRepVotes","ElectoralDemVotes",
                                 "ElectoralOtherVotes",
                                 "TotalVotes","RepVotes","DemVotes",
                                 "ThirdVotes","OtherVotes","PluralityVotes",
                                 "RepVotesTotalPercent","DemVotesTotalPercent",
                                 "ThirdVotesTotalPercent","OtherVotesTotalPercent",
                                 "RepVotesMajorPercent","DemVotesMajorPercent"))
for(i in numcol){
  pdn[,i] <- gsub(",", "", pdn[,i], fixed = TRUE)
}
pdn[,numcol] <- sapply(pdn[,numcol],as.numeric)

## President Data (by State) 
pnames <- paste("president/president_",pyears,".csv",sep="")
pdlist <- list()
for(i in 1:length(pyears)){
  d <- read.csv(pnames[i],skip=2,stringsAsFactors=F,na.strings = c("N/A",""))
  selectrow <- which(d[,1]=="President")
  d <- d[selectrow,]
  pdlist[[as.character(pyears)[i]]] <- d
}
pd <- pdlist[[1]]
pd$year <- pyears[1]
for(i in 2:length(pyears)){
  pdadd <- pdlist[[i]]
  pdadd$year <- pyears[i]
  pd <- rbind(pd,pdadd)
}
numcol <- which(names(pd) %in% c("ElectoralRepVotes","ElectoralDemVotes",
                                 "ElectoralOtherVotes",
                                 "TotalVotes","RepVotes","DemVotes",
                                  "ThirdVotes","OtherVotes","PluralityVotes",
                                  "RepVotesTotalPercent","DemVotesTotalPercent",
                                  "ThirdVotesTotalPercent","OtherVotesTotalPercent",
                                  "RepVotesMajorPercent","DemVotesMajorPercent"))
for(i in numcol){
  pd[,i] <- gsub(",", "", pd[,i], fixed = TRUE)
}
pd[,numcol] <- sapply(pd[,numcol],as.numeric)

## President Data (by County) ##
pyears <- rep(seq(2000,2012,4),each=6)
pstates <- rep(c("_ALtoGA","_HItoMD","_MAtoNJ","_NMtoSC","_SDtoWY","_DC"),4)
pnames <- paste("president/president_detail_",pyears,pstates,".csv",sep="")
pdlist <- list()
for(i in 1:length(pyears)){
  d <- read.csv(pnames[i],skip=2,stringsAsFactors=F,na.strings = c("N/A",""))
  selectrow <- which(d[,1]=="President")
  d <- d[selectrow,]
  pdlist[[paste(pyears,pstates,sep="")[i]]] <- d
}
pdc <- pdlist[[1]]
pdc$year <- pyears[1]
for(i in 2:length(pyears)){
  pdcadd <- pdlist[[i]]
  pdcadd$year <- pyears[i]
  pdc <- rbind(pdc,pdcadd)
}
summary(pdc)

numcol <- which(names(pdc) %in% c("TotalVotes","RepVotes","DemVotes",
                        "ThirdVotes","OtherVotes","PluralityVotes",
                        "RepVotesTotalPercent","DemVotesTotalPercent",
                        "ThirdVotesTotalPercent","OtherVotesTotalPercent",
                        "RepVotesMajorPercent","DemVotesMajorPercent"))
for(i in numcol){
  pdc[,i] <- gsub(",", "", pdc[,i], fixed = TRUE)
}
pdc[,numcol] <- sapply(pdc[,numcol],as.numeric)

###############
## Save Data ##
###############

saveRDS(pdn,file="cqvec_president_nation.rds")
saveRDS(pd,file="cqvec_president_state.rds")
saveRDS(pdc,file="cqvec_president_county.rds")
