Patch notes
----
* 2016/08/10 - v1.2.4
  * Fixed a bug in the convergence test where the convergence was not ran on the VCV matrix.
  * Models memory management is now safer and is done only out of R environment leading to minor speed improvements in `mulTree` function.
  * Some errors are now more verbose in `mulTree` and `summary.mulTree`.
* 2016/07/06 - v1.2.3
  * External functions are now properly imported via the `NAMESPACE`.
  * New phylogenetic analysis markdown vignette!
* 2016/02/19 - v1.2.2
  * major bug fix in `mulTree` where models saved out of `R` environment where accumulating data from former models (now fixed: each model saved out of the `R` environment contains only data for the target model).
* 2016/01/25 - v1.2.1
  * minor bug fix in `summary.mulTree` that can now deal with multiple hdr for each probabilities.
  * minor bug fix in `plot.mulTree` with the number of terms used
* 2016/01/21 - **v1.2**
  * complete new architectural structure!
  * all the functions are now unit tested!
  * all manuals are now written in Roxygen2 format!
  * many functions arguments names have been modified, please check individual functions manual.
  * `rTreeBind` is renamed to `tree.bind`.
  * In `as.mulTree`, the argument `species` is now `taxa`.
  * `mulTree` output: when output chain name already exists in current directory, the function now asks if user wants to overwrite the existing files.
  * In `read.mulTree`, the argument `mulTree.mcmc` is now `mulTree.chain`.
  * In `summary.mulTree`, the argument `mulTree.mcmc` is now `mulTree.results` and the argument `CI` is now `prob`.
  * `summary.mulTree` now outputs a `c("matrix", "mulTree")` class object.
  * In `plot.mulTree`, the argument `mulTree.mcmc` must now be an object returned from `summary.mulTree`.
* 2015/11/05 - v1.1.2
  * fixed bug with `clean.data` function
  * added the `extract` option to `read.mulTree` to extract specific elements of each models.
  * minor update on `as.mulTree`: can now intake single `phylo` objects.
* 2015/10/02 - v1.1.1
  * `summary.mulTree` and `plot.mulTree` have now an option whether to use `hdrcde::hdr` or not.
* 2015/08/17 - **v1.1.0**
  * `mulTree` can now be run in parallel!
* 2015/07/25 - v1.0.6
  * `plot.mulTree` has several more graphical options (see `?plot.mulTree`).
* 2015/07/08 - v1.0.5
  * `clean.data` now properly cleans data.frames with multiple specimens entries.
* 2015/07/01 - v1.0.4
  * improved formula management for `as.mulTree` and `mulTree`.
* 2015/06/03 - v1.0.3
  * `as.mulTree` now deals properly with same taxa entries.
  * updated examples for `as.mulTree` and `mulTree` on how to use specimen as a random term.
* 2015/05/17 - v1.0.2
  * Fixed bug in `as.mulTree` function with the random terms management.
* 2014/12/19 - v1.0.1
  * NEW: `clean.data` function allows to match data and multiple trees and drop the non-shared taxa.
  * `as.mulTree` function now allows multiple specimens for any taxa and allows the user to fix the random terms to be passed to the `mulTree` function.


Version in bold have a [release back-up](https://github.com/TGuillerme/mulTree/releases).
