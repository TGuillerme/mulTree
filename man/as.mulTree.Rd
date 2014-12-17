\name{as.mulTree}
\alias{as.mulTree}

\title{Combines a data table and a "multiPhylo" object into a list to be used by the mulTree function}

\description{Combines a table and a multiple phylogenies using comparative.data{caper} function.
            Changes the name of the species column into "sp.col" to be read by comparative.data.}

\usage{
as.mulTree(data, trees, species, rand.terms=NULL)
}

\arguments{
\item{data}{Any table (\dQuote{data.frame} or \dQuote{matrix} object) containing at least two variable and species names}

\item{trees}{A \dQuote{multiPhylo} object}

\item{species}{Either the name or the number of the column containing the list of species in the data}

\item{rand.terms}{A \code{formula} for the random terms to be given to the MCMCglmm function where each elements are a column of the given data. If \code{NULL} (default), the random terms is the column containing the species names and a column containing the specimen names if more than one species per specimen is present.}
}

\examples{
##Creates a data.frame
data_table<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)))
##Creates a list of trees
trees_list<-rmtree(5,5, tip.label=LETTERS[1:5])
##Creates the "mulTree" object
mulTree_data<-as.mulTree(data_table, trees_list, species="taxa")
}



\author{Thomas Guillerme}