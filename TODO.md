# Patches

Make all my module names upper case.

Run all my *ok.lua* files, find dead code.

# Learners

### Clustering

KD trees from [here](http://scipy-cookbook.readthedocs.io/items/KDTree_example.html)

Using SWAY from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L1100,L1135)

## Learners

KNN, NB from [here](https://github.com/txt/ase16/blob/master/src/ase.py#L917,L955)

TO test KNN, for each leaf instances, find its nearest neighbor. It should come back to itself.

## Interfaces

Contrast set browser. Notes decides plans and monitors. Incrementally watches data.

# Coding standards (Lua only)

Indents = 2 spaces (no tabs).

The file `X.lua` has demo code in `Xok.lua`.
- Use `random.lua` not the built-in random number generator since mine ins platform independent
  (same numbers, different platforms-- better for writing unit tests).

All files in the same directory.

All data in "/data" underneath some path name mentioned on `os.getenv("Lure")`.`

All files use `require "show"` which changes the default version of `print` and `tostring`. Note
that to hide a field from being printed (e.g. since it is too long), make its first letter an underscore.

Join all lines that are only  `end`.

Add documents to enable `locco` documentation:

- No file called `index.lua` (messes up my documentation system)
- Html written to lib/docs
- Your `.gitignore` should ignore `docs` folder.

Separate functions with lines:

     function love()
       asds()
       if asdas() then
         return 1 end end
     --------------------------
     function fred()
       asds()
       asdas()
       return 1 end

Module-based polytheism

- Modules usually have `create` `update` `updates`
- Module names are UPPER CASE
- Most functions and variables are local
- Modules end by returning a table of functions

No use of meta tables (that way, madness lies).

No OO tricks (so many ways to do it... I found that I never stop experimenting).

Global configuration options stored in `config` and reset to defaults using `defaults()`
(which are stored in the global `the`). So
a standard experiment starts with

    require "show"
    local R=require "random"
    local O=require "tests"
    local XX=require "moduleURtesting"

    local function _test1()
      defaults() -- set the defaults
      the.this.that = 10 -- override a default
      do something with XX
      assert(something)
    end 

    local function _anotherTest()
      defaults() -- set the defaults
      the.this.that = 4321 -- override a default
      do something else with XXX
      assert(something)
    end 

    R.seed(1) -- set the random seed
    O.k{_test1,_anotherTest} -- counts assertion failures, continue even if 1 crashes
