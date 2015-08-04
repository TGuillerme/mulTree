\name{mulTree}
\alias{mulTree}

\title{Run MCMCglmm on multiple trees.}

\description{Running a MCMCglmm model on a list of phylogenies and the data combined using \code{as.mulTree}.
The results can be written out of R environment as individual models.
daoufhaeguaeughguhweguhw}

\usage{
mulTree(mulTree.data, formula, parameters, chains=2, priors=NULL, ...,
        convergence=1.1, ESS=1000, verbose=TRUE, output=TRUE, warn=FALSE)
}

\arguments{
\item{mulTree.data}{A list generated using \code{as.mulTree}.}

\item{formula}{An object of class \code{formula}.}

\item{parameters}{A list of three numerical values to be used respectively as: (1) the number of generations, (2) the sampling value, (3) the burnin.}

\item{chains}{The number of independent MCMC chains.}

\item{priors}{A series of priors to use for the mcmc (\code{NULL} is using the default parameters from MCMCglmm function) (default=\code{NULL}).}

\item{...}{Any additional argument to be passed to \code{MCMCglmm} function.}

\item{convergence}{A numerical value for assessing chain convergence (default=\code{1.1}).}

\item{ESS}{A numerical value for assessing the effective sample size (default=\code{1000})}

\item{verbose}{Whether to be verbose or not (default=\code{TRUE}).}

\item{output}{Any optional string of characters that will be used as chain name for the models output (default=\code{TRUE}).}

\item{warn}{Whether to print the warning messages from the MCMCglmm function (default=\code{FALSE}).}
}

\examples{
## Not run:
##Before the analysis:
##read in the data
data(lifespan)
##combine aves and mammalia trees
combined_trees<-rTreeBind(x=trees_mammalia, y=trees_aves, sample=2, root.age=250)

##Preparing the variables for the mulTree function
##creates the "mulTree" object
mulTree_data<-as.mulTree(data=lifespan_volant, trees=combined_trees, species="species")
##formula
mcmc.formula<-longevity ~ mass + volant
##parameters (number of generations, thin/sampling, burnin)
mcmc.parameters<-c(101000, 10, 1000) # For higher ESS run longer by increasing the number of generations
##priors
mcmc.priors<-list(R = list(V = 1/2, nu=0.002), G = list(G1=list(V = 1/2, nu=0.002)))

##Running MCMCglmm on multiple trees
##WARNING: This example takes between 1 and 2 minutes two run and generates files in your current directory.
mulTree(mulTree_data, formula=mcmc.formula, parameters=mcmc.parameters, priors=mcmc.priors, output="longevity.example", ESS = 50)

##The models are saved out of R environment under the "longevity.example" chains names.
##Use read.mulTree() to read the generated models.

##Remove the generated files from the current directory
file.remove(list.files(pattern="longevity.example"))


##Same example but including specimens
##read in the data
data(lifespan)
##combine aves and mammalia trees
combined_trees<-rTreeBind(x=trees_mammalia, y=trees_aves, sample=2, root.age=250)
##Subset of the data
data<-lifespan_volant[sample(nrow(lifespan_volant), 30),]
##Create a dataset with two specimen per species
data<-rbind(cbind(data, specimen=rep("spec1",30)),cbind(data, specimen=rep("spec2",30)))
##Cleaning the trees
trees<-clean.data(taxon="species", data, combined_trees)$tree

##Creates the mulTree object
mulTree_data<-as.mulTree(data, trees, species="species", rand.terms=~specimen)
##formula
mcmc.formula<-longevity ~ mass + volant
##parameters (number of generations, thin/sampling, burnin)
mcmc.parameters<-c(10100, 10, 100) # For higher ESS run longer by increasing the number of generations
##priors
mcmc.priors<-list(R = list(V = 1/2, nu=0.002), G = list(G1=list(V = 1/2, nu=0.002),G2=list(V = 1/2, nu=0.002)))

##Running MCMCglmm on multiple trees
mulTree(mulTree_data, formula=mcmc.formula, parameters=mcmc.parameters, priors=mcmc.priors, output="longevity.example", ESS = 50)
##Remove the generated files from the current directory
file.remove(list.files(pattern="longevity.example"))

## End(Not run)
}

\author{Thomas Guillerme & Kevin Healy}