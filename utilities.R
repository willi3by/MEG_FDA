#Function to plot GCV by lambda. 
plot_gcv_by_lambda <- function(lambda_range, evalrange, data_mat, basis_obj, derivative){
  all_gcvs <- vector(mode="numeric", length=length(lambda_range))
  for(l in 1:length(lambda_range)){
    fdPar_obj <- fdPar(basis_obj, derivative, exp(lambda_range[l]))
    all_gcvs[l] <- sum(smooth.basis(evalrange, data_mat, fdPar_obj)$gcv)
  }
  plot(lambda_range, all_gcvs, type='l')
  return(all_gcvs)
}

# Function to smooth a single subject.
plot_gcv_by_lambda_single_subject <- function(lambda_range, evalrange, data_mat, basis_obj, derivative, data_idx, plot=FALSE){
  all_gcvs <- vector(mode="numeric", length=length(lambda_range))
  for(l in 1:length(lambda_range)){
    fdPar_obj <- fdPar(basis_obj, derivative, exp(lambda_range[l]))
    all_gcvs[l] <- smooth.basis(evalrange, data_mat[,data_idx], fdPar_obj)$gcv
  }
  if(plot==TRUE){
    plot(lambda_range, all_gcvs, type='l')
  }
  return(all_gcvs)
}

#Function to smooth all individuals.
smooth_individuals <- function(lambda_range, evalrange, data_mat, basis_obj, derivative){
  nsubjs <- ncol(data_mat)
  all_fds <- vector("list", length=nsubjs)
  all_dfs <- vector("list", length=nsubjs)
  for(s in 1:nsubjs){
    all_gcvs <- plot_gcv_by_lambda_single_subject(lambda_range =  lambda_range, evalrange = evalrange, 
                                                  data_mat = data_mat, basis_obj = basis_obj, derivative = derivative, data_idx = s)
    lambda_min_gcv <- lambda_range[which.min(all_gcvs)]
    percfdPar <- fdPar(perc_basis, 2, exp(lambda_min_gcv))
    perc_smooth <- smooth.basis(evalrange, data_mat[,s], percfdPar)
    percfd <- perc_smooth$fd
    all_fds[[s]] <- percfd
    all_dfs[[s]] <- perc_smooth$df
  }
  return(list(all_fds, all_dfs))
}
#Function to "rebuild" fd for further analyses after smoothing individuals. 
build_fd <- function(all_fds){
  mat_rows <- nrow(all_fds[[1]]$coefs)
  mat_cols <- length(all_fds)
  fd_mat <- matrix(0, nrow=mat_rows, ncol=mat_cols)
  for(i in 1:length(all_fds)){
    fd_mat[,i] <- all_fds[[i]]$coefs
  }
  fd <- all_fds[[1]]
  fd$coefs <- fd_mat
  return(fd)
}

#Function to get CI list from bootstrapping.
getCIsList <- function(coefboot_bs){
  smList <- coefboot_bs$smterms
  CIs_list <- list()
  for(i in 1:length(smList)){
    listForVar <- list(x = smList[[i]][[2]], y = smList[[i]][[1]], ci_lower = smList[[i]]$`5%` , ci_upper = smList[[i]]$`95%`, ci_type = "pointwise", alpha = 0.05)
    CIs_list[[i]] <- listForVar
  }
  return(CIs_list)
}

#Function to get data for plotting CI estimates. 
getPlotObject <- function(model) {
  ff <- tempfile()
  svg(filename=ff)
  plotObject <- plot(model)
  dev.off()
  unlink(ff)
  return(plotObject)
}

#Function to plot CIs for Beta estimates. 
plotBetaCIs <- function(model, CIs_list, variable_name_list){
  plotObject = getPlotObject(model)
  for(i in 1:length(plotObject)){
    plotObject_var = plotObject[[i]]
    plot_df <- data.frame(x = plotObject_var$x, y = plotObject_var$fit, 
                          ci_lower = CIs_list[[i]]$ci_lower, ci_upper = CIs_list[[i]]$ci_upper)
    x_breaks = seq(min(plot_df$x), max(plot_df$x), by=10)
    x_labels = seq(30, 0, length.out = length(x_breaks))
    gg <- ggplot(data = plot_df, aes(x=x, y=y)) + geom_line() +
      geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), alpha = 0.2) + 
      scale_x_continuous(breaks = x_breaks, labels = x_labels) +
      geom_hline(yintercept=0, lty="dashed") +
      ylab("Beta") +
      xlab("Density (%)") +
      ggtitle(paste(variable_name_list[[i]], "Effect with 95% Confidence Intervals")) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))
    print(gg)
  }
}

#Function to obtain data needed for plotting means for First and Fourth quartiles. 
getQuartilePlottingData <- function(ages, all_fds_and_dfs, percfd){
  quartiles <- vector(length = length(ages))
  quartile_values <- quantile(ages)
  quartiles[ages <= quartile_values[[2]]] <- "First"
  quartiles[ages > quartile_values[[2]] & ages <= quartile_values[[3]]] <- "Second"
  quartiles[ages > quartile_values[[3]] & ages <= quartile_values[[4]]] <- "Third"
  quartiles[ages > quartile_values[[4]]] <- "Fourth"
  first_quartile_idxs <- which(quartiles == "First")
  fourth_quartile_idxs <- which(quartiles == "Fourth")
  all_fds_and_dfs_first <- all_fds_and_dfs
  all_fds_and_dfs_first[[1]] <- all_fds_and_dfs_first[[1]][first_quartile_idxs]
  percfd_first <- build_fd(all_fds_and_dfs_first[[1]])
  all_fds_and_dfs_fourth <- all_fds_and_dfs
  all_fds_and_dfs_fourth[[1]] <- all_fds_and_dfs_fourth[[1]][fourth_quartile_idxs]
  percfd_fourth <- build_fd(all_fds_and_dfs_fourth[[1]])
  mean_fourth <- mean.fd(percfd_fourth)
  mean_first <- mean.fd(percfd_first)
  sd_first <- sd.fd(percfd_first)
  sd_fourth <- sd.fd(percfd_fourth)
  fda_mean_df <- data.frame(mean_first$coefs, mean_fourth$coefs)
  fda_mean_df$Density <- 279:401
  fda_sd_df <- data.frame(sd_first$coefs, sd_fourth$coefs)
  colnames(fda_mean_df) <- c("First Quantile", "Fourth Quantile", "Density")
  colnames(fda_sd_df) <- c("First Quantile", "Fourth Quantile")
  means_long = pivot_longer(fda_mean_df, c("First Quantile", "Fourth Quantile"), values_to = "mean", names_to="variable")
  sd_long = pivot_longer(fda_sd_df, c("First Quantile", "Fourth Quantile"), values_to = "sd", names_to="variable")
  means_long = pivot_longer(fda_mean_df, c("First Quantile", "Fourth Quantile"), values_to = "mean", names_to="variable")
  sd_long = pivot_longer(fda_sd_df, c("First Quantile", "Fourth Quantile"), values_to = "sd", names_to="variable")
  means_long$sd <- sd_long$sd
  
  overall_mean <- mean.fd(percfd)
  overall_sd <- sd.fd(percfd)
  overall_df <- data.frame("Mean" = overall_mean$coefs, "Sd" = overall_sd$coefs, Density = 279:401)
  return(list(means_long, overall_df))
}

#Function to plot mean for first and fourth age quartiles and overall mean.
plotQuartiles <- function(ages, all_fds_and_dfs, percfd, analysis_title){
  plotting_data <- getQuartilePlottingData(ages, all_fds_and_dfs, percfd)
  means_long = plotting_data[[1]]
  overall_df = plotting_data[[2]]
  x_breaks = seq(percfd$basis$rangeval[1], percfd$basis$rangeval[2], by=10)
  x_labels = seq(30, 0, length.out = length(x_breaks))
  print(ggplot(data = means_long, aes(x=Density, group = variable)) + 
          geom_line(aes(y = mean, color = variable), size = 1) + 
          geom_ribbon(aes(y = mean, ymin = mean - sd, ymax = mean + sd, fill = variable), alpha = .2) +
          xlab("Density") +
          ylab("Percolation Point") +
          scale_x_continuous(breaks = x_breaks, labels = x_labels) +
          ggtitle(paste0("Percolation Point Difference Between First and Fourth Age Quartiles \n ", analysis_title)) +
          theme_classic() +  
          theme(legend.key = element_blank()) + 
          theme(plot.margin=unit(c(1,3,1,1),"cm"))+
          theme(legend.position = c(1.1,.6), legend.direction = "vertical") +
          theme(legend.title = element_blank()) +
          theme(plot.title = element_text(hjust = 0.5)))
  
  print(ggplot(data = overall_df, aes(x=Density)) + 
          geom_line(aes(y = mean), size = 1) + 
          geom_ribbon(aes(y = mean, ymin = mean - rep1, ymax = mean + rep1), alpha = .2) +
          xlab("Density") +
          ylab("Percolation Point") +
          scale_x_continuous(breaks = x_breaks, labels = x_labels) +
          ggtitle(paste0("Percolation Point Difference Between First and Fourth Age Quartiles \n ", analysis_title)) +
          theme_classic() +  
          theme(legend.key = element_blank()) + 
          theme(plot.margin=unit(c(1,3,1,1),"cm"))+
          theme(legend.position = c(1,.6), legend.direction = "vertical") +
          theme(legend.title = element_blank()) +
          theme(plot.title = element_text(hjust = 0.5)))
}