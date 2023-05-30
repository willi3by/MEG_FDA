# MEG_FDA
Code used for FDA of MEG attack data across development. 


## FDA Analysis
### In the FDA_Results_clean.Rmd file, you will find the full code to recreate the analysis performed for FDA analysis of in-silico MEG attack analysis data. The system requirements are:
- R 4.1.0
- R packages: fda (5.1.9), fds (1.8), ggplot2 (3.3.5), reshape2 (1.4.4), pracma (2.3.3), R.matlab (3.6.2), refund (0.1-30), stringi (1.7.3), FoSIntro (1.0.3)
- Analyses were performed on an M1 Macbook Air running MacOS 11.6.8. Analyses should still run on Intel-based systems. 

## Since all analyses were performed with open-source packages, installation for recreating these steps should only require installation of R and the above packages. Please see the R documentation here https://www.r-project.org/ for more information. Installation time, depending on your computer and current set up, should take around 10-20 minutes. Note: FoSIntro can only be installed via the developer tools as it is not on CRAN. For this installation, devtools (2.4.2) was used using the following command: devtools::install_github("bauer-alex/FoSIntro").


## To run the code:
1. The code is run through the run_rmd_files.R script. First, open this script in a code editor.
2. Change the path (setwd command) to the folder with the study data on your computer. To use the script out of the box, there should be one overall folder that contains the percolation point data (stories_FDA_attack folder), the demos.R file, the run_rmd_files.R script, and the Updated_FDA_Analysis.Rmd file.
3. After the paths are correct, you can either run the code from the IDE (e.g., Rstudio) or from the command line using the Rscript command. Everything should run and an html output will be generated with the results for each attack strategy. This file should contain multiple data plots and parameters from the analysis, along with the final statstical plots and tables.

## Overall, the analysis will take around 10 minutes to run on a typical computer, assuming there are around 80 datasets.





