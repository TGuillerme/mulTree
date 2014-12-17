\name{clean.data}
\alias{clean.data}

\title{Cleans a table/tree to match with a given table/tree}

\description{Cleans data table or "phylo" objects to match the tips of the "phylo" objects with a given data.frame.}

\usage{
clean.data(taxon, data, tree)
}

\arguments{
\item{taxon}{\code{numerical} or \code{character} value refering to the column in \code{data} containing the taxon list.}

\item{data}{A \dQuote{data.frame}, \dQuote{matrix}, \dQuote{phylo} or \dQuote{multiPhylo} object.}

\item{tree}{A \dQuote{phylo} or \dQuote{multiPhylo} object.}
}

\details{
If both \code{data} and \code{tree} are provided:
-\code{data} must be a \dQuote{vector}, \dQuote{data.frame}, or \dQuote{matrix} object;
-\code{taxon} can be a column name or value present in \code{data};
-the function returns a list of two elements, the first one being the eventually trimmed \code{data} and the second being the eventually trimmed \code{tree}.
}
\examples{

##Create a set of different trees
trees_list<-list(rtree(5, tip.label=LETTERS[1:5]), rtree(4, tip.label=LETTERS[1:4]), rtree(6, tip.label=LETTERS[1:6])) ; class(trees_list)<-"multiPhylo"
##Creates a data frame
dummy_data<-data.frame(taxon.list=LETTERS[1:5], var1=rnorm(5), var2=c(rep('a',2), rep('b',3)))
##Name of column containing the taxon
taxon_column<-"taxon.list"

##Cleaning the trees and the data
cleaned<-clean.data(taxon=taxon_column, data=dummy_data, tree=tree_list)
##The taxa that where dropped:
cleaned$dropped.taxon
##The cleaned trees:
cleaned$tree
##The cleaned data set:
cleaned$data
}



\author{Thomas Guillerme}