# mulTree
Performs MCMCglmm on multiple phylogenetic trees

This is a under early developement new version of the `mulTree` package.
See details on the older version [here](https://github.com/TGuillerme/mulTree/tree/clunky-mulTree).

Please refer to the older versions for now by installing only the `release` version:
```r
if(!require(devtools)) install.packages("devtools")
install_github("TGuillerme/mulTree", ref = "release")
library(mulTree)
```
Or the old clunky developement version:
```r
if(!require(devtools)) install.packages("devtools")
install_github("TGuillerme/mulTree", ref = "clunky-mulTree")
library(mulTree)
```

## For facilitating the developement and instant testing, please use the following function:

```r
refresh.mulTree<-function(){
       library(devtools)
       setwd('~/Packaging/')
       install('mulTree')
       library(mulTree)
       cd("mulTree/")
       test()
       document()
}
```
