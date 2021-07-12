library(tsbox)
library(dplyr)
library(imputeTS)
library(tempdisagg)
library(readr)
library(timetk)
library(forecast)
library(tsibble)
library(imputeTS)
library(fpp3)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

gdp <- read_tsv("./data/gdp/real_gdp.tsv", 
                  trim_ws = TRUE)
industrial_prod <- read_csv("./data/gdp/industrial_prod.csv")
industrial_prod <- industrial_prod[nrow(industrial_prod):1,]
industrial_prod <- industrial_prod[1:194,2]
#prod <- industrial_prod[109:180,]

#write_csv(prod, file = "./data/industrialprod_2014_2019.csv")

Retail_Sales <- read_delim("./data/gdp/Retail_Sales .csv", ";", escape_double = FALSE, trim_ws = TRUE)

prod <- ts(industrial_prod,frequency = 12, start = c(2005,1))

retail <- ts(Retail_Sales[2], frequency = 12, start = c(2005,1))

gdp <- ts(gdp[2],frequency = 4, start = c(2005,1))


plot(prod)
plot(retail)
plot(gdp)


xd <- td(gdp~prod+retail, 
    conversion = "mean",
    to = "monthly",
    method = "dynamic-maxlog"
)

summary(xd)
plot(xd)
plot(predict(xd))

plot(log(predict(xd)))
DT <- (predict(xd))
plot(ts(DT[1:180]))

x <- timetk::tk_tbl(DT,rename_index = "Date")

#write_csv(x, file = "./data/clean_data/gdp_nonlog.csv")


cpi <- read_delim("data/CPI/cpi_seasonally_adj.csv", ";", escape_double = FALSE, trim_ws = TRUE)
cpi_2  <- read_delim("data/CPI/CPI_altro.csv", ";", escape_double = FALSE, col_types = cols(DATE = col_date(format = "%Y-%m-%d")), trim_ws = TRUE)

cpi <- cpi[nrow(cpi):1,]
cpi$log_cpi <- log(cpi$HICP)

plot(ts(cpi$HICP))
plot(ts(cpi_2$CPHPTT01EZM659N))

cpi <- ts(cpi[2], frequency = 12, start = c(2005,1))
write_csv(as.data.frame(cpi), file = "./data/clean_data/CPI_log_season.csv")


bs <- read_tsv("./data/BS_ECB/Balance_Sheet__monthly.tsv",
                trim_ws = TRUE)

bs <- bs[nrow(bs):1,]
bse <- bs[109:180,1:4] 
plot(ts(bs$`Total_Assets/Liabilities`))
bs$`Total_Assets/Liabilities` <- log(bs$`Total_Assets/Liabilities`)

#write_csv(bse, file = "./data/balance_sheet_nonlog.csv")

plot(ts(bs$`Total_Assets/Liabilities`))

CISS <- read_tsv("data/volatility_index/sovCISS_gdp_wheighted.tsv")
CISS <- CISS[nrow(CISS):1,]
CISS$SovCISS <- log(CISS$SovCISS)
#write_csv(CISS, file = "./data/sovCISS.csv")



# Transform Daily Vix to Monthly (every Standard Deviation month should be multiplied for the sqrt(21)) ------------
vix_daily_csv <- read_csv("data/volatility_index/vix-daily_csv.csv",
                          col_types = cols(Date = col_date(format = "%Y-%m-%d"), 
                                           `VIX Open` = col_skip(), `VIX High` = col_skip(), 
                                           `VIX Low` = col_skip()))

vix_monthly = vix_daily_csv %>%
                    mutate(date = format(vix_daily_csv$Date, '%Y-%m'), vix = `VIX Close`) %>%
                    select(date, vix) %>%
                    group_by(date) %>%
                    summarise(vix_21 = sd(vix)*sqrt(21), vix_dynamic = sd(vix)*sqrt(n()), n = n())

vix_monthly$vix_21 <- log(vix_monthly$vix_21)
#write_csv(vix_monthly, file = "./data/vix_monthly_csv")


VSTOXX <- read_delim("data/volatility_index/VSTOXX_daily_csv.csv", ";", escape_double = FALSE, trim_ws = TRUE,col_types = cols(Date = col_date(format = "%d.%m.%Y"), 
                                                                                                                                     Symbol = col_skip()))

plot(ts(VSTOXX$Indexvalue))
plot(ts(vstoxx_monthly$index_21))
vstoxx_monthly = VSTOXX %>%
            mutate(date = format(VSTOXX$Date, '%Y-%m'), index = Indexvalue) %>%
            select(date, index) %>%
            group_by(date) %>%
            summarise(index_21 = sd(index)*sqrt(21), index_dynamic = sd(index)*sqrt(n()), n = n())

dat <- vstoxx_monthly[73:250,1:2]

dat$index_21 <- log(dat$index_21)
vstoxx_nonlog<- vstoxx_monthly[,1:2]
#write_csv(vstoxx_nonlog, "./data/clean_data/VSTOXX_nonlog.csv")


bse$Date <- as.Date(paste0(bse$Date, '01'), format='%Y%b%d')

bse$Date <- format(bse$Date, "%Y-%m")


bse <- as_tibble(bse, index = 'Date')
format(bse$Date, format = "%y%b")
yearmonth("2014Jan", format = "%y%b")


bse$`Total_Assets/Liabilities` <- log(bse$`Total_Assets/Liabilities`)

bsed <- bse %>%
            mutate(Month = yearmonth(bse$Date, format = "%y%b")) %>%
            as_tsibble(index = Month)

dcmp <- bsed %>%
            select(Month,`Total_Assets/Liabilities`) %>%
            model(stl = STL(`Total_Assets/Liabilities`))


components(dcmp) %>% autoplot()

BalanceSheet <- components(dcmp) %>% 
            select(Month,remainder)

plot(ts(BalanceSheet$remainder))
write_csv(BalanceSheet, file = "./data/clean_data/BS_remaind.csv")
prod$Industrial_prod <- log(prod$Industrial_prod)
prod <- prod %>%
            mutate(Date = yearmonth(prod$Date, format = "%y%b")) %>%
            as_tsibble(index = Month)

prod_comp <- prod %>%
            model(stl = STL(Industrial_prod))

components(prod_comp) %>% autoplot()

prods_log_remaind <- components(prod_comp) %>% 
            select(remainder)

#write_csv(as.data.frame(prods_log_remaind$remainder), "prod_lg_rem.csv")


df <- x[-c(1)]
df$Date <- bs$Date[1:194]
df <- df[1:180,]
df$log_val <- log(df$value)

gdp_comp <- df %>%
            mutate(Month = yearmonth(df$Date, format = "%y%b"), .keep = "unused") %>%
            as_tsibble(index = Month)

gdp_comp <- gdp_comp %>%
            model(stl = STL(value 
                            #~ trend(window = 19) 
                            #+ season(window = 'periodic')
                            ))

components(gdp_comp) %>% autoplot()

GDP <- components(gdp_comp) %>% 
            select(Month,season_adjust)

GDP_detrend_log <- components(gdp_comp) %>% 
            select(Month,remainder)

plot(ts(GDP_detrend_log$remainder[109:178]))
plot(ts(GDP$season_adjust))
GDP$season_adjust <- log(GDP$season_adjust)
write_csv(GDP_detrend_log, file = "./data/clean_data/GDP_resmind_log.csv")

######### RETAIL SALES ###########



df <- Retail_Sales[1:180,]
df$`Sales Retail` <- log(df$`Sales Retail`)

gdp_comp <- df %>%
            mutate(Month = yearmonth(df$DATE, format = "%y-%m-%d")) %>%
            as_tsibble(index = Month)

Retail_comp <- gdp_comp %>%
            model(stl = STL(`Sales Retail`, robust = TRUE))

components(Retail_comp) %>% autoplot()

Retail <- components(Retail_comp) %>% 
            select(Month,remainder)

plot(ts(Retail$remainder))

write_csv(Retail, file = "./data/clean_data/retail_log_reminder.csv")


gdp_MA <- x %>%
            mutate(`12-MA` = slider::slide_dbl(value, mean,
                                               .before = 5, .after = 6, .complete = TRUE),
                   `2x12-MA` = slider::slide_dbl(`12-MA`, mean,
                                                 .before = 1, .after = 0, .complete = TRUE)
                   )

plot(ts(x$value))
plot(ts(gdp_MA$`2x12-MA`))



cpi_comp <- cpi %>%
            mutate(Month = yearmonth(cpi$Date, format = "%y%b"), .keep = "unused") %>%
            as_tsibble(index = Month)

cpi_comp <- cpi_comp %>%
            model(stl = STL(log_cpi 
                            #~ trend(window = 19) 
                            #+ season(window = 'periodic')
                            #, robust = TRUE
            ))

components(cpi_comp) %>% autoplot()

CPI <- components(cpi_comp) %>% 
            select(Month,remainder)

plot(ts(CPI$remainder))

write_csv(CPI, file = "./data/clean_data/CPI_Gambacorta.csv")


