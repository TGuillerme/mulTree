mulTree
=======
Performs MCMCglmm on multiple phylogenetic trees

mulTree
-------
This pacakged is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees.
This code method has been used prior to this package release in [Healy et. al. (2014)](http://rspb.royalsocietypublishing.org/content/281/1784/20140298.full.pdf?ijkey=gPt28ElSAYBvRhZ&keytype=ref).

Features
--------
* rTreeBind: randomly binds trees together

* as.mulTree: combines a data table and a "multiPhylo" object into a list to be used by the mulTree function

* mulTree: run MCMCglmm on multiple trees

* read.mulTree: reads MCMC objects from mulTree function

* summary.mulTree: summarise "mulTree" data

* plot.mulTree: plots the "mulTree" data


Installing mulTree
------------------
    install.packages("devtools")
    library(devtools)
    install_github("TGuillerme/mulTree")
    library(mulTree)

Authors
-------
[Thomas Guillerme](http://tguillerme.github.io) & [Kevin Healy](http://healyke.github.iol)
