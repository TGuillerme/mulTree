\name{as.mulTree}
\alias{as.mulTree}

\title{Combines a data table and a "multiPhylo" object into a list to be used by the mulTree function}

\description{Combines a table and a multiple phylogenies using comparative.data{caper} function.
            Changes the name of the species column into "sp.col" to be read by comparative.data.}

\usage{
as.mulTree(data, trees, species, rand.terms=NULL, clean.data=FALSE)
}

\arguments{
\item{data}{Any table (\dQuote{data.frame} or \dQuote{matrix} object) containing at least two variable and species names}

\item{trees}{A \dQuote{multiPhylo} object}

\item{species}{Either the name or the number of the column containing the list of species in the data}

\item{rand.terms}{A \code{formula} object containing the additional random terms to add to the default random terms formula (phylogenetic effect). If NULL (default), the random terms is the column containing the species names and a column containing the specimen names if more than one species per specimen is present.}

\item{clean.data}{\code{logical}, whether to use the clean.data function. Default = \code{FALSE}. See the \link{clean.data} function for more details.}
}

\details{
If rand.terms is specified by the user, the first element is forced to be called animal.
}

\seealso{\link{clean.data}}

\examples{
##Creates a data.frame
data_table<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)))
##Creates a list of trees
trees_list<-rmtree(5,5, tip.label=LETTERS[1:5])
##Creates the "mulTree" object
as.mulTree(data_table, trees_list, species="taxa")

##Creating a mulTree object with multiple specimens
##Creates a data.frame with taxa being labelled as 'spec1'
data_table_sp1<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)), specimen=c(rep('spec1', 5)))
##Creates a data.frame with taxa being labelled as 'spec2'
data_table_sp2<-data.frame(taxa=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)), specimen=c(rep('spec2', 5)))
##Combines both data.frames
data_table<-rbind(data_table_sp1, data_table_sp2)
##Creates a list of trees
trees_list<-rmtree(5,5, tip.label=LETTERS[1:5])
##Creates the "mulTree" object (with a random term formula)
as.mulTree(data_table, trees_list, species="taxa", rand.terms=~taxa+specimen)
}




\author{Thomas Guillerme}