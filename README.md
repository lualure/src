# dare


## Coding Style

Test-driven development (ish). Many files in `src/X.lua` are paired
with `tests/Xok.lua` with test, demo examples.

Written for teaching purposes. So many many small files, each with
specific functions.

Much encapsulation: most file functions are not in the public
interface.

Some (module-based) polymorphism. When the one verb applies to many
types, those verbs are in different files and differntiated by
public interface.

No inheritance, hence no object-oriented style. Too many ways to
do that in Lua. Too tempting to make base code on B.S. OO choices.

Much functional style. Lots of passing functions as arguments,
returning closures, etc etc.

DOCCO-stype documentation; i.e. comments in Markdown get redered
as html.

Github pages: the repo `github.com/lualure/info` stores html files
rendered from `github.com/lualure/src`.
