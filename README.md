# mulTree
[![Build Status](https://travis-ci.org/TGuillerme/mulTree.svg?branch=release)](https://travis-ci.org/TGuillerme/mulTree)
[![codecov](https://codecov.io/gh/TGuillerme/mulTree/branch/master/graph/badge.svg)](https://codecov.io/gh/TGuillerme/mulTree)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.45097.svg)](https://doi.org/10.5281/zenodo.45097)

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
* 2017/06/12 - **v1.3**
  * Minor fix to `clean.data` to properly deal with data frames.
    
Previous patch notes and the *next version* ones can be seen [here](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

Authors
-------
[Thomas Guillerme](http://tguillerme.github.io) and [Kevin Healy](http://healyke.github.io)

Citation
-------
If you are using this package, please cite:

* Guillerme, T. & Healy, K. (**2014**). mulTree: a package for running MCMCglmm analysis on multiple trees. ZENODO. 10.5281/zenodo.12902

[BibTeX](https://zenodo.org/record/12902/export/hx), [EndNote](https://zenodo.org/record/12902/export/xe), [DataCite](https://zenodo.org/record/12902/export/dcite3), [RefWorks](https://zenodo.org/record/12902/export/xw)

Related packages
-------
<a href="https://github.com/healyke/SIDER"><img src="http://healyke.github.io/images/SIDER.png" height="35" widht="35"/></a> 
[`SIDER` R package](https://github.com/healyke/SIDER)

Used in
-------
* JS Gutiérrez, E Rakhimberdiev, T Piersma, DW Thieltges (**2017**) Migration and parasitism: habitat use, not migration distance, inﬂuences helminth species richness in Charadriiform birds. *Journal of Biogeography*. [DOI: 10.1111/jbi.12956](http://onlinelibrary.wiley.com/doi/10.1111/jbi.12956/full)
* G Zhang, Q Zhao, AP Møller, JJ Komdeur, X Lu (**2017**) Climate predicts which sex acts as helpers among cooperatively breeding bird species. *Biology Letters* 13:1. [DOI: 10.1098/rsbl.2016.0863](http://rsbl.royalsocietypublishing.org/content/13/1/20160863)
* K Healy, SBA Kelly, T Guillerme, R Inger, S Bearhop, AL Jackson (**2016**) Predicting trophic discrimination factor using Bayesian inference and phylogenetic, ecological and physiological data. DEsIR: Discrimination Estimation in R. *PeerJ Preprints* [https://peerj.com/preprints/1950.pdf](https://peerj.com/preprints/1950.pdf)
* K Healy (**2015**) Eusociality but not fossoriality drives longevity in small mammals. *Proceedings of the Royal Society B* 282, 20142917. [DOI: 10.1098/rspb.2014.2917](http://rspb.royalsocietypublishing.org/content/282/1806/20142917)
* K Healy, T Guillerme, S Finlay, A Kane, SBA Kelly, D McClean, DJ Kelly, I Donohue, AL Jackson, N Cooper (**2014**) Ecology and mode-of-life explain lifespan variation in birds and mammals. *Proceedings of the Royal Society B* 281, 20140298. [DOI:10.1098/rspb.2014.0298](http://rspb.royalsocietypublishing.org/content/281/1784/20140298?ijkey=1d6acd5357bbd6b611bd0d38b7cacd7a03d83dd1&keytype2=tf_ipsecsha)
