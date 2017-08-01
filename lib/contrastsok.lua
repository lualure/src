require "show"
require "config"
local CON=require "contrasts"
local TREES=require "trees"
local TREE=require "sdtree"
local LST=require "lists"


function _con()
  defaults()
  the.tree.min=4
  local x=TREES.auto()
  b=CON.branches(x)
  LST.maprint(b)
  TREE.show(x)
  print("\n====================What to do: ")
  CON.plans(b)
  print("\n====================What to fear: ")
  CON.monitors(b)
end

_con()
