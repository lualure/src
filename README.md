# LURE

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
  which, in turn, is rendered using tGithub pages
   at `github.com/lualure/lib`.
