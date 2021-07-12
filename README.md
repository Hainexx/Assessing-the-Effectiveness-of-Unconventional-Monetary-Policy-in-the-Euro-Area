# Unconventional Monetary Policy Effectivness in the Euro Area
## Data: 
- Log monthly CPI (Harmonized Indices of Consumer Prices 2015 = 100, ICP.M.U2.Y.000000.3.INX)

- Log monthly ECB Balance Sheet (ECB)
- Log monthly VIX (to be aggregated, eventually) or sovCISS (already monthly)
- Monthly interpolated log GDP:         

        Quarterly Real GDP was interpolated through Chow-Lin interpolation procedure using industrial production and retail sales as reference series.

Answering these questions is crucial to perform our further VAR analysis. The methodology and the role of the VAR will be discussed in a further section. However, this introduction will help us to choose correctly the relevant variables in order to:

- properly identify “QE” and more generally unconventional shocks in the data from other sources of shocks (mainly conventional ones);

- select the relevant period for this analysis when it comes to “target” QE;

QE is often assimilated and confused with the “Outright Monetary Transaction Program” (OMT) implemented in 2012. These programs are genuinely similar as they both consist in purchasing series of public bonds. Nevertheless, the OMT was designed to face the eurozone sovereign debt crisis (Botta, 2019).
The main reason why QE has been implemented in Europe on the 22nd January 2015 was to avoid any eventual risk of deflation or a too low HICP level for a long period (Gambetti and Musso, 2017).
I recorded the HICP for all items in the euro area, total industry euro area production index (a proxy for GDP) excluding construction, 90 days interbank rates (a short-term measure of euro area interest rates) and 10-year euro area Government bond yields (a long-term measure of interest rates). Financial market variables20 will be captured by including the Euro Stoxx 50 price index and its corresponding implied volatility index, the Vstoxx. Finally, I decided to specify all the variables in logarithms at the exception of the interest rate series.