*import delimited "/Users/hainex/projects/macro_project/data/clean_data/sample_ready_for_Stata/2014_2019_CPIgambacorta.csv", clear 
*import delimited "/Users/hainex/projects/macro_project/data/clean_data/diff_2014_2019.csv", clear 
*import delimited "/Users/hainex/projects/macro_project/data/clean_data/diff_2014_2019_with_lev_gdp.csv", clear 
import delimited "/Users/hainex/projects/macro_project/data/clean_data/2014_2019withLogDiffGdpandRetail_diffCPI.csv", clear 
gen date = monthly(month, "YM", 2020)
format date %tm
tsset date

tsline gdp, name(gdp)
tsline ump, name(ump)
tsline cpi, name(cpi)
tsline vstoxx, name(vstoxx)

graph combine gdp ump cpi vstoxx, name(combined_vars)

gen GDP_ln = log(gdp)
gen UMP_ln = log(ump)
gen CPI_ln = log(cpi)


*  DIFF OF THE LOG
gen gdp_d = d.GDP_ln
gen ump_d = d.UMP_ln
gen cpi_d = d.CPI_ln



tsline lgdp, name(lgdp)
tsline lump, name(lump)
tsline lcpi, name(lcpi)

graph combine lgdp lump lcpi vstoxx, name(combined_vars_ln)

* No Unit Root for all the variable with p-value < .1
dfuller lgdp, noconstant lags(0) 
dfuller bs_s, noconstant lags(0) 
dfuller hcip_s, noconstant lags(0)
dfuller vol_s, noconstant lags(0)

* Lag selection 2 SBIC
varsoc lump vstoxx lgdp lcpi, maxlag(12) noconstant

var lump vstoxx lgdp lcpi, noconstant lags(1/2)
varstable
vargranger

*export excel lump vstoxx lgdp lcpi using "2014_2019_loglevels", firstrow(variables)
*export excel ump vstoxx gdp cpi using "2014_2019_diff", firstrow(variables)
