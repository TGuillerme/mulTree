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
x<-rmtree(10,5) ; y<-rmtree(5,5)
#Combines 2 randomly chosen trees from x and from y into z putting the root age at 12.
z<-rTreeBind(x, y , sample=2, root.age=12)
}

\author{Thomas Guillerme}