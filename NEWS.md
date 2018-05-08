mulTree 1.3.4 (2018-05-08)
=========================

### NEW FEATURES

  * Increased test coverage for all functions.

### MINOR IMPROVEMENTS

  * Improved optional arguments handling for `mulTree` (following [Eldar Rakhimberdiev](https://github.com/eldarrak)'s contribution)

mulTree 1.3.3 (2018-03-14)
=========================

### MINOR IMPROVEMENTS

  * Converted `patch_notes.md` into `NEWS.md` (with the correct standard format).

### BUG FIXES

  * Minor bug fix: the trees in `data(lifespan)` are now all ultrametric.

mulTree 1.3.2 (2017/10/19)
=========================

### NEW FEATURES

  * Complex formula management in `mulTree` and `as.mulTree`.

### MINOR IMPROVEMENTS

  * Added `ask` option to `mulTree`, whether to ask to overwrite files or not.
  * Minor changes (internal) and code coverage increased for `SIDER` release.


mulTree 1.3.0 (2017-06-12)
=========================

### BUG FIXES

  * Minor fix to `clean.data` to properly deal with data frames.


mulTree 1.2.6 (2017/05/15)
=========================

### NEW FEATURES

  * Allows R-structure's standrad multi-response model in `as.mulTree` (e.g. `rand.terms  = ~taxa + specimen + us(trait):observation`).

### MINOR IMPROVEMENTS

  * Removed `caper` dependencies.
  * `coda::gelman.diag` in `mulTree` now only outputs a warning rather than a stop messag
  
### BUG FIXES

  * Minor fixes to code internal documentation.
  
  
mulTree 1.2.5 (2017/01/09)
=========================

### MINOR IMPROVEMENTS

  * Added minor sanitising function to `mulTree` the formula now has to match the data set column names.

### BUG FIXES

  * Fixed a bug with the `parallel` option in `mulTree`: only one cluster is now generated at the start of the function rather than one at each iteration.
  * Fixed a minor bug with `as.mulTree`: the random terms formula's environment is not anymore exported by the function when set up by default.

  
mulTree 1.2.4 (2016/08/10)
=========================

### MINOR IMPROVEMENTS

  * Models memory management is now safer and is done only out of R environment leading to minor speed improvements in `mulTree` function.
  * Some errors are now more verbose in `mulTree` and `summary.mulTree`.

### BUG FIXES
  * Fixed a bug in the convergence test where the convergence was not ran on the VCV matrix.
  * Fixed bug with `plot.mulTree` that didn't allow to plot more than 5 parameters.


mulTree 1.2.3 (2016/07/06)
=========================

### NEW FEATURES

  * New phylogenetic analysis markdown vignette!

### MINOR IMPROVEMENTS

  * External functions are now properly imported via the `NAMESPACE`.

mulTree 1.2.2 (2016/02/19)
=========================

### BUG FIXES
  * major bug fix in `mulTree` where models saved out of `R` environment where accumulating data from former models (now fixed: each model saved out of the `R` environment contains only data for the target model).

mulTree 1.2.1 (2016/01/25)
=========================

### BUG FIXES
  * minor bug fix in `summary.mulTree` that can now deal with multiple hdr for each probabilities.
  * minor bug fix in `plot.mulTree` with the number of terms used

mulTree 1.2.0 (2016/01/21)
=========================

### NEW FEATURES

  * complete new architectural structure!
  * all the functions are now unit tested!
  * all manuals are now written in Roxygen2 format!

### DEPRECATED AND DEFUNCT

  * many functions arguments names have been modified, please check individual functions manual.
  * `rTreeBind` is renamed to `tree.bind`.
  * In `as.mulTree`, the argument `species` is now `taxa`.
  * `mulTree` output: when output chain name already exists in current directory, the function now asks if user wants to overwrite the existing files.
  * In `read.mulTree`, the argument `mulTree.mcmc` is now `mulTree.chain`.
  * In `summary.mulTree`, the argument `mulTree.mcmc` is now `mulTree.results` and the argument `CI` is now `prob`.
  * `summary.mulTree` now outputs a `c("matrix", "mulTree")` class object.
  * In `plot.mulTree`, the argument `mulTree.mcmc` must now be an object returned from `summary.mulTree`.


mulTree 1.1.2 (2015/11/05)
=========================

### MINOR IMPROVMENTS

  * added the `extract` option to `read.mulTree` to extract specific elements of each models.
  * minor update on `as.mulTree`: can now intake single `phylo` objects.

### BUG FIXES

  * fixed bug with `clean.data` function


mulTree 1.1.1 (2015/10/02)
=========================

### NEW FEATURES

  * `summary.mulTree` and `plot.mulTree` have now an option whether to use `hdrcde::hdr` or not.


mulTree 1.1.0 (2015/08/17)
=========================

### NEW FEATURES

  * `mulTree` can now be run in parallel!


mulTree 1.0.6 (2015/07/25)
=========================

### NEW FEATURES

  * `plot.mulTree` has several more graphical options (see `?plot.mulTree`).


mulTree 1.0.5 (2015/07/08)
=========================

### BUG FIXES

  * `clean.data` now properly cleans data.frames with multiple specimens entries.


mulTree 1.0.4 (2015/07/01)
=========================

### MINOR IMPROVEMENTS

  * improved formula management for `as.mulTree` and `mulTree`.


mulTree 1.0.3 (2015/06/03)
=========================

### MINOR IMPROVEMENTS

  * `as.mulTree` now deals properly with same taxa entries.
  * updated examples for `as.mulTree` and `mulTree` on how to use specimen as a random term.


mulTree 1.0.2 (2015/05/17)
=========================

### BUG FIXES

  * Fixed bug in `as.mulTree` function with the random terms management.

mulTree 1.0.1 (2014/12/19)
=========================

### NEW FEATURES

  * NEW: `clean.data` function allows to match data and multiple trees and drop the non-shared taxa.
  * `as.mulTree` function now allows multiple specimens for any taxa and allows the user to fix the random terms to be passed to the `mulTree` function.


Version in bold have a [release back-up](https://github.com/TGuillerme/mulTree/releases).
