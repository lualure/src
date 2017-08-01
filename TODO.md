# Patches

Make all my module namees upper case.

Run all my *ok.lua* files, find dead code.

# LEarners

### Clustering

KD trees from [here](http://scipy-cookbook.readthedocs.io/items/KDTree_example.html)

Using SWAY from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L1100,L1135)

## Learners

KNN, NB from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L917,L955)

TO test KNN, for ech leaf instances, find its nearest neighbor. It should come back to itself.

# Coding standards

all files use `require "show"` which changes the default version of `print` and `tostring`.

Indents = 2 spaces (no tabs).

The file `X.lua` has demo code in `Xok.lua`.

All files in the directory.

All data in "/data" udnernearth some path name mentioned on i`os.getenv("Lure")`.`

Add documents to enable `locco` doucumentation.

- No file called `index.lua` (messes up my documentation system)
- Html written to lib/docs
- Your `.gitignore` should ignore `docs` folder.

Modlule-based polymorphism

- Modules usually have `create` `udpate` `updates`
- Mdoule names are UPPER CASE
- Most functions and variables are local
- Modules end by returnign a table of functions

Join all lines that are only  `end`.

Seperate functions with 

     function love()
       asds()
       if asdas() then
         return 1 end end
     ________
     function fred()
       asds()
       asdas()
       return 1 end


No use of meta tables (that way, madness lies).

No OO tricks


