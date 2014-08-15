\name{mulTree}
\alias{mulTree}

\title{Run MCMCglmm on multiple trees.}

\description{Running a MCMCglmm model on a list of phylogenies and the data combined using \code{as.mulTree}.
The results can be written out of R environment as individual models.}

\usage{
mulTree(mulTree.data, formula, parameters, chains=2, priors=NULL, ...,
        convergence=1.1, ESS=1000, verbose=FALSE, output=TRUE, warn=TRUE)
}

\arguments{
\item{mulTree.data}{A list generated using \code{as.mulTree}.}

\item{formula}{An object of class \code{formula}.}

\item{parameters}{A list of three numerical values to be used respectively as: (1) the number of generations, (2) the sampling value, (3) the burnin.}

\item{chains}{The number of independent MCMC chains.}

\item{priors}{A series of priors to use for the mcmc (default=NULL is using the default parameters from MCMCglmm function) (default=\code{NULL}).}

\item{...}{Any additional argument to be passed to \code{MCMCglmm} function.}

\item{convergence}{A numerical value for assessing chain convergence (default=\code{1.1}).}

\item{ESS}{A numerical value for assessing the effective sample size (default=\code{1000})}

\item{verbose}{Whether to be verbose or not (default=\code{FALSE}).}

\item{output}{Any optional string of characters that will be used as chain name for the models output (default=\code{TRUE}).}

\item{warn}{Whether to print the warning messages from the MCMCglmm function (default=TRUE).}
}

\examples{
## Not run:
##read in data
data(lifespan_volant_192taxa)
#read in separate aves and mammalia phylogenies with multiple trees
data(aves_2tree_58taxa)
data(mammalia_2tree_134taxa)
#combine aves and mammalia trees
combined_trees<-rTreeBind(x=mammalia_2tree_134taxa, y=aves_2tree_58taxa, sample=2, root.age=250)
#Creates the "mulTree" object
mulTree_data<-as.mulTree(data=lifespan_volant_192taxa, trees=combined_trees, species="species")
#formula
mcmc.formula <-longevity ~ mass + volant
#parameters (number of generations, thin/sampling, burnin) For higher parameter ESS run longer.
mcmc.parameters=c(101000, 10, 1000)
#priors
mcmc.priors<-list(R = list(V = 1/2, nu=0.002), G = list(G1=list(V = 1/2, nu=0.002)))

#mulTree
mulTree(mulTree_data, formula=mcmc.formula, parameters=mcmc.parameters, priors=mcmc.priors, verbose=TRUE, output="longevity.example", warn=FALSE, chains = 2, ESS = 50)

#Remove the generated files from the current directory
file.remove(list.files(pattern="mulTree.out"))
## End(Not run)
}

\author{Thomas Guillerme & Kevin Healy}