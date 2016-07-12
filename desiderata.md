# To do list
* Add the shuffle-tree algorithm to MCMCglmm
* Allow different functions to be used for the tree-by-tree algorithm (`MCMCglmm`, `pgls`, `pic`)

### Get a function for measuring the posterior phylo signal from individual models.
`lambda <- model$VCV[, "phylo"] / (model$VCV[, "phylo"] + model$VCV[, "units"])`

# Patch 1.3 to do list
* Create an S3 class for `mulTree` objects
* Add S3 methods for `mulTree` objects
	* `print`
	* `plot`
	* `summary`

# Backtrack compatibilities

## `as.mulTree`

`as.mulTree` function is now called `setMulTreeData` but the list of arguments and arguments names are conserved.

## `clean.data`

`clean.data` function is now called `cleanData` but the list of arguments and arguments names are conserved.

## `mulTree`

`mulTree` arguments are modified:
	* **new**: `method`: which can be `MCMCglmm`, `pgls` or `pic`
	* **new**: `algorithm`: which can be `tbt` or `shuffle`
	* **removed**: `parameters`, `chains`, `priors`, `convergence`, `ESS` that are now input under `methods.args`
	* **new**" `methods.args`: which is an input list of arguments to be passed to the method
	
## `read.mulTree`

`read.mulTree` function is now called `readMulTree` but the list of arguments and arguments names are conserved.

## `tree.bind`

`tree.bind` function is now called `treeBind` but the list of arguments and arguments names are conserved.
