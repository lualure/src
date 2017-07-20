-- # bpo : utilities

require "show"
local the=require "config"
local lst=require "lists"
local tbl=require "tbl"
local tree=require "sdtree"

local function someRest(n,all)
  local some,rest={},{}
  all = lst.shuffle(all)
  for j=1,#all do
    local what = j<=n and some or rest
    what[#what + 1] = all[j] end
  return some,rest
end
local function worker(gen,my,t1, rest)
  print('00000')
  local t2=tbl.discretize(t1)  
  local tr=tree.grow(t2)
  print("]]]]] ",tr._t.rows[1])
  tree.show(tr)
  local cache = {}
  for j=1,50 do
    local leaf= tree.leaf(tr,rest[j].cells,t2.bins)
    lst.push(cache,{leaf.stats.mu,j}) end
  table.sort(cache,
                  function (x,y) return x[1]<y[1] end)
  print(cache)
  print(rest[1].dom)
  -- computer error!!! XXXX
  --print("bins ",t1.bins)
  --print("nrows ",#t1.rows)
  --local root = S.grow(t1)
  --S.show(root)
end
--------------------------------------------
local function main(n,my,t)
  local some,rest = someRest(my.pop0,t.rows)
  --local t1=T.discretize(t)
  worker(n, my, tbl.copy(t,some),rest) end
--------------------------------------------
return function (t)
  main(10,the.bpo,t)
end

