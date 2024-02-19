# `mulTree`

[![R-CMD-check](https://github.com/TGuillerme/mulTree/workflows/R-CMD-check/badge.svg)](https://github.com/TGuillerme/mulTree/actions)
[![codecov](https://codecov.io/gh/TGuillerme/mulTree/branch/release/graph/badge.svg)](https://codecov.io/gh/TGuillerme/mulTree)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.12902.svg)](https://doi.org/10.5281/zenodo.12902)

This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees.
This code has been used prior to this package release in [Healy et. al. (2014)](http://rspb.royalsocietypublishing.org/content/281/1784/20140298.full.pdf?ijkey=gPt28ElSAYBvRhZ&keytype=ref).
Please send me an [email](mailto:guillert@tcd.ie) or a pull request if you find/have any issue using this package.

<a href="https://figshare.com/articles/Guillerme_BESMacro2016_pdf/3478922"><img src="http://tguillerme.github.io/images/logo-FS.png" height="15" widht="15"/></a> 
Check out the [presentation](https://figshare.com/articles/Guillerme_BESMacro2016_pdf/3478922) of some aspects of the package.

## Installing mulTree
```r
## Installing the package
if(!require(devtools)) install.packages("devtools")
library(devtools)
install_github("TGuillerme/mulTree", ref = "release")
library(mulTree)
```
The following installs the latest released version (see patch notes below). For the piping hot development version (not recommended), replace the `ref="release"` option by `ref="master"`. If you're using the `master` branch, see the latest developement in the [patch note](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

#### Warning note:
If you're using a PC and the package doesn't install correctly, it might be due to the fact that dependencies are not installed correctly. You can fix buy downloading `R`'s latest version and installing the missing packages manualy:
```r
## Install the missing packages
install.packages(c("MCMCglmm", "coda", "hdrcde", "snow", "ape", "corpcor", "curl"))
```

#### Vignettes
*  The package manual [here (in .Rnw)](https://github.com/TGuillerme/mulTree/blob/master/doc/mulTree-manual.Rnw) or [here (in .pdf)](https://github.com/TGuillerme/mulTree/blob/master/doc/mulTree-manual.pdf).
*  An additional example of running simple phylogenetic models is [here](https://github.com/TGuillerme/mulTree/blob/master/doc/Vanilla_flavoured_phylogenetic_analyses.Rmd).

##### Patch notes (latest version)
* 2020-04-12 - 1.3.7
  * Updated package to R version 3.6.3
  * Updated package to `ape` version 5.3
    
Previous patch notes and the *next version* ones can be seen [here](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

Authors
-------
[Thomas Guillerme](http://tguillerme.github.io) and [Kevin Healy](http://healyke.github.io)

## Contributors

[Eldar Rakhimberdiev](https://github.com/eldarrak), [Hugo Gruson](https://github.com/Bisaloo).

Citation
-------
If you are using this package, please cite (if the DOI is in there, even better!):

* Guillerme, T. & Healy, K. (**2014**). mulTree: a package for running MCMCglmm analysis on multiple trees. ZENODO. 10.5281/zenodo.12902
    ###### [BibTeX](https://zenodo.org/record/12902/export/hx), [CSL](https://zenodo.org/record/12902/export/csl), [DataCite](https://zenodo.org/record/12902/export/dcite3), [Dublin core](https://zenodo.org/record/12902/export/xd), [Mendeley](https://www.mendeley.com/import/?url=https://zenodo.org/record/12902), [more...](https://zenodo.org/record/12902/#.XTpLtlBS8W8)

Related packages
-------
<a href="https://github.com/healyke/SIDER"><img src="http://healyke.github.io/images/SIDER.png" height="35" widht="35"/></a> 
[`SIDER` R package](https://github.com/healyke/SIDER)

Used in
-------

Check out the papers that have cited `mulTree` since 2014 here (>50): <a href="https://scholar.google.co.uk/scholar?oi=bibs&hl=en&authuser=1&cites=4584971410532907380,16814263414399450021,3370364104915491810,3130126891097170937,17523532003181855881,4802874030689047623&as_sdt=5"><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> 
