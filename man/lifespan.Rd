
%Data manual format

\name{lifespan}
\alias{lifespan}

\title{Example dataset for the mulTree package}
\description{
This is a dataset containing lifespan data and trees from Healy et al (2014)
}
\usage{
data(lifespan)
}

\format{
Contains a \code{data.frame} and two \code{multiPhylo} objects:
    \describe{
        \item{lifespan_volant}{A \code{data.frame} object of five variables for 192 species (see \code{\link{lifespan_volant_192taxa}}).}
        \item{trees_aves}{A \code{multiPhylo} object of two trees of 58 bird species. The tip names are the binomial names of the species.}
        \item{trees_mammalia}{A a \code{multiPhylo} object of two trees of 134 mammal species. The tip names are the binomial names of the species.}
    }
}

\references{Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (2014) Ecology and mode-of-life explain lifespan variation in birds and mammals. Proceedings of the Royal Society B 281, 20140298}


