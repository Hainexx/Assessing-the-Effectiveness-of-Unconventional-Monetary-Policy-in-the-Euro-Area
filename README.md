# Unconventional Monetary Policy Effectivness in the Euro Area
This paper assesses the macroeconomic effects of Unconventional Monetary Policy by estimating a
Structural Vector AutoRegression model with monthly data from the Euro-Area. The analysis is carried
out over a sample spanning the period since the onset of Quantitative Easing until the beginning of the
COVID crisis (2014 - 2019). Our work aims to contribute to the growing literature on this topic, extending
the work of other authors by applying their model to contemporary data and checking that the results they
found in the past are still valid in our context. We find that an exogenous increase in the Central Bank
balance sheet leads to macroeconomics effects which are consistent with the ones assessed by Gambacorta
et al.[1] in their analysis: a temporary spike in economic activity and a slightly more persistent rise in
price level. We finally check the robustness of our findings by evaluating the same model with different
instrumental variables to proxy the output, i.e. Retail Sales and Industrial Production.

## Data: 
- Log monthly CPI (Harmonized Indices of Consumer Prices 2015 = 100, ICP.M.U2.Y.000000.3.INX)
- Log monthly ECB Balance Sheet (ECB)
- Log monthly VIX (to be aggregated, eventually) or sovCISS (already monthly)
- Monthly interpolated log GDP:         

        Quarterly Real GDP was interpolated through Chow-Lin interpolation procedure using industrial production and retail sales as reference series.
