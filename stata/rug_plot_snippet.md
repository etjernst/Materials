# Rug plot code snippet

```stata
* Short Stata code snippet to generate "rug plots," i.e. 
* a data plot for a single quantitative variable
* displayed as marks along the x-axis.
* I think it's a nice way to visualize the distribution of the data.

gen where = 0 
gen pipe = "|" if !mi([var])
egen tag_variable_you_want_distribution_of = tag([variable_you_want_distribution_of])
```

* Then to your twoway graphing command, add the rug plot using:

```stata
* where [var] is the variable for which you want to show distribution
addplot(scatter where [var] if tag_variable_you_want_distribution_of,   /// 
msymbol(none) mlabel(pipe) mlabpos(0) legend(off))
```

And it should look something like this ([image source](https://chemicalstatistician.wordpress.com/2013/06/30/exploratory-data-analysis-kernel-density-estimation-and-rug-plots-on-ozone-data-in-new-york-and-ozonopolis/)):<br> 
![this](https://chemicalstatistician.files.wordpress.com/2013/06/kernel-density-plot-with-rug-plot-ozone-new-york2.png)
