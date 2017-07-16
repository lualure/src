-- # sdtreeok : unit tests for sdtree

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local tbl=require "tbl"
local tree=require "sdtree"
local lst=require "lists"
local row=require "row"
 
local function _test1()
  local t1=   tbl.create( the.here .. "/data/auto.csv")
  for _,r in pairs(t1.rows) do
    print(r.cells, row.dominate(r,t1)) end
  local t2 = tbl.discretize(t1)
  local tmp= tree.splits(t2)
  for j, one in pairs(tmp) do
    print(j,{pos=one.pos,sd=one._score,n=one.n}) end
  local tr=tree.grow(t2) 
  print(tr)
  tree.show(tr)
end

r.seed(1)
_test1()
