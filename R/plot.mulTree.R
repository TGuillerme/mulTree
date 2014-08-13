##########################
#Plots the results of a mulTree analysis
##########################
#Plots a boxplots of the fixed and random terms of the summarized multi tree MCMCglmm
#v0.1
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains




#<...> any additional argument to be passed to plot() function
#<horizontal> whether to plot the boxplots horizontally or not (default=TRUE)
#<add.table> a table.mulTreea.frame with the row names corresponding to the names of the "hdr.mcmc" to add to the plot (default=NULL). If add.table is not NULL, horizontal is set to TRUE.
#<LaTeX> whether to print the latex code
##########################
#----
#guillert(at)tcd.ie - 12/08/2014
##########################
#Requirements:
#-R 3
#-R package "MCMCglmm"
#-R package "coda"
#-R package "xtable" (optional)
##########################


plot.mulTree<-function(mulTree.mcmc, horizontal=FALSE,  CI = c(95, 75, 50), xlabels = NULL, ylabels= NULL, colour = NULL, prn = FALSE, leg = FALSE, ct = "mode",ylims=NULL)
{
#HEADER
    require(MCMCglmm)
    require(coda)

#DATA
    #mulTree.mcmc
    if (class(mulTree.mcmc) != "table.mulTree") {
        table.mulTree<-table.mulTree(mulTree.mcmc)
    }

    #colout
    if (is.null(colour)) {
        colour=gray((9:1)/10)
    }

    #horizontal
    if(class(horizontal) != 'logical'){
        stop('"horizontal" must be logical.')
    }

    #add.table

#FUNCTION

    #Density Plot function (from densityplot.R by Andrew Jackson - a.jackson@tcd.ie)
    FUN.densityplot <- function (table.mulTree, CI , xlabels , ylabels, colour , prn , leg , ct ,ylims)
    {

    #x spacement
    xspc<-0.5
    n <- ncol(table.mulTree)

    if (is.null(ylabels)){ylabels="value"}
        
    # Set up the plot
    if (is.null(ylims)){ylims<-c(min(table.mulTree) - 0.1*min(table.mulTree), max(table.mulTree) + 0.1*(max(table.mulTree)))}

    plot(1,1, xlab = "Source", ylab = ylabels, main = paste("","", sep = ""),
                xlim = c(1 - xspc, n + xspc),
                ylim = ylims, type = "n",
                xaxt = "n")
            if (is.null(xlabels)) {
                axis(side = 1, at = 1:n,
                    labels = (as.character(names(table.mulTree))))
            } else {
                axis(side = 1, at = 1:n,
                    labels = (xlabels))
            }



    colours <- rep(colour, 5)
    for (j in 1:n) {
            temp <- hdr(table.mulTree[, j], CI, h = bw.nrd0(table.mulTree[,j]))
            line_widths <- seq(2, 20, by = 4)
            bwd <- c(0.1, 0.15, 0.2, 0.25, 0.3)
            if (prn == TRUE) {
                cat(paste("Probability values for Column", j, "\n"))
            }
            for (k in 1:length(CI)) {
                temp2 <- temp$hdr[k, ]
                type="boxes"
                if (type == "boxes") {
                    polygon(c(j - bwd[k], j - bwd[k], j + bwd[k], j + bwd[k]),
                      c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), 
                      max(temp2[!is.na(temp2)]), min(temp2[!is.na(temp2)])),
                      col = colours[k])
                    if (ct == "mode") {points(j,temp$mode,pch=19)}
                    if (ct == "mean") {points(j,mean(table.mulTree[,j]),pch=19)}
                    if (ct == "median") {points(j,median(table.mulTree[,j]),pch=19)}

                }
                if (prn == TRUE) {
                    cat(paste("\t", CI[k], "% lower =", format(max(min(temp2[!is.na(temp2)]),
                      0), digits = 2, scientific = FALSE), "upper =",
                      format(min(max(temp2[!is.na(temp2)]), 1), digits = 2,
                        scientific = FALSE), "\n"))
                }
            } # close the loop across CI
        } # close the loop across teh columns in table.mulTree
    }


#PLOTTING THE MCMCglmm RESULTS

    FUN.densityplot(table.mulTree, CI , xlabels , ylabels, colour , prn , leg , ct ,ylims)
#OUTPUT

#End
}