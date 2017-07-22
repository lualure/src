-- # watch : utilities

require "show"
local the=require "config"
local num=require "num"
------------------------------------------------------
local function create(n)  return {
  reportEvery = n,
  m           = 0,
  stats       = num.create(),
  all         = {}
} end
------------------------------------------------------
local function report(i,x) 
  print{n=i.stats.n, mu=i.stats.mu, sd=i.stats.sd} end
------------------------------------------------------
local function update(i,x) 
  i.m = i.m + 1
  num.update(i.stats,x)
  if i.m % i.reportEvery == 0 then
    i.all[#i.all + 1] = i.stats
    report(i)
    i.stats = num.create() end
  return i end
------------------------------------------------------
local function updates(lst,f,i)
  i = i or create()
  f = f or function (z) return z end
  for _,one in pairs(lst) do
    update(i, f(one)) end 
  return i end
------------------------------------------------------
return {create=create, update=update,updates=updates, report=report}
	
