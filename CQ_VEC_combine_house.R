################################################################################# 
## File Name: CQ_VEC_combine_house.R                                           ##
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

## House Data ##
hyears <- seq(1992,2016,2)

## House Data (only National)
skiprows <- c(55,54,55,54,54,
              55,55,56,54,54,
              55,55,54) # starting row
hnames <- paste("house/house_",hyears,".csv",sep="")
hdnlist <- list()
for(i in 1:length(hyears)){
  d <- read.csv(hnames[i],skip=skiprows[i],stringsAsFactors=F,na.strings = c("N/A",""))
  hdnlist[[as.character(hyears)[i]]] <- d
}
hdn <- hdnlist[[1]]
hdn$year <- hyears[1]
for(i in 2:length(hyears)){
  hdnadd <- hdnlist[[i]]
  hdnadd$year <- hyears[i]
  hdn <- rbind(hdn,hdnadd)
}
numcol <- which(names(hdn) %in% c("RepWinnerAll",             
                                  "DemWinnerAll", "OtherWinnerAll", "TotalVotesAll",            
                                  "RepVotesAll", "DemVotesAll", "OtherVotesAll",            
                                  "PluralityVotesAll", "RepVotesTotalPercentAll",  
                                  "DemVotesTotalPercentAll", "OtherVotesTotalPercentAll", "RepVotesMajorPercentAll",  
                                  "DemVotesMajorPercentAll"))
for(i in numcol){
  hdn[,i] <- gsub(",", "", hdn[,i], fixed = TRUE)
}
hdn[,numcol] <- sapply(hdn[,numcol],as.numeric)
dim(hdn)

## House Data (by State) 
hnames <- paste("house/house_",hyears,".csv",sep="")
hdlist <- list()
for(i in 1:length(hyears)){
  d <- read.csv(hnames[i],skip=2,stringsAsFactors=F,na.strings = c("N/A",""))
  selectrow <- which(d[,1]=="House")
  d <- d[selectrow,]
  hdlist[[as.character(hyears)[i]]] <- d
}
hd <- hdlist[[1]]
hd$year <- hyears[1]
for(i in 2:length(hyears)){
  hdadd <- hdlist[[i]]
  hdadd$year <- hyears[i]
  hd <- rbind(hd,hdadd)
}
numcol <- which(names(hd) %in% c("RepWinner","DemWinner","OtherWinner",
                                 "RepVotes", "DemVotes","OtherVotes",
                                 "PluralityVotes","RepVotesMajorPercent",
                                 "DemVotesMajorPercent"))
for(i in numcol){
  hd[,i] <- gsub(",", "", hd[,i], fixed = TRUE)
}
hd[,numcol] <- sapply(hd[,numcol],as.numeric)
dim(hd)

## House Data (by County) ##
hyears <- rep(c("1992to2000",
                "2002to2010",
                "2012to2016"), each=5)
hstates <- rep(c("ALtoGA","HItoMD","MAtoNJ","NMtoSC","SDtoWY"),length(hyears))
hnames <- paste0("house/house_detail_",hyears,"_",hstates,".csv")
hdlist <- list()
for(i in 1:length(hyears)){
  d <- read.csv(hnames[i],skip=2,stringsAsFactors=F,na.strings = c("N/A",""))
  selectrow <- which(d[,1]=="House")
  d <- d[selectrow,]
  hdlist[[paste(hyears,hstates,sep=",")[i]]] <- d
}
hdc <- hdlist[[1]]
for(i in 2:length(hyears)){
  hdcadd <- hdlist[[i]]
  hdc <- rbind(hdc,hdcadd)
}
colnames(hdc)[colnames(hdc)=="raceYear"] <- "year"

numcol <- which(names(hdc)%in%c("year","AreaNumber","RepVotes","DemVotes",
                                "ThirdVotes","OtherVotes",
                                "PluralityVotes","ThirdVotesTotalPercent",
                                "RepVotesMajorPercent","DemVotesMajorPercent"))
hdc$RepUnopposed <- ifelse(hdc$RepVotes=="Unopposed",1,0)
hdc$DemUnopposed <- ifelse(hdc$DemVotes=="Unopposed",1,0)
hdc$ThirdUnopposed <- ifelse(hdc$ThirdVotes=="Unopposed",1,0)
hdc$OtherUnopposed <- ifelse(hdc$OtherVotes=="Unopposed",1,0)

for(i in numcol){
  hdc[,i] <- gsub(",", "", hdc[,i], fixed = TRUE)
  hdc[,i][hdc[,i]=="Unopposed"] <- NA
}
hdc[,numcol] <- sapply(hdc[,numcol],as.numeric)
summary(hdc)

###############
## Save Data ##
###############

saveRDS(hdn,file="cqvec_house_nation.rds")
saveRDS(hd,file="cqvec_house_state.rds")
saveRDS(hdc,file="cqvec_house_district.rds")
