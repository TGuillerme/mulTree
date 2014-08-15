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
data_table<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)))
#Creates a list of trees
trees_list<-list() ; for (i in 1:5) {trees_list[[i]]<-rcoal(5, tip.label=LETTERS[1:5])}
class(trees_list)<-'multiPhylo'
#Creates the "mulTree" object
mulTree_data<-as.mulTree(data_table, trees_list, species="taxa")
#formula
<<<<<<< HEAD
<<<<<<< HEAD
mcmc.formula <-longevity ~ mass + volant
#parameters (number of generations, thin/sampling, burnin) For higher parameter ESS run longer.
mcmc.parameters=c(101000, 10, 1000)
=======
form=var1~var2
#parameters
param=c(100000, 1000, 25000)
>>>>>>> parent of 1c7c606... Merge pull request #1 from healyke/master
=======
form=var1~var2
#parameters
param=c(100000, 1000, 25000)
>>>>>>> parent of 1c7c606... Merge pull request #1 from healyke/master
#priors
prior<-list(R = list(V = 1/2, nu=0.002), G = list(G1=list(V = 1/2, nu=0.002)))

#mulTree
<<<<<<< HEAD
<<<<<<< HEAD
mulTree(mulTree_data, formula=mcmc.formula, parameters=mcmc.parameters, priors=mcmc.priors, verbose=TRUE, output="longevity.example", warn=FALSE, chains = 2, ESS = 50)
=======
mulTree(mulTree_data, form, param, priors=prior, verbose=TRUE, warn=FALSE)
>>>>>>> parent of 1c7c606... Merge pull request #1 from healyke/master
=======
mulTree(mulTree_data, form, param, priors=prior, verbose=TRUE, warn=FALSE)
>>>>>>> parent of 1c7c606... Merge pull request #1 from healyke/master

#Remove the generated files from the current directory
file.remove(list.files(pattern="mulTree.out"))
## End(Not run)
}

\author{Thomas Guillerme & Kevin Healy}
