# LURE

## Install

    git clone http://github.com/lualure/src src
    Here=$PWD/src 

## Usage

Here's my shell `lua` function. Note that it looks for
files either in `tests` or `lib`. Also, it calls the
code using `luajit`.

    lua() {
      f=$1
      shift
      for d in lib tests; do
        if [ -f "$Here/$d/$f" ]; then
          LUA_PATH="$Here/lib/?.lua;$Here/tests/?.lua;;" \
            $(which luajit) $Here/$d/$f "$*"
          return 0
        fi
      done
      echo "not found $f"
    }

For example, this call runs the unit tests for `lists.lua` found in `listsok.lua`.

    lua listsok.lua 

## Coding Style

- For speed reasons, this code uses `luajit` rather than just (slower) old `lua`.
- Test-driven development (ish). Many files in `src/X.lua` are paired
  with `tests/Xok.lua` with test, demo examples. So best to
  start this with
- So my environment uses the calling convention shown above.
- Written for teaching purposes. So many many small files, each with
  specific functions.
- Much encapsulation: nearly all my functions and variables are `local`.
     - Exception1: I define the global definition of `print` so it can display tables.
     - Exception2: there are others... not many... can't think of them right now.
- Some (module-based) polymorphism. When the one verb applies to many
  types, those verbs are in different files and differntiated by
  public interface.
- No inheritance, hence no object-oriented style. Too many ways to
  do that in Lua. Too tempting to make base code on B.S. OO choices.
- Much functional style. Lots of passing functions as arguments,
  returning closures, etc etc.
- Instead of using `self` , this code used `i`.
- DOCCO-stype documentation; i.e. comments in Markdown get rendered
  as html.
= Github pages: the repo `github.com/lualure/info` stores html files
  rendered from `github.com/lualure/lib`.
