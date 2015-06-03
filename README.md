mulTree
=======

[![DOI](https://zenodo.org/badge/7411/TGuillerme/mulTree.png)](http://dx.doi.org/10.5281/zenodo.12902)

Performs MCMCglmm on multiple phylogenetic trees

mulTree
-------
This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees.
This code has been used prior to this package release in [Healy et. al. (2014)](http://rspb.royalsocietypublishing.org/content/281/1784/20140298.full.pdf?ijkey=gPt28ElSAYBvRhZ&keytype=ref).
Please send me an [email](mailto:guillert@tcd.ie) or a pull request if you find/have any issue using this package.

Features
--------
* `rTreeBind`: randomly binds trees together

* `as.mulTree`: combines a data table and a "*multiPhylo*" object into a list to be used by the `mulTree` function

* `mulTree`: run MCMCglmm on multiple trees

* `read.mulTree`: reads MCMC objects from `mulTree` function

* `summary.mulTree`: summarise "*mulTree*" data

* `plot.mulTree`: plots the "*mulTree*" data

Patch notes
----
* 2015/06/03 - v1.0.3
  * `as.mulTree` now deals properly with same taxa entries.
* 2015/05/17 - v1.0.2
  * Fixed bug in `as.mulTree` function with the random terms management.
* 2014/12/19 - v1.0.1
  * NEW: `clean.data` function allows to match data and multiple trees and drop the non-shared taxa.
  * `as.mulTree` function now allows multiple specimens for any taxa and allows the user to fix the random terms to be passed to the `mulTree` function.

Installing mulTree
------------------
```r
#install.packages("devtools")
library(devtools)
install_github("TGuillerme/mulTree")
library(mulTree)
```

Authors
-------
[Thomas Guillerme](http://tguillerme.github.io) & [Kevin Healy](http://healyke.github.io)


Citation
-------
If you are using this package, please cite:

* Guillerme, T. & Healy, K. (**2014**). mulTree: a package for running MCMCglmm analysis on multiple trees. ZENODO. 10.5281/zenodo.12902


Used in
-------
* Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (**2014**) Ecology and mode-of-life explain lifespan variation in birds and mammals. *Proceedings of the Royal Society B* 281, 20140298. [DOI:10.1098/rspb.2014.0298](http://rspb.royalsocietypublishing.org/content/281/1784/20140298?ijkey=1d6acd5357bbd6b611bd0d38b7cacd7a03d83dd1&keytype2=tf_ipsecsha)
* Healy, K. (**2015**) Eusociality but not fossoriality drives longevity in small mammals. *Proceedings of the Royal Society B* 282, 20142917. [DOI: 10.1098/rspb.2014.2917](http://rspb.royalsocietypublishing.org/content/282/1806/20142917)
