\name{summary.mulTree}
\alias{summary.mulTree}

\title{Summarise "mulTree" data}

\description{Summarise MCMCglmm by performing the hdr function on mulTree data and outputs a list of hdr for each fixed and random terms.}

\usage{
## S3 method for class 'mulTree'
summary(mulTree.mcmc, CI=95, ...)
}

\arguments{
\item{mulTree.mcmc}{A "mulTree" object obtained from \code{read.mulTree()} function.}

\item{CI}{A value for the lower and upper credibility intervals (default=95).}

\item{...}{Any optional arguments to be passed to the \code{hdr} function.}
}


\examples{
#Do example
}

\author{Thomas Guillerme}