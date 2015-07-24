##########################
#Plots the results of a mulTree analysis
##########################
#Plots a boxplots of the fixed and random terms of the summarized multi tree MCMCglmm
#v0.3
#Update: isolated function externally
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
#<horizontal> whether to plot the boxplots horizontally or not (default=FALSE)
#<cex.terms> size of the terms on the axis (can be missing)
#<cex.coeff> size of the terms on the axis (can be missing)
##########################
#----
#guillert(at)tcd.ie - 24/08/2015
##########################
#Requirements:
#-R 3
#-R package "hdrcde"
##########################


plot.mulTree<-function(mulTree.mcmc, CI=c(95, 75, 50), average="mode", terms=NULL, colour=NULL, coeff.lim=NULL, ..., horizontal=FALSE, cex.terms, cex.coeff)
{
#HEADER
    require(hdrcde)

#DATA
    #mulTree.mcmc
    check.class(mulTree.mcmc, 'mulTree', " must be a 'mulTree' object.\nUse read.mulTree() function.")
    #rebuild mulTree.mcmc as a data.frame
    class(mulTree.mcmc)<-"data.frame"

    #CI
    check.class(CI, 'numeric', " is not numeric.")
    if (any(CI < 0)) {
        stop("Credibility interval must be between 0 and 100.", call.=FALSE)
    } else {
        if (any(CI > 100)) {
            stop("Credibility interval must be between 0 and 100.", call.=FALSE)
        }
    }

    #average
    first.moment<-c("mode", "median", "mean")
    check.class(average, 'character', "must be either \"mode\", \"median\" or \"mean\".")
    if (any(average == first.moment)) {
        ok<-"ok"
    } else {
        stop("\"average\" must be either \"mode\", \"median\" or \"mean\".", call.=FALSE)
    }       

    #horizontal
    check.class(horizontal, 'logical', " must be logical.")

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
        check.class(coeff.lim, 'numeric', " must be numeric.")
        check.length(coeff.lim, 2, " must be a list of two elements.")
    }

    #cex
    if(missing(cex.terms)) {
        cex.terms=1
    } else {
        check.class(cex.terms, 'numeric', " must be numeric.")
    }

    if(missing(cex.coeff)) {
        cex.coeff=1
    } else {
        check.class(cex.coeff, 'numeric', " must be numeric.")
    }
#funCTION

    #plots one polygon
    fun.polygon<-function(mulTree.mcmc, n, CI, average, colours, horizontal)
    {
        #calculates the hdr
        temp <- hdr(mulTree.mcmc[,n], CI, h = bw.nrd0(mulTree.mcmc[,n]))

        #setting box parameters
        box_width <- seq(from=0.1, by = 0.05, length.out=length(CI))

        #plotting the boxes
        if (horizontal == FALSE) {

            for (box in 1:length(CI)) {
                temp2 <- temp$hdr[box,]
                polygon(c(n - box_width[box], n - box_width[box], n + box_width[box], n + box_width[box]), #x
                  c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), min(temp2[!is.na(temp2)])), #y
                  col = colours[box]) 
            }

            #adding the average
            if (average == "mode") {
                points(n, temp$mode, pch=19)
            }
            if (average == "mean") {
                points(n, mean(mulTree.mcmc[,n]), pch=19)
            }
            if (average == "median") {
                points(n, median(mulTree.mcmc[,n]), pch=19)
            }

        } else {
            for (box in 1:length(CI)) { #reverse the terms to go from top to bottom
                temp2 <- temp$hdr[box,]
                polygon(c(min(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), max(temp2[!is.na(temp2)]), min(temp2[!is.na(temp2)])), #x
                  c(n - box_width[box], n - box_width[box], n + box_width[box], n + box_width[box]), #y
                  col = colours[box])
            }

            #adding the average
            if (average == "mode") {
                points(temp$mode, n, pch=19)
            }
            if (average == "mean") {
                points(mean(mulTree.mcmc[,n]), n, pch=19)
            }
            if (average == "median") {
                points(median(mulTree.mcmc[,n]), n, pch=19)
            }
        }
    } 

    #Density Plot function (from densityplot.R by Andrew Jackson - a.jackson@tcd.ie)
    fun.densityplot <- function (mulTree.mcmc, CI, average, terms, colour, coeff.lim, horizontal, ...)
    {
        #x spacement
        xspc<-0.5

        #number of boxes
        n<-ncol(mulTree.mcmc)
            
        #add axis
        if (horizontal == FALSE) {
            #blank plot frame
            plot(1,1 , xlab="", ylab="", xlim = c(1 - xspc, ncol(mulTree.mcmc) + xspc), ylim = coeff.lim, type = "n", xaxt = "n", yaxt="n", bty = "n", ...)
            #coeff.estimates (is y)
            axis(side = 2, cex.axis=cex.coeff)
            #terms (is x)
            axis(side = 1, at = 1:ncol(mulTree.mcmc), labels = (terms), las=2, cex.axis=cex.terms)
        } else {
            plot(1,1 , xlab="", ylab="", ylim = c(1 - xspc, ncol(mulTree.mcmc) + xspc), xlim = coeff.lim, type = "n", xaxt = "n", yaxt="n", bty = "n", ...)
            #coeff.estimates (is x)
            axis(side = 3, cex.axis=cex.coeff)
            #terms (is y)
            axis(side = 2, at = 1:ncol(mulTree.mcmc), labels = rev(terms), las=2, cex.axis=cex.terms) #reverse the terms to go from top to bottom
        }

        #set the colours for the boxplots
        colours <- rep(colour, 5)

        #creates the boxplots using hdr and add them to the plot
        for (n in 1:ncol(mulTree.mcmc)) {
            fun.polygon(mulTree.mcmc, n, CI, average, colours, horizontal)
        } 
    }

#PLOTTING THE MCMCglmm RESULTS

    if(horizontal == TRUE) {
        fun.densityplot(rev(mulTree.mcmc), CI, average, terms, colour, coeff.lim, horizontal, ...)
    } else {
        fun.densityplot(mulTree.mcmc, CI, average, terms, colour, coeff.lim, horizontal, ...)
    }

#OUTPUT

#End
}