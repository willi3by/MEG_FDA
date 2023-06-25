setwd() #Enter path to analysis folder.

perc_file_path <- #Enter path to subfolder in analysis folder with perc point by density mat files.
percpoint_files <- grep("REDO", list.files(perc_file_path),value=T)


for(p in percpoint_files){
  analysis_title <- 
    if (grepl("stories", p) && grepl("between", p)) "Stories Network Betweenness Centrality-Based Attacks" else
      if (grepl("stories", p) && grepl("eigen", p)) "Stories Network Eigenvector Centrality-Based Attacks" else
        if (grepl("stories", p) && grepl("rand", p))  "Stories Network Random Attacks" else
          if (grepl("whole", p) && grepl("between", p)) "Whole-Brain Betweenness Centrality-Based Attacks" else
            if (grepl("whole", p) && grepl("eigen", p)) "Whole-Brain Eigenvector Centrality-Based Attacks" else
              if (grepl("whole", p) && grepl("rand", p))  "Whole-Brain Random Attacks" else
                "Error"
  perc_file <- paste0(perc_file_path,p)
  save_file <- gsub(".mat", "_plots.html", p)
  rmarkdown::render("Updated_FDA_Analysis.Rmd", output_file = save_file, 
                    params = list(input_file = perc_file, analysis_title=analysis_title))
}


              
              
