# mulTree
[![Build Status](https://travis-ci.org/TGuillerme/mulTree.svg?branch=release)](https://travis-ci.org/TGuillerme/mulTree)
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.31742.svg)](http://dx.doi.org/10.5281/zenodo.31742)

A brand new version of `mulTree` is being developped on this branch with more functionalities and improved data management. However, because this branch is still being developped, it's **chuck full of bugs**.

## Installing mulTree
```r
if(!require(devtools)) install.packages("devtools")
library(devtools)
install_github("TGuillerme/mulTree", ref = "release")
library(mulTree)
```
or the master branch by using `ref = "master"`.

## Novelties
For back-up compatibilities issues or just for looking ahead what will the new functionalities be, please have a look at the [patch note](https://github.com/TGuillerme/mulTree/blob/master/patch_notes.md).

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
* Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (**2014**) Ecology and mode-of-life explain lifespan variation in birds and mammals. *Proceedings of the Royal Society B* 281, 20140298. [DOI:10.1098/rspb.2014.0298](http://rspb.royalsocietypublishing.org/content/281/1784/20140298?ijkey=1d6acd5357bbd6b611bd0d38b7cacd7a03d83dd1&keytype2=tf_ipsecsha)
* Healy, K. (**2015**) Eusociality but not fossoriality drives longevity in small mammals. *Proceedings of the Royal Society B* 282, 20142917. [DOI: 10.1098/rspb.2014.2917](http://rspb.royalsocietypublishing.org/content/282/1806/20142917)
