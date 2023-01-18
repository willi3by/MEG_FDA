##Plot redults of hypothesis testing.

tFstat <- Fstat.fd(coefsfd, fRegredsList$yhatfdobj)
argvals <- tFstat$argvals
argvals <- 100-(argvals*.25)
ylims = c(min(c(F.red.sex$Fvals, F.red.sex$qval, F.red.sex$qvals.pts)), max(c(F.red.sex$Fobs, 
                                                F.red.sex$qval)))
plot(argvals, F.red.sex$Fvals, type='l', col=2, lwd=2, xlim=rev(range(argvals)), xlab="Density (%)", ylim=c(0,0.35),
     ylab = "F-statistic", main = "Effect of Sex on Percolation Point By Density Controlling for Age")
abline(h = F.red.sex$qval, lty = 2, col = 4, lwd = 2)
lines(argvals, F.red.sex$qvals.pts, lty = 3, col = 4, lwd = 2, xlim=rev(range(argvals)))
q <- 0.95
legendstr = c("Observed Statistic", paste("pointwise", 
                                          1 - q, "critical value"), paste("maximum", 1 - 
                                                                            q, "critical value"))
legend(argvals[1], ylims[2], legend = legendstr, 
       col = c(2, 4, 4), lty = c(1, 3, 2), lwd = c(2, 2, 2), bty="n",
       xjust = -1.7)

##Plot beta estimate.
rangeval <- betaestlist[[1]]$fd$basis$rangeval
argvals = seq(rangeval[1], rangeval[2], len = 51)
n = length(argvals)
p = length(betaestlist)
betavec = eval.fd(argvals, betaestlist[[2]]$fd)
betastderr = eval.fd(argvals, betastderrlist[[2]])
betavecp = betavec + 2 * betastderr
betavecm = betavec - 2 * betastderr
zeroval = c(0, 0)
argvals <- argvals <- 100-(argvals*.25)
plot(argvals, betavec, type = "l",  ylab = "Beta",
     ylim = c(min(betavecm), max(betavecp)), xlim=rev(range(argvals)),
     xlab="Density (%)", main="Beta Estimates for Effect of Age on Percolation Point by Density")
lines(range(argvals), zeroval, lty = 3, col = 2, lwd=3)
lines(argvals, betavecp, col = 1, lwd = 1)
lines(argvals, betavecm, col = 1, lwd = 1)


