\name{rTreeBind}
\alias{rTreeBind}

\title{Randomly binds trees together}

\description{Randomly binds trees together with a provided number of trees and a root age.}

\usage{
rTreeBind(x, y, sample, root.age)
}

\arguments{
\item{x, y}{Two \code{phylo} or \code{multiPhylo} objects.}

\item{sample}{The number of trees to create.}

\item{root.age}{The age of the root where both trees are combined (can be any unit).}
}


\examples{

##Combines 2 randomly chosen trees from x and from y into z putting the root age at 12.
x<-rmtree(10,5) ; y<-rmtree(5,5)
z<-rTreeBind(x, y , sample=3, root.age=12)

##Combines one mammal and and one bird tree and setting the root age at 250 Mya.
data(lifespan)
combined_trees<-rTreeBind(trees_mammalia, trees_aves, sample=1, root.age=250)
plot(conbined_trees)

}

\author{Thomas Guillerme}