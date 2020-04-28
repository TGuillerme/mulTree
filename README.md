# `mulTree`

[![Build Status](https://travis-ci.org/TGuillerme/mulTree.svg?branch=release)](https://travis-ci.org/TGuillerme/mulTree)
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
* 2018/05/08 - 1.3.4
  * Increased test coverage for all functions.
  * Improved optional arguments handling for `mulTree` (following [Eldar Rakhimberdiev](https://github.com/eldarrak)'s contribution)
  * Converted `patch_notes.md` into `NEWS.md` (with the correct standard format).
  * Minor bug fix: the trees in `data(lifespan)` are now all ultrametric.
  * Complex formula management in `mulTree` and `as.mulTree`.
  * Added `ask` option to `mulTree`, whether to ask to overwrite files or not.
  * Minor changes (internal) and code coverage increased for `SIDER` release.

    
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
Click on the google logo for citations details.
> 20 publications have cited `mulTree` since 2014 (4 per year). The average cites for papers using `mulTree` is 11.15 (the median is 4; calculated on the 07/11/2019).

<!-- cite style: vancouver reverse -->

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Examining+the+link+between+relaxed+predation+and+bird+coloration+on+islands&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
L Bliard, M Paquet, A Robert, P Dufour, JP Renoult, A Grégoire, PA Crochet, R Covas, C Doutrelant. (**2020**) Examining the link between relaxed predation and bird coloration on islands. *Biology Letters*. 2020 Apr 29;16(4):20200002. [DOI: 10.1098/rsbl.2020.0002](https://royalsocietypublishing.org/doi/full/10.1098/rsbl.2020.0002?af=R)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Co-expression+clustering+across+flower+development+identifies+modules+for+diverse+floral+forms+in+Achimenes+%28Gesneriaceae%29&btnG=="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
WR Roberts, EH Roalson. (**2020**) Co-expression clustering across flower development identifies modules for diverse floral forms in Achimenes (Gesneriaceae). *PeerJ*. 1:817221. [DOI: 10.7717/peerj.8778](https://doi.org/10.7717/peerj.8778)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Hummingbird+iridescence%3A+an+unsuspected+structural+diversity+influences+colouration+at+multiple+scales&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
H Gruson, M Elias, C Andraud, C Djediat, S Berthier, C Doutrelant, D Gomez. (**2019**) Hummingbird iridescence: an unsuspected structural diversity influences colouration at multiple scales. *bioRxiv*. 1:699744. [DOI: 10.1101/699744 ](https://www.biorxiv.org/content/10.1101/699744v1.full)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&as_ylo=2019&q=Unveiled+feather+microcosm%3A+feather+microbiota+of+passerine+birds+is+closely+associated+with+host+species+identity+and+bacteriocin-producing+bacteria&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
VG Javůrková, J Kreisinger, P Procházka, M Požgayová, K Ševčíková, V Brlík, P Adamík, P Heneberg, J Porkert. (**2019**) Unveiled feather microcosm: feather microbiota of passerine birds is closely associated with host species identity and bacteriocin-producing bacteria. *The ISME journal*. 13:2363–2376. [DOI: 10.1038/s41396-019-0438-4](https://www.nature.com/articles/s41396-019-0438-4)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Animal+life+history+is+shaped+by+the+pace+of+life+and+the+distribution+of+age-specific+mortality+and+reproduction&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
JA Nations, LR Heaney, TC Demos, AS Achmadi, KC Rowe, JA Esselstyn. (**2019**). A simple skeletal measurement effectively predicts climbing behaviour in a diverse clade of small mammals. *Biological Journal of the Linnean Society*. [DOI: 10.1093/biolinnean/blz085](https://academic.oup.com/biolinnean/advance-article/doi/10.1093/biolinnean/blz085/5533433)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Animal+life+history+is+shaped+by+the+pace+of+life+and+the+distribution+of+age-specific+mortality+and+reproduction&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
K Healy, THG Ezard, OR Jones, R Salguero-Gómez, YM Buckley. (**2019**). Animal life history is shaped by the pace of life and the distribution of age-specific mortality and reproduction. *Nature Ecology & Evolution*. [DOI: 10.1038/s41559-019-0938-7](https://www.nature.com/articles/s41559-019-0938-7)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Micro%E2%80%90and+macroparasite+species+richness+in+birds%3A+the+role+of+host+life+history+and+ecology&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
JS Gutiérrez, T Piersma, DW Thieltges (**2019**). Micro‐and macroparasite species richness in birds: the role of host life history and ecology. *Journal of Animal Ecology*. [DOI: 10.1111/1365-2656.12998](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2656.12998)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&as_ylo=2019&q=Weak+effects+of+geolocators+on+small+birds%3A+a+meta%E2%80%90analysis+controlled+for+phylogeny+and+publication+bias&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
V Brlík et al. (**2019**) Weak effects of geolocators on small birds: a meta‐analysis controlled for phylogeny and publication bias. *Journal of Animal Ecology*. [DOI: 10.1111/1365-2656.12962](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2656.12962)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&as_ylo=2019&q=Evolution+of+heterophil%2Flymphocyte+ratios+in+response+to+ecological+and+life%E2%80%90history+traits%3A+A+comparative+analysis+across+the+avian+tree+of+life&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
P Minias (**2019**) Evolution of heterophil/lymphocyte ratios in response to ecological and life‐history traits: A comparative analysis across the avian tree of life. *Journal of Animal Ecology*, 286(1894) 20181967. [DOI: 10.1111/1365-2656.12941](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2656.12941)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=The+effect+of+insularity+on+avian+growth+rates+and+implications+for+insular+body+size+evolution&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
EM Sandvig, T Coulson, SM Clegg (**2019**) The effect of insularity on avian growth rates and implications for insular body size evolution. *Proceedings of the Royal Society B*, 286(1894) 20181967. [DOI: 10.1098/rspb.2018.1967](https://royalsocietypublishing.org/doi/full/10.1098/rspb.2018.1967)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&as_ylo=2018&q=Avian+diet+and+foraging+ecology+constrain+foreign+egg+recognition+and+rejection&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
AB Luro, ME Hauber (**2018**) Avian diet and foraging ecology constrain foreign egg recognition and rejection. *bioRxiv*, 402941. [DOI: 10.1101/402941 ](https://www.biorxiv.org/content/early/2018/08/29/402941)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Mixing+models+and+stable+isotopes+as+tools+for+research++on+feeding+aquatic+organisms&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
CR Ferreira de Moraes, GG Henry-Silva (**2018**) Mixing models and stable isotopes as tools for research on feeding aquatic organisms. *Cienc. Rural* 48:7. [DOI: 10.1590/0103-8478cr20160101](http://www.scielo.br/scielo.php?script=sci_arttext&pid=S0103-84782018000700650&lng=en&nrm=iso&tlng=en)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Annual+chronotypes+functionally+link+life+histories+and+life+cycles+in+birds&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
J Karagicheva, E Rakhimberdiev, A Saveliev, T Piersma  (**2018**) Annual chronotypes functionally link life histories and life cycles in birds. *Funct Ecol.* 00:1–11. [DOI: 10.1111/1365-2435.13181](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2435.13181)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Multifactorial+processes+underlie+parallel+opsin+loss+in+neotropical+bats&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
A Sadier, K Davies, L Yohe, K Yun, P Donat, BP Hedrick, E Dumont, L Davalos, S Rossiter, KE Sears (**2018**) Multifactorial processes underlie parallelopsin loss in neotropical bats. *eLife* 7:e37412. [DOI: 10.7554/eLife.37412](https://elifesciences.org/articles/37412)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=2005&sciodt=0%2C5&cites=4584971410532907380&scipsc=&q=Allopreening+in+birds+is+associated+with+parental+cooperation+over+offspring+care+and+stable+pair+bonds+across+years&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
K Elspeth, TR Birkhead, JP Green (**2017**) Allopreening in birds is associated with parental cooperation over offspring care and stable pair bonds across years. *Behavioral Ecology* 28.4: 1142-1148. [DOI: 10.1093/beheco/arx078](https://academic.oup.com/beheco/article/28/4/1142/3865432)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Leukocyte+profiles+are+associated+with+longevity+and+survival%2C+but+not+migratory+effort%3A+A+comparative+analysis+of+shorebirds&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
P Minias, R Włodarczyk, W Meissner (**2017**) Leukocyte profiles are associated with longevity and survival, but not migratory effort: A comparative analysis of shorebirds. *Functional Ecology*. [DOI: 10.1111/1365-2435.12991](http://onlinelibrary.wiley.com/doi/10.1111/1365-2435.12991/full).

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Climate%2C+host+phylogeny+and+the+connectivity+of+host+communities+govern+regional+parasite+assembly&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a>
NJ Clark, SM Clegg, K Sam, W Goulding, B Koane, K Wells (**2017**) Climate, host phylogeny and the connectivity of host communities govern regional parasite assembly. *Diversity and Distributions*. [DOI: 10.1111/ddi.12661](http://onlinelibrary.wiley.com/wol1/doi/10.1111/ddi.12661/abstract).

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Migration+and+parasitism%3A+habitat+use%2C+not+migration+distance%2C+in%EF%AC%82uences+helminth+species+richness+in+Charadriiform+birds&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> 
JS Gutiérrez, E Rakhimberdiev, T Piersma, DW Thieltges (**2017**) Migration and parasitism: habitat use, not migration distance, inﬂuences helminth species richness in Charadriiform birds. *Journal of Biogeography*. [DOI: 10.1111/jbi.12956](http://onlinelibrary.wiley.com/doi/10.1111/jbi.12956/full)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Climate+predicts+which+sex+acts+as+helpers+among+cooperatively+breeding+bird+species&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> 
G Zhang, Q Zhao, AP Møller, JJ Komdeur, X Lu (**2017**) Climate predicts which sex acts as helpers among cooperatively breeding bird species. *Biology Letters* 13:1. [DOI: 10.1098/rsbl.2016.0863](http://rsbl.royalsocietypublishing.org/content/13/1/20160863)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&as_ylo=2017&q=SIDER%3A+an+R+package+for+predicting+trophic+discrimination+factors+of+consumers+based+on+their+ecology+and+phylogenetic+relatedness&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> 
K Healy, SBA Kelly, T Guillerme, R Inger, S Bearhop, AL Jackson (**2017**) SIDER: an R package for predicting trophic discrimination factors of consumers based on their ecology and phylogenetic relatedness. *Ecography* [DOI: 10.1111/ecog.03371](https://onlinelibrary.wiley.com/doi/abs/10.1111/ecog.03371)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Eusociality+but+not+fossoriality+drives+longevity+in+small+mammal&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> K Healy (**2015**) Eusociality but not fossoriality drives longevity in small mammals. *Proceedings of the Royal Society B* 282, 20142917. [DOI: 10.1098/rspb.2014.2917](http://rspb.royalsocietypublishing.org/content/282/1806/20142917)

* <a href="https://scholar.google.co.uk/scholar?hl=en&as_sdt=0%2C5&q=Ecology+and+mode-of-life+explain+lifespan+variation+in+birds+and+mammals&btnG="><img src="http://tguillerme.github.io/images/649298-64.png" height="15" widht="15"/></a> 
K Healy, T Guillerme, S Finlay, A Kane, SBA Kelly, D McClean, DJ Kelly, I Donohue, AL Jackson, N Cooper (**2014**) Ecology and mode-of-life explain lifespan variation in birds and mammals. *Proceedings of the Royal Society B* 281, 20140298. [DOI:10.1098/rspb.2014.0298](http://rspb.royalsocietypublishing.org/content/281/1784/20140298?ijkey=1d6acd5357bbd6b611bd0d38b7cacd7a03d83dd1&keytype2=tf_ipsecsha)
