# To do list
* Add the shuffle-tree algorithm to MCMCglmm
* Allow different functions to be used for the tree-by-tree algorithm (`MCMCglmm`, `pgls`, `pic`)

### Get a function for measuring the posterior phylo signal from individual models.
`lambda <- model$VCV[, "phylo"] / (model$VCV[, "phylo"] + model$VCV[, "units"])`

## One day...
Properly test the effect of using multiple trees.

### 1 - Simulated data
 * Simulate multiple trees with more or less variance
 * Simulate some continuous character
### 2 - Empirical data
 * Take the Longevity papers trees
 * Isolate a fixed number
### 3 - Run MCMCglmm on the empirical/simulated data
 * Run MCMCglmm on *n* trees (each time)
 * Run MCMCglmm with tree swapping on *n* trees (Luke's approach)
 * Run MCMCglmm on the *n* trees (`mulTree` approach)