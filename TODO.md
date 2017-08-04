# Patches

Make all my module names upper case.

Run all my *ok.lua* files, find dead code.

# evaluation

need abcd.py ported to LUA

need popt added

# Learners

### Clustering

KD trees from [here](http://scipy-cookbook.readthedocs.io/items/KDTree_example.html)

Using SWAY from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L1100,L1135)

## Learners

KNN, NB from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L917,L955)

TO test KNN, for each leaf instances, find its nearest neighbor. It should come back to itself.

WHICH

DE to tune KNN, NB

## Selection

- Range selection
    - Entropy-based, Gini-based, Log(odds ratio based)*
- Ranges selection
    - WHICH*
- Feature selection
    - Score columns by how many good range and ranges they contain
- Row selection
    - Clustering, sampleing per clustering
    - Score rows by how many good range/ranges they contain

* needs either binary classification  or dominace score, discretized into best X% and rest 100-X% 

## Incremental

According to a very obscure 2002 paper incremtnal hieratchical learning is 10,000 times faster than "redo from scratch"

- Divide data into a tree
- Define "alien" for each node
- Pass new data down the tree
- If not alien, do no updates
- for each node Keep seperate samples of 
      - the data that passes thru it to buidl the sub-tree
      - the new data that is alien
- If that sample grows to large, rebuild that subtree using the data+alien samples at that node
- repeat till end of time
- compare with building tree for all data , all at once
      - compare runtimes
      - comapre performance scores

## Interfaces

Contrast set browser. Notes decides plans and monitors. Incrementally watches data.

