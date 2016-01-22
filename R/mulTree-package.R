# devtools::build_win(version = "R-devel")

#' Performs MCMCglmm On Multiple Phylogenetic Trees.
#' 
#' Allows to run a MCMCglmm on multiuple phylogenetic trees to take into account phylogenetic uncertainty.
#' 
#' @name mulTree-package
#'
#' @aliases mulTree
#'
#' @docType package
#'
#' @author Thomas Guillerme <guillert@tcd.ie> & Kevin Healy <heaylke@tcd.ie>
#'
#' @references Healy, K., Guillerme T., Finlay, S., Kane, A., Kelly, S.B.A., McClean, D., Kelly, D.J., Donohue, I., Jackson, A.L. and Cooper, N. ,
#' 2014. Ecology and mode of life explain lifespan variation in birds and mammals. Proceedings of the Royal Society of London B. 281(1784), 20140298, 
#'
#' @keywords phylogenetic correction, MCMCglmm, bayesian, tree distribution
#'
#' @import ape
#' @import caper
#' @import coda
#' @import MCMCglmm
#' @import hdrcde
#' @import snow
NULL


#' Example Aves and Mammalia lifespan for the mulTree package
#'
#' This is a dataset containing lifespan data from 192 species of birds and mammals.
#'
#' @name lifespan_volant_192taxa
#' @docType data
#'
#' @format The datafile contains a data frame (\code{lifespan_volant_192taxa}) of 192 complete cases for those species. The data frame contains five variables:
#' \describe{
#'        \item{species}{The species binomial name.}
#'        \item{class}{The species phylogenetic class.}
#'        \item{longevity}{The mean centred logged maximum lifespan in years.}
#'        \item{mass}{The mean centred logged body mass in grams.}
#'        \item{volant}{Flying ability, as a two level factor: volant and nonvolant.}
#' }
#'
#' @references Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (2014) Ecology and mode-of-life explain lifespan variation in birds and mammals. Proceedings of the Royal Society B 281, 20140298c
#'
#' @keywords datasets
NULL


#' Example of mulTree analysis data
#'
#' This is an example of MCMCglmm output files using the \code{\link{mulTree}} function on the \code{lifespan} data.
#'
#' @name lifespan.mcmc
#' @docType data
#'
#' @format Contains the results of a \code{mulTree} analysis on two trees with two independent chains per trees.
#'
#' @references Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (2014) Ecology and mode-of-life explain lifespan variation in birds and mammals. Proceedings of the Royal Society B 281, 20140298c
#'
#' @keywords datasets
NULL


#' Example dataset for the \code{mulTree} package
#'
#' This is a dataset containing lifespan data and trees from Healy et al (2014)
#'
#' @name lifespan
#' @docType data
#'
#' @format Contains a \code{data.frame} and two \code{multiPhylo} objects:
#'    \describe{
#'        \item{lifespan_volant}{A \code{data.frame} object of five variables for 192 species (see \code{\link{lifespan_volant_192taxa}}).}
#'        \item{trees_aves}{A \code{multiPhylo} object of two trees of 58 bird species. The tip names are the binomial names of the species.}
#'        \item{trees_mammalia}{A a \code{multiPhylo} object of two trees of 134 mammal species. The tip names are the binomial names of the species.}
#'    }
#'
#' @references Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (2014) Ecology and mode-of-life explain lifespan variation in birds and mammals. Proceedings of the Royal Society B 281, 20140298c
#'
#' @keywords datasets
NULL

