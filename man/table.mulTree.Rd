\name{table.mulTree}
\alias{table.mulTree}

\title{Summarizes MCMCglmm objects into a table}

\description{Summarizes MCMCglmm objects into a table containing the results of the fixed and random terms.}

\usage{
table.mulTree(mulTree.mcmc)
}

\arguments{
\item{mulTree.mcmc}{A mcmc chain written by the mulTree function.}
}

\details{
\code{mulTree.mcmc} Can be either a unique file or a chain name referring to multiple files. Use read.mulTree() to properly load the chains.
}

\examples{
#Do example
}

\author{Thomas Guillerme}