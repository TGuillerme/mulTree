\name{hdr.mulTree}
\alias{hdr.mulTree}

\title{Calculates the highest density regions for mulTree data}

\description{Performs the hdr function on mulTree data and outputs a list of hdr for each fixed and random terms.}

\usage{
hdr.mulTree(mulTree.mcmc, CI=95, ...)
}

\arguments{
\item{mulTree.mcmc}{A mcmc chain written by the mulTree function.}

\item{trees}{The credibility interval (can be more than one value).}

\item{...}{Any optional arguments to be passed to the hdr function.}
}

\details{
One might want to use the optional argument all.modes=TRUE option for reporting all the modes using the hdr function.
By default, hdr only calculates one mode.
}

\examples{
#Make example
}

\author{Thomas Guillerme}