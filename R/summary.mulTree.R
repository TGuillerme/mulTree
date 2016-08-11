#' @title Summarises \code{mulTree} data
#'
#' @description Summarises the \code{MCMCglmm} models calculated from multiple trees by caculating the highest density regions (\code{\link[hdrcde]{hdr}}) of the fixed and random terms.
#'
#' @param mulTree.results A \code{mulTree} object obtained from \code{\link{read.mulTree}} function.
#' @param prob One or more precentage values for to be the credibility intervals (\code{default = c(50, 95)}).
#' @param use.hdr Logical, whether to calculate the highest density region using \code{\link[hdrcde]{hdr}} (\code{TRUE}) or the quantiles using \code{\link[stats]{quantile}} (\code{FALSE}).
#' @param cent.tend A function for calculating the central tendency (\code{default = median}) from the quantiles (if \code{use.hdr = FALSE}; else is ignored).
#' @param ... Any optional arguments to be passed to the \code{\link[hdrcde]{hdr}} or \code{\link[stats]{quantile}} functions.
#'
#' @details
#' When using the highest density region caculation method (\code{use.hdr = TRUE}), the returned central tendency is always the first estimated mode (see \code{\link[hdrcde]{hdr}}).
#' Note that the results maybe vary when using \code{use.hdr = FALSE} or \code{TRUE}.
#' We recommend to use \code{use.hdr = TRUE} when possible.
#'
#' When \code{use.hdr = FALSE}, the computation is faster but the quantiles are calculated and not estimated.
#'  
#' When \code{use.hdr = TRUE}, the computation is slower but the quantiles are estimated using the highest density regions.
#' The given estimates central tendency is calculated as the mode of the estimated highest density region.
#' For speeding up the calculations, the bandwidth (\code{h} argument) from \code{\link[hdrcde]{hdr}} can be estimated by using \code{\link[stats]{bw.nrd0}}.
#'
#' @return
#' A \code{matrix} of class \code{mulTree}.
#'
#' @examples
#' ## Read in the data
#' data(lifespan.mcmc)
#' 
#' ## Summarizing all the chains
#' summary(lifespan.mcmc)
#' 
#' ## Modyfing the CI
#' summary(lifespan.mcmc, prob = 95)
#' 
#' ## Using use.hdr = FALSE
#' summary(lifespan.mcmc, use.hdr = FALSE)
#'
#' @seealso \code{\link{mulTree}}, \code{\link{read.mulTree}}, \code{\link{plot.mulTree}}
#' @author Thomas Guillerme
#' 
#' @export 

# DEBUG
# source("sanitizing.R")
# source("summary.mulTree_fun.R")

summary.mulTree <- function(mulTree.results, prob = c(50, 95), use.hdr = TRUE, cent.tend = median, ...) {
    #Set method
    #UseMethod(summary, mulTree)
    match_call <- match.call()

    #SANITIZING
    #mulTree.results
    check.class(mulTree.results, "mulTree", " is not of class mulTree.\nUse read.mulTree() to properly load the data.")

    #prob
    check.class(prob, "numeric")
    if(any(prob > 100) | any(prob < 0)) {
        stop("prob argument must percentages (between 0 and 100).")
    }

    #cent.tend
    check.class(cent.tend, c("function", "standardGeneric"))
    #check if the function properly outputs a single value
    try(test_cent.tend <- cent.tend(rnorm(100)), silent = TRUE)
    if(length(test_cent.tend) != 1 & class(test_cent.tend) != "numeric") {
        stop(paste(match_call$cent.tend, " cannot calculate a central tendency of a distribution."))
    }

    #use.hdr
    check.class(use.hdr, "logical")

    #SUMMARISING
    if(use.hdr == FALSE) {
        #Calculate the quantiles
        mulTree_results <- lapply(mulTree.results, lapply.quantile, prob, cent.tend, ...)
        #mulTree_results <- lapply(mulTree.results, lapply.quantile, prob, cent.tend) ; warning("DEBUG MODE")
    } else {
        #Calculate the hdr
        mulTree_results <- try(mapply(lapply.hdr, mulTree.results, as.list(names(mulTree.results)), MoreArgs=list(prob, ...), SIMPLIFY=FALSE), silent = TRUE)
        #mulTree_results <- try(mapply(lapply.hdr, mulTree.results, as.list(names(mulTree.results)), MoreArgs=list(prob), SIMPLIFY=FALSE), silent = TRUE) ; warning("DEBUG MODE")
        if(class(mulTree_results) == "try-error") {
            stop(paste("Impossible to calculate the HDR!\n",
                "Try using the option 'use.hdr = FALSE' for calculating the quantiles instead.\n",
                "'hdr' function gave the following error:\n",
                mulTree_results[[1]],
                sep = ""))
        }
    }

    #Transform the results into a table
    results_out <- result.list.to.table(mulTree_results)
    #Add the names
    if(use.hdr == FALSE) {
        if(is.null(match_call$cent.tend)) {
            estimate <- "Estimates(median)"
        } else {
            estimate <- paste("Estimates(", match_call$cent.tend,")", sep="") 
        }
    } else {
        estimate <- "Estimates(mode hdr)"
    }
    colnames(results_out) <- c(estimate, paste(c(rep("lower.CI(", length(prob)), rep("upper.CI(", length(prob))), prob.converter(prob)*100, ")", sep=""))
    rownames(results_out) <- names(mulTree.results)

    #Set class
    class(results_out) <- c("matrix", "mulTree")

    return(results_out)
}