-- # bpo : utilities

require "show"
local the=require "config"
local lst=require "lists"
local tbl=require "tbl"
local tree=require "sdtree"
local row=require "row"
local num=require "num"

local function someRest(n,all)
  local some,rest={},{}
  all = lst.shuffle(all)
  for j=1,#all do
    local what = j<=n and some or rest
    what[#what + 1] = all[j] end
  return some,rest
end
local function surprises(t)
  local got,want,inc
  for _,r in pairs(t.rows) do
    if r.xpect then
      got = row.dominate(r,t)
      want = r.xpect
      r.xpect   = nil
      inc = want-got end end
  return {want=want,got=got,inc=inc/#t.rows}
end
local function worker(lives,t1,some, rest, history)
  local t2=tbl.discretize(t1)  
  local log = num.updates(t2.rows, 
                          function (_) return row.dominate(_,t2) end)
  local tr=tree.grow(t2)
  if lives < 1 or #rest==0 then
    print(history.mu, history.sd)
    return -- tree.show(tr)
  end
  local cache = {}
  for j=1,256 do
    local r = rest[j]
    local leaf= tree.leaf(tr,r.cells,t2.bins)
    lst.push(cache,{leaf.stats.mu,
                    j,r}) end
  local cache = lst.sort(cache, lst.firsts)
  local best3 = lst.last(cache)
  local best = best3[3]
  best.xpect = best3[1]
  --print(#t2.rows,best)
  local doomed=best3[2]
  rest = lst.without(rest,doomed)
  lst.push(some,best3[3])
  local t3=tbl.copy(t1,some)
  num.update(history,
             (log.hi - row.dominate(lst.last(t3.rows),t3))/ (log.hi - log.lo))
  --print(lives,#t3.rows,surprises(t3))
  worker(lives-1,t3,some,rest,history)

  -- computer error!!! XXXX
  --print("bins ",t1.bins)
  --print("nrows ",#t1.rows)
  --local root = S.grow(t1)
  --S.show(root)
end
--------------------------------------------
local function main(lives,t)
  local some,rest = someRest(the.bpo.pop0,t.rows)
  --local t1=T.discretize(t)
  local t0=tbl.copy(t,some)
  worker(lives, t0,some,rest,num.create()) end
--------------------------------------------
return function (t)
  main(32,t)
end

