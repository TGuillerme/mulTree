\name{plot.mulTree}
\alias{plot.mulTree}

\title{Plots the results of a mulTree analysis}

\description{Plots a series of boxplots of the fixed and random terms of a 'mulTree' object.}

\usage{
## S3 method for class 'mulTree'
plot(mulTree.mcmc, CI=c(95, 75, 50), average="mode", horizontal=FALSE, terms=NULL, colour=NULL, coeff.lim=NULL, ...)
}
\arguments{
\item{mulTree.mcmc}{{A "mulTree" object obtained from \code{read.mulTree()} function.}}
\item{CI}{The credibility intervals (default=c(95, 90, 50).}
\item{average}{The central tendency of the distribution to plot. Can be either 'mode', 'median' or 'mean' (default="mode").}
\item{use.hdr}{Logical. Whether to use the \code{hdrcde::hdr} (\code{TRUE}) or \code{stats::quantile} (\code{FALSE}) functions for summarising the data.}
\item{terms}{A list of terms, if \code{NULL}, the terms are extracted from mulTree.mcmc (default=\code{NULL}).}
\item{colour}{Any colour or list of colour for the plot, if \code{NULL} colour is set to grey scale (default=\code{NULL}).}
\item{coeff.lim}{The estimate coefficient range, if \code{NULL}, the range is set to the extreme values of mulTree.mcmc +/- 10\% (default=\code{NULL}).}
\item{horizontal}{Logical, whether to plot the boxplots horizontally or not (default=\code{FALSE}).}
\item{cex.terms}{size of the terms on the axis (can be missing)}
\item{cex.coeff}{size of the coefficients on the axis (can be missing)}
\item{...}{Any optional arguments to be passed to the \code{plot}.}
}

\details{
    Note that the results maybe vary when using \code{use.hdr = FALSE} or \code{TRUE}.
    We recommend to use \code{use.hdr = TRUE} when possible.

    When \code{use.hdr = FALSE}, the computation is faster but the quantiles are calculated and not estimated.
    The given estimates central tendency is calculated as the median.
    
    When \code{use.hdr = TRUE}, the computation is slower but the quantiles are estimated using the highest density regions.
    The given estimates central tendency is calculated as the mode of the estimated highest density region.
    For the speeding and facilitating the graphical output, the \code{hdrcde::hdr h} argument is set to: \code{h = stats::bw.nrd0}.

}

\seealso{\link{read.mulTree}, \link{summary.mulTree}}

\examples{
## read in the data
data(lifespan.mcmc)

## plotting the results
plot(lifespan.mcmc)

## fancy plot using some of the options
op<-par(mar=c(1,7,6,1))
plot(lifespan.mcmc, CI=c(50, 25), average="mean", horizontal=TRUE, 
    terms=c("Intercept", "Body Mass", "Volancy", "Phylogeny", "Residuals"),
    colour=c('blue', 'red'), main='Posterior distribution', coeff.lim=c(-1, 1.5))
abline(v=0, lty=3)
par(op)
}

\author{Thomas Guillerme}