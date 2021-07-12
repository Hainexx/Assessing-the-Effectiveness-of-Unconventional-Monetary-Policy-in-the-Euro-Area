library(readr)
library(tsbox)
library(dplyr)
library(imputeTS)
library(tempdisagg)
library(readr)
library(timetk)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# GDP <- read_csv("./data/interpolated_monthly_log_gdp.csv")
# TAL <- read_csv("./data/log_balance_sheet.csv")
# CPI <- read_csv("./data/log_CPI.csv")
# VIX <- read_csv("./data/vix_monthly_csv")
# CISS <- read_csv("./data/sovCISS.csv")
# VSTOXX <- read_csv("./VSTOXX.csv")
# TAL <- TAL[37:78,4]
# VIX <- VIX[49:90,1:2]
# CPI <- CPI[37:78,1:2]
# CISS <- CISS[37:78,2]
# GDP <- GDP[37:78,2]
# VSTOXX <- VSTOXX[,2]
# VSTOXX[18,] <- 3.1234
# wf <- cbind(TAL,GDP,CPI,VIX,CISS,VSTOXX)
# col <- c("CBBS","GDP","time","CPI","VIX","CISS","VSTOXX")
# colnames(wf) <- col
# wf
# wf_s <- ts(wf,frequency = 12, start = c(2011,12))
# d_wf <- diff(wf) #start 2012,01, end 2019,10
# autoplot(wf_s, facet = TRUE) + theme_bw()

#write_csv(as.data.frame(d_wf),"matl.csv")

#GDP <- read_csv("./data/clean_data/GDP_seas_adj.csv")
GDP <- read_csv("./data/clean_data/GDP_resmind_log.csv")
UMP <- read_csv("./data/clean_data/BS_remaind.csv")
CPI <- read_csv("./data/clean_data/original_series/CPI_diff.csv")
CPI <- read_csv("./data/clean_data/CPI_Gambacorta.csv")
#CPI <- read_csv("./data/clean_data/log_BS_seas_adj.csv")
VSTOXX <- read_csv("./data/clean_data/original_series/VSTOXX_nonlog.csv")
Retail <-  read_csv("./data/clean_data/original_series/retail_log_reminder.csv")

GDP <- GDP[109:180,2] #Jan 2014 - Dec 2019
UMP <- UMP[,2]
CPI <- CPI[109:180,2]
#CPI <- CPI[,2]
VSTOXX <- VSTOXX[,2]
Retail <- Retail[109:180,2]

wf <- cbind(UMP,VSTOXX,GDP,CPI,Retail)
col <- c("UMP","VSTOXX","GDP","CPI","Month","Retail")
colnames(wf) <- col


wf_s <- ts(wf,frequency = 12, start = c(2014,1))

#d_wf <- diff(wf) #start 2012,01, end 2019,10


autoplot(wf_s, facet = TRUE) + theme_bw()

write_csv(wf, "data/clean_data/sample_ready_for_Stata/2014_2019_Ultimate_withBSremainders.csv")


