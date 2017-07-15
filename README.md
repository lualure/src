# LURE

<img align=right src="https://avatars6.githubusercontent.com/u/30064709?v=4&s=200">

## Operators for Software Science

Recently my graduate students came across Bayesian Parameter Optimization where instead of using Gaussian
Process Models (which have dimensionality limitations; e.g. 12 vars max), they used
Random Forests.  One of my students, Vivek Nair, tried doing BPO multi-objective optimization
with CART (one tree per  objective). [It worked very well](https://arxiv.org/pdf/1705.05018.pdf).

This code is my attempt to extend and simplify Vivek's system, written in LUA (LUA= SCHEME without brackets).
Why LUA? Cause odds are none of my students have ever coded in LUA  so I can set assignments like
"here is an executable specification, now port it to <yourFavLanguage>".

Lure:

- adds a _domination_ score to each row;
- builds a CART tree to minimize variance of the domination scores;
- builds that tree for, say, 20 examples, 
- uses that tree to guess, say, 128 more examples
- picks the (best,worst) guess from those examples,
- computes the tree error by comparing the guesses to actual
- add those (best,worst) guesses to the training set (which now has 22 examples)
- repeat, until error stabilizes.

So, in theory, that gives us:

- multi-objective optimization, 
- tiny memory footprints
- incremental learning,  
- active learning 
    - only need real scores on the initial pop and the next guesses
- succinct models 
    - tiny trees
- explanation
    - show the trees
- planning
    - using the [Krishna mutator](https://arxiv.org/pdf/1609.03614.pdf), 
      generate plans and monitors from the trees.
- data compression
    - only keep the intial pop and the learned examples
- data sharing
    - only share the compressed data
- data privacy
    - use the [Peters mutator](http://menzies.us/pdf/15lace2.pdf) on the shared data

Also, if ever new data shows up, this also gives us:

- anomaly detector 
    - if new examples fall to leaves in the current tree that are very distant,
  then you've not seen that example before)
- a way to learn when not to learn 
    - of the error rate remains low on newly arrived examples,
- a way to start learning again 
    - if the anomaly detector triggers 
    - if the error rate on new examples spikes, start the learner again

Like I say, in theory. As to what actually happens in practice, well, we shall see.

## Install

### Using LuaRocks

Currently not available.

### Using Github

Check out the repo, then create an environment
variable `Lure` to hold the repo's localtion.

    git clone http://github.com/lualure/src src
    Lure=$PWD/src 

Add the following function to your $HOME/.bashrc.
Note that this function looks for
files either in `tests` or `lib`. Also, it calls the
code using `luajit` (the faster version of `lua`).

    lua() {
      f=$1
      shift
      for d in lib tests; do
        if [ -f "$Lure/$d/$f" ]; then
          LUA_PATH="$Lure/lib/?.lua;$Lure/tests/?.lua;;" \
            $(which luajit) $Lure/$d/$f "$*"
          return 0
        fi
      done
      echo "not found $f"
    }

Make sure your source this code; e.g. logout then log
back in or (much faster):

    . ~/.bashrc

## Test

This call runs the unit tests for `lists.lua` found in `listsok.lua`.

    lua listsok.lua 

## Coding Style

Speed freak: 

- I uses `luajit` rather than just (slower) old `lua`.

Test-driven development (ish):

- Many files in `src/X.lua` have demos, tests in
  with `tests/Xok.lua` with test, demo examples. 

Written for teaching purposes:

- So many many small files, each with specific functions.

Functional programming rules:

- Much functional style. Lots of passing functions as arguments,
  returning closures, etc etc.

Encapsulation rules: 

- Nearly all my functions and variables are `local`.
- Exception1: I define the global definition of `print` so it can display tables.
- Exception2: there are others... not many... can't think of them right now.

Module-based polymorphism. 

- When the one verb applies to many
  types, those verbs are in different files and differntiated by
  public interface.
- For example, look at `create` and `update` in [num.lua](lib/num.lua) and [sym.lua](lib/sym.lua)

No inheritance, so no object-oriented style. 

- Too many ways to do that in Lua.
- Too tempting to make base code on B.S. OO choices.

Not `self` , but  `i`:

- When my module functions are passing round a table of data,
  that table is called `i`, not `self`.

Literate programming:

- DOCCO-stype documentation; i.e. comments in Markdown get rendered
  as html.
= These are rendered and written to `github.com/lualure/info` 
  which, in turn, is rendered using Github pages
   at [https://lualure.github.io/info/](https://lualure.github.io/info/).
