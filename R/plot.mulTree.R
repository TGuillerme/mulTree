#' @title Plots \code{mulTree} results
#'
#' @description Plots a boxplots of the terms of a \code{mulTree} analysis.
#'
#' @param mulTree.summary A \code{mulTree} matrix summarized by \code{\link{summary.mulTree}}.
#' @param terms An optional vector of terms labels.
#' @param cex.terms An optional value for the size of the terms labels.
#' @param cex.coeff An optional value for the size of the coefficients labels.
#' @param horizontal Whether to plot the results horizontally (\code{default = FALSE}).
#' @param ylim Optional, the y limits of the plot.
#' @param col Optional, the color of the plot.
#' @param ... Any additional arguments to be passed to \code{\link[graphics]{plot}}.
#' 
#' @examples
#' ## read in the data
#' data(lifespan.mcmc)
#' 
#' ## summarising the results
#' summarized_data <- summary(lifespan.mcmc)
#'
#' ## plotting the results
#' plot(summarized_data)
#' 
#' ## Same plot using more options
#' plot(summarized_data, horizontal = TRUE, ylab = "", ylim = c(-2,2),
#'      main = "Posterior distributions", cex.terms = 0.5, cex.coeff = 0.8.
#'      terms = c("Intercept", "BodyMass", "Volancy", "Phylogeny", "Residuals"),
#'      col = c("red"), cex.main = 0.8)
#' abline(v = 0, lty = 3)
#'
#' @seealso \code{\link{mulTree}}, \code{\link{read.mulTree}}, \code{\link{summary.mulTree}}
#' @author Thomas Guillerme
#' 
#' @export 

#DEBUG 
# source("sanitizing.R")
# source("plot.mulTree_fun.R")

plot.mulTree <- function(mulTree.summary, terms, cex.terms, cex.coeff, horizontal = FALSE, ylim, col, ...) {

    match_call <- match.call()

    #SANITIZING
    #mulTree.results
    if(!all(class(mulTree.summary) == c("matrix","mulTree"))) {
        stop(match_call$mulTree.summary, " is not mulTree matrix.\nUse summary.mulTree() to properly generate the data.", sep = "")   
    }

    #terms
    if(!missing(terms)) {
        check.class(terms, "character")
        check.length(terms, nrow(mulTree.summary), paste(" must have the same number of terms as ", match_call$mulTree.summary, sep = ""), errorif = FALSE)
    } else {
        terms <- rownames(mulTree.summary)
    }

    #cex.terms
    if(!missing(cex.terms)) {
        check.class(cex.terms, "numeric")
        check.length(cex.terms, 1, " must be a single value for the size of the terms labels.")
    }

    #cex.terms
    if(!missing(cex.coeff)) {
        check.class(cex.coeff, "numeric")
        check.length(cex.coeff, 1, " must be a single value for the size of the coefficients labels.")
    }

    #horizontal
    check.class(horizontal, "logical")

    #default optional arguments
    #Get the automatic ylimits
    if(missing(ylim)) {
        ylim <- get.ylim(mulTree.summary)
    }

    #Get the automatic colours
    if(missing(col)) {
        col <- gray(seq(from = 1-(1/((ncol(mulTree.summary)-1)/2*2)), to = 0+(1/((ncol(mulTree.summary)-1)/2*2)), length.out = (ncol(mulTree.summary)-1)/2))
    }


    #PLOTTING THE RESULTS
    #Set up the space between terms
    terms_space <- 0.5
    #Plot the frame
    if (horizontal == FALSE) {
        #Plot the horizontal frame
        plot(1,1, xlim = c(1 - terms_space, nrow(mulTree.summary) + terms_space), ylim = ylim, type = "n", xaxt = "n", yaxt = "n", bty = "n", ...)
        #plot(1,1, xlim = c(1 - terms_space, nrow(mulTree.summary) + terms_space), ylim = ylim, type = "n", xaxt = "n", yaxt = "n", bty = "n",) ; warning("DEBUG MODE")

        #Adding the y axis (coefficients)
        if(!missing(cex.coeff)) {
            axis(side = 2, cex.axis = cex.coeff)
        } else {
            axis(side = 2)
        }

        #Adding the x axis (terms)
        if(!missing(cex.terms)) {
            axis(side = 1, at = 1:nrow(mulTree.summary), labels = terms, las = 2, cex.axis = cex.terms)
        } else {
            axis(side = 1, at = 1:nrow(mulTree.summary), labels = terms, las = 2)
        }

    } else {
        #Plot the vertical frame
        plot(1,1, ylim = c(1 - terms_space, nrow(mulTree.summary) + terms_space), xlim = ylim, type = "n", xaxt = "n", yaxt = "n", bty = "n", ...)
        #plot(1,1, ylim = c(1 - terms_space, nrow(mulTree.summary) + terms_space), xlim = ylim, type = "n", xaxt = "n", yaxt = "n", bty = "n") ; warning("DEBUG MODE")
        
        #Adding the y axis (terms)
        if(!missing(cex.terms)) {
            axis(side = 2, at = 1:nrow(mulTree.summary), labels = rev(terms), las = 2, cex.axis = cex.terms)
        } else {
            axis(side = 2, at = 1:nrow(mulTree.summary), labels = rev(terms), las = 2)
        }

        #Adding the x axis (coefficients)
        if(!missing(cex.coeff)) {
            axis(side = 3, cex.axis = cex.coeff)
        } else {
            axis(side = 3)
        }
    }
    
    #Setting box parameters
    box_width <- seq(from=0.1, by = 0.05, length.out = (ncol(mulTree.summary)-1)/2)

    #Drawing the polygons
    for (term in 1:nrow(mulTree.summary)) {
        for (CI in 1:c((ncol(mulTree.summary)-1)/2)) {
            #Drawing the polygons
            if(horizontal == FALSE) {
                polygon(x = get.width(box_width, term, CI), y = get.height(mulTree.summary, term, CI), col = col)
            } else {
                polygon(y = get.width(box_width, nrow(mulTree.summary)-(term-1), CI), x = get.height(mulTree.summary, term, CI), col = col)
            }
        }
        #Drawing the central tendencies
        if(horizontal == FALSE) {
            points(term, mulTree.summary[term, 1], pch = 19)
        } else {
            points(mulTree.summary[term, 1], nrow(mulTree.summary)-(term-1), pch = 19)
        }
    }

}
