require "show"
require "config"
local CON=require "contrasts"
local TREES=require "trees"
local TREE=require "sdtree"
local LST=require "lists"
local O=require "tests"


local function _con()
  defaults()
  the.tree.min=8
  local x=TREES.auto()
  TREE.show(x)
  local b=CON.branches(x)
  print("\n==================== Show branches \n\n")
  LST.maprint(b)
  print("\n==================== What to do: (plans= here to better) ")
  CON.plans(b)
  print("\n==================== What to fear: (monitors = here to worse) ")
  CON.monitors(b)
end

O.k{_con}
