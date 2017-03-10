# mulTree
[![Build Status](https://travis-ci.org/TGuillerme/mulTree.svg?branch=release)](https://travis-ci.org/TGuillerme/mulTree)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.45097.svg)](https://doi.org/10.5281/zenodo.45097)

This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees.
This code has been used prior to this package release in [Healy et. al. (2014)](http://rspb.royalsocietypublishing.org/content/281/1784/20140298.full.pdf?ijkey=gPt28ElSAYBvRhZ&keytype=ref).
Please send me an [email](mailto:guillert@tcd.ie) or a pull request if you find/have any issue using this package.

<a href="https://figshare.com/articles/Guillerme_BESMacro2016_pdf/3478922"><img src="http://tguillerme.github.io/images/logo-FS.png" height="15" widht="15"/></a> 
Check out the [presentation](https://figshare.com/articles/Guillerme_BESMacro2016_pdf/3478922) of some aspects of the package.

## Installing mulTree
```r
if(!require(devtools)) install.packages("devtools")
library(devtools)
install_github("TGuillerme/mulTree", ref = "release")
library(mulTree)
```
The following installs the latest released version (see patch notes below). For the piping hot development version (not recommended), replace the `ref="release"` option by `ref="master"`. If you're using the `master` branch, see the latest developement in the [patch note](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

#### Warning note:
If you're using a PC and the package doesn't install correctly, it might be due to the fact that dependencies are not installed correctly. You can fix it by installing them manualy using the following:
```r
install.packages(c("MCMCglmm", "caper", "coda", "hdrcde", "snow", "ape"))
```

#### Vignettes
*  The package manual [here (in .Rnw)](https://github.com/TGuillerme/mulTree/blob/master/doc/mulTree-manual.Rnw) or [here (in .pdf)](https://github.com/TGuillerme/mulTree/blob/master/doc/mulTree-manual.pdf).
*  An additional example of running simple phylogenetic models is [here](https://github.com/TGuillerme/mulTree/blob/master/doc/Vanilla flavoured phylogenetic analyses.Rmd).

##### Patch notes (latest version)
* 2017/01/09 - v1.2.5
  * Added minor sanitising function to `mulTree` the formula now has to match the data set column names.
  * Fixed a bug with the `parallel` option in `mulTree`: only one cluster is now generated at the start of the function rather than one at each iteration.
  * Fixed a minor bug with `as.mulTree`: the random terms formula's environment is not anymore exported by the function when set up by default.

Previous patch notes and the *next version* ones can be seen [here](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

Authors
-------
[Thomas Guillerme](http://tguillerme.github.io) and [Kevin Healy](http://healyke.github.io)

Citation
-------
If you are using this package, please cite:

* Guillerme, T. & Healy, K. (**2014**). mulTree: a package for running MCMCglmm analysis on multiple trees. ZENODO. 10.5281/zenodo.12902

[BibTeX](https://zenodo.org/record/12902/export/hx), [EndNote](https://zenodo.org/record/12902/export/xe), [DataCite](https://zenodo.org/record/12902/export/dcite3), [RefWorks](https://zenodo.org/record/12902/export/xw)

Used in
-------
* Zhang G., Zhao Q., Møller A.P., J. Komdeur J., Lu X. (**2017**) Climate predicts which sex acts as helpers among cooperatively breeding bird species. *Biology Letters* 13:1. [DOI: 10.1098/rsbl.2016.0863](http://rsbl.royalsocietypublishing.org/content/13/1/20160863)
* Healy, K. (**2015**) Eusociality but not fossoriality drives longevity in small mammals. *Proceedings of the Royal Society B* 282, 20142917. [DOI: 10.1098/rspb.2014.2917](http://rspb.royalsocietypublishing.org/content/282/1806/20142917)
* Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (**2014**) Ecology and mode-of-life explain lifespan variation in birds and mammals. *Proceedings of the Royal Society B* 281, 20140298. [DOI:10.1098/rspb.2014.0298](http://rspb.royalsocietypublishing.org/content/281/1784/20140298?ijkey=1d6acd5357bbd6b611bd0d38b7cacd7a03d83dd1&keytype2=tf_ipsecsha)
