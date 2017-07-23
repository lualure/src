-- # sdtreeok : unit tests for sdtree

require "show"
local the=require "config"
	
local o=require "tests"	
local r=require "random"
local tbl=require "tbl"
local tree=require "sdtree"
local lst=require "lists"
local row=require "row"
 
local function _test0(f,y)
  defaults()
  the.tree.min=10
  y = y or "goal1"
  f = f or "/data/auto.csv"
  print(f,y)
  local t1=  tbl.create( the.here .. f)
  print(f, #t1.rows)
  --end
  local t2 = tbl.discretize(t1,y)
  for _,head in pairs(t2.x.cols) do
   if head.bins then
   print(#head.bins,head.txt) end end
  local tr=tree.grow(t2,y)
  print(tr)
  tree.show(tr)
  print(t2.spec)
  --doms={}
  --for _,r in pairs(t1.rows) do
    --doms[r.id] = row.dominate(r,t1) end
  --print(t2.spec)
  --print(t2.rows[1].cells)
  --for _,r in pairs(tree.leaf(tr,t2.rows[1].cells)._t.rows) do
    --print('#',r.id,doms[r.id],r.cells) end

end

local function _test1() _test0(nil,"dom") end
local function _test2() _test0("/data/xomo_all_short.csv","goal1") end
local function _test3() _test0("/data/POM3A_short.csv") end

r.seed(1)
_test1()
_test2()
