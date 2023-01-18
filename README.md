# MEG_FDA
Code used for FDA of MEG attack data across development. 


## FDA Analysis
## In the FDA_Results_clean.Rmd file, you will find the full code to recreate the analysis performed for FDA analysis of in-silico MEG attack analysis data. The system requirements are:
## R 4.1.0
## R packages: fda (5.1.9). ggplot2 (3.3.5), ggrepel (0.9.1), reshape2 (1.4.4), RColorBrewer (1.2), pracma (2.3.3), plotly (4.9.4.1), R.matlab (3.6.2), gridExtra (2.3), parallel (4.1.0)
## Analyses were performed on an M1 Macbook Air running MacOS 11.6.8. Analyses should still run on Intel-based systems. 

## Since all analyses were performed with open-source packages, installation for recreating these steps should only require installation of R and the above packages. Please see the R documentation here https://www.r-project.org/ for more information. Installation time, depending on your computer and current set up, should take around 10-20 minutes. 


## To run the code:
1. Change the output name in the knit function at the top of the Rmd file to match the analysis that you are currently running. 
2. Change the path to the correct file in the readmat function to load the appropriate dataset. 
3. Change the paths to the files for ages and sex to match where the files are on your computer. 
4. Then run each cell in the Rmd file. If you use the knit command in R, everything will run and an html output will be generated with the results. This file should contain multiple data plots and parameters from the analysis, along with the final statstical plots.  

## Overall, the analysis will take around 10 minutes to run on a typical computer, assuming there are around 80 datasets.





