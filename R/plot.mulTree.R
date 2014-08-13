##########################
#Plots the results of a mulTree analysis
##########################
#Plots a boxplots of the fixed and random terms of the summarized multi tree MCMCglmm
#v0.1
##########################
#SYNTAX :
#<mulTree.mcmc> a mcmc chain written by the mulTree function. Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains
#<CI> the credibility interval (can be more than one value)
#<average> the central tendency of the distribution to plot. Can be either 'mode', 'median' or 'mean' (default="mode")
#<horizontal> whether to plot the boxplots horizontally or not (default=TRUE)
#<terms> a list of terms, if NULL, the terms are extracted from mulTree.mcmc (default=NULL)
#<colour> any colour or list of colour for the plot, if NULL colour is set to greyscale (default=NULL)
#<coeff.lim> the estimate coefficient range, if NULL, the range is set to the extreme values of mulTree.mcmc +/- 10%


#<...> any additional argument to be passed to plot() function
#<horizontal> whether to plot the boxplots horizontally or not (default=TRUE)
#<add.table> a mulTree.mcmca.frame with the row names corresponding to the names of the "hdr.mcmc" to add to the plot (default=NULL). If add.table is not NULL, horizontal is set to TRUE.
#<LaTeX> whether to print the latex code
##########################
#----
#guillert(at)tcd.ie - 13/08/2014
##########################
#Requirements:
#-R 3
#-R package "MCMCglmm"
#-R package "coda"
#-R package "xtable" (optional)
##########################


plot.mulTree<-function(mulTree.mcmc, CI=c(95, 75, 50), average="mode", horizontal=FALSE, terms=NULL, colour=NULL, coeff.lim=NULL)
{
#HEADER
    require(MCMCglmm)
    require(coda)

#DATA
    #mulTree.mcmc
    if(class(mulTree.mcmc) != 'mulTree') {
        stop(as.character(substitute(mulTree.mcmc))," must be a 'mulTree' object.\nUse read.mulTree() function.", call.=FALSE)
    } else {
        #rebuild mulTree.mcmc as a data.frame
        class(mulTree.mcmc)<-"data.frame"
    }

    #CI
    if (class(CI) != 'numeric') {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    }
    if (any(CI < 0)) {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    } else {
        if (any(CI > 100)) {
            stop("Credibility interval must be between 0 and 100.", call.=FALSE)
        }
    }

    #average
    first.moment<-c("mode", "median", "mean")
    if (class(average) != 'character') {
        stop("\"average\" must be either \"mode\", \"median\" or \"mean\".", call.=FALSE)
    } else {
        if (any(average == first.moment)) {
            ok<-"ok"
        } else {
            stop("\"average\" must be either \"mode\", \"median\" or \"mean\".", call.=FALSE)
        }       
    }

    #horizontal
    if(class(horizontal) != 'logical'){
        stop('"horizontal" must be logical.')
    }

    #colour
    if (is.null(colour)) {
        colour=gray((9:1)/10)
    }

    #terms
    if(is.null(terms)) {
        terms=as.character(names(mulTree.mcmc))
    }

    #coeff.lim
    if (is.null(coeff.lim)) {
        coeff.lim<-c(min(mulTree.mcmc) - 0.1*min(mulTree.mcmc), max(mulTree.mcmc) + 0.1*(max(mulTree.mcmc)))
    } else {
        if(class(coeff.lim) != 'numeric') {
            stop("\"coeff.lim\" must be numeric.", call.=FALSE)
        } else {
            if(length(coeff.lim) != 2) {
                stop("\"coeff.lim\" must be a list of two elements.", call.=FALSE))
            }
        }
    }

    #add.table

#FUNCTION

    #Density Plot function (from densityplot.R by Andrew Jackson - a.jackson@tcd.ie)
    FUN.densityplot <- function (mulTree.mcmc, CI, average, terms, colour, coeff.lim)
    {

    #x spacement
    xspc<-0.5
    n <- ncol(mulTree.mcmc)
        
    # Set up the plot
    if (is.null(coeff.lim)){coeff.lim<-c(min(mulTree.mcmc) - 0.1*min(mulTree.mcmc), max(mulTree.mcmc) + 0.1*(max(mulTree.mcmc)))}

    plot(1,1 , xlab="", xlim = c(1 - xspc, n + xspc), ylim = coeff.lim, type = "n", xaxt = "n")
    #x or y label may change

    axis(side = 1, at = 1:n, labels = (terms))




    colours <- rep(colour, 5)
    for (j in 1:n) {
            temp <- hdr(mulTree.mcmc[, j], CI, h = bw.nrd0(mulTree.mcmc[,j]))
            line_widths <- seq(2, 20, by = 4)
            bwd <- c(0.1, 0.15, 0.2, 0.25, 0.3)
            #if (prn == TRUE) {
            #    cat(paste("Probability values for Column", j, "\n"))
            #}
            for (k in 1:length(CI)) {
                temp2 <- temp$hdr[k, ]
                type="boxes"
                if (type == "boxes") {
                    polygon(c(j - bwd[k], j - bwd[k], j + bwd[k], j + bwd[k]),
                      c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), 
                      max(temp2[!is.na(temp2)]), min(temp2[!is.na(temp2)])),
                      col = colours[k])
                    if (average == "mode") {points(j,temp$mode,pch=19)}
                    if (average == "mean") {points(j,mean(mulTree.mcmc[,j]),pch=19)}
                    if (average == "median") {points(j,median(mulTree.mcmc[,j]),pch=19)}

                }
                #if (prn == TRUE) {
                #    cat(paste("\t", CI[k], "% lower =", format(max(min(temp2[!is.na(temp2)]),
                #      0), digits = 2, scientific = FALSE), "upper =",
                #      format(min(max(temp2[!is.na(temp2)]), 1), digits = 2,
                #        scientific = FALSE), "\n"))
                #}
            } # close the loop across CI
        } # close the loop across teh columns in mulTree.mcmc
    }


#PLOTTING THE MCMCglmm RESULTS

    FUN.densityplot(mulTree.mcmc, CI, average, terms, colour, coeff.lim)
#OUTPUT

#End
}