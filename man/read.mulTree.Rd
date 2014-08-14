\name{read.mulTree}
\alias{read.mulTree}

\title{Reads MCMC objects from mulTree function}

\description{Reads MCMC objects from mulTree function stored out of R environment}

\usage{
read.mulTree(mulTree.mcmc, convergence=FALSE)
}

\arguments{
\item{mulTree.mcmc}{A MCMC chain written by the \code{mulTree} function.
    Can be either a unique file or a chain name referring to multiple files.}

\item{convergence}{Logical, whether to read the convergence file associated (default=\code{FALSE}).}

\item{model}{Logical, if \code{mulTree.mcmc} is not a chain name, whether to input the \code{MCMCglmm} model or the list of random and fixed terms only (default=FALSE)}
}

\details{
\code{model=TRUE} can be used to load the \code{MCMCglmm} object of a unique chain. The resulting object can be then summarized or plotted as S3 method for class \code{'MCMCglmm'}.
}

\examples{
#CREATING THE FILES
data_table<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)))
trees_list<-list() ; for (i in 1:2) {trees_list[[i]]<-rcoal(5, tip.label=LETTERS[1:5])} ; class(trees_list)<-'multiPhylo'
mulTree_data<-as.mulTree(data_table, trees_list, species="taxa")
form=var1~var2
param=c(10000, 100, 250)
prior<-list(R = list(V = 1/2, nu=0.002), G = list(G1=list(V = 1/2, nu=0.002)))
mulTree(mulTree_data, form, param, priors=prior, verbose=FALSE, output="mulTree.ex", warn=FALSE)
 
#Reading one chain
tree1_chain1<-read.mulTree("mulTree.ex_tree1_chain1.rda")
traceplot(tree1_chain1\$Sol) #plotting the chain

#Reading all the chains for both trees
all_chains<-read.mulTree("mulTree.ex")
summary(all_chains) #Use sum.mulTree to properly summarize the data!

#Reading a single the convergence file for tree 1
read.mulTree("mulTree.ex_tree1", convergence=TRUE) #both chains for tree 1 didn't converged!

#Remove the generated files from the current directory
file.remove(list.files(pattern="mulTree.ex"))
#TRUE TRUE TRUE TRUE TRUE TRUE
}

\author{Thomas Guillerme}