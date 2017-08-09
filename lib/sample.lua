
-- ## Keeping a Sample of All
-- 
-- _tim@menzies.us_   
-- _August'17_   
--

local the=require "config"
local R=require "random"
local LST=require "lists"
local TILES=require "tiles"
local SK=require "sk"

------------------------------------
-- ### Creation
-- Create a watcher that will keep some subset of the watched data.

local function create(  most) return {
  _all={},
  n=0,
  most=most or the.sample.most} end
-----------------------------
-- ### Update
-- Update a watcher `i` with one value `x`.
-- If the watcher's cache is not filled, then keep `x`.
-- Otherwise, at a probably determined bu the number of
-- items seen so far, keep `x`

local function update(i,x) 
  if x ~= the.ignore then
    i.n = i.n+1
    if #i._all < i.most then
      i._all[#i._all+1] = x
    elseif R.r() < #i._all/i.n then
      i._all [ math.floor(1 + R.r()*#i._all) ] = x
    end end
  return x end
---------------------------------------------------
-- ### Handy short cut

local function watch()
  local i = create()
  return i, function (x) return update(i,x) end end
----------------------------
-- ### Updates
-- Update a watcher `i` with many values from `t`.
-- Optionally:
--
-- - filter every value in `t` through some function `f`. 
-- - If an filter every value in `t` through some function `f`. 
-- - If an `all` value is supplied, the update `all`. Else
--   return a new watcher.

local function updates(t,f,i)
  i = i or create()
  f = f or function (z) return z end
  for _,one in pairs(t) do
    update(i, f(one)) end 
  return i end
------------------------------
-- dont think this is used. delete?

local function xadds(samples)
  out=create()
  for _,sample in pairs(samples) do
    for _,v in pairs(sample._all) do
      update(out,v)
    end end
  return v end
-------------------------------------------------------------------
-- ### Effect size test (non-parametric)
-- Count how often lst2 has smaller or bigger numbers than items in lst1.
-- For the sake of effeciency, `lst2` is sorted and then explored using
-- a binary chop.

local function cliffsDelta(lst1,lst2)
  table.sort(lst2)
  local lt,gt,max=0,0,#lst2
  for _,one in pairs(lst1) do
    local pos0 = LST.bsearch(lst2,one)
    local pos = pos0
    while pos < max and lst2[pos] == lst2[pos+1] do pos = pos + 1 end
    gt = gt + max - pos
    local pos = pos0
    while pos > 1   and lst2[pos] == lst2[pos-1] do pos = pos - 1 end
    lt = lt + pos end
  return math.abs(gt - lt) / (#lst1 * #lst2) > the.sample.cliffsDelta end

-------------------------------------------------------------------
-- ### Statistical significance test (non-parametric)
-- The bootstrap hypothesis test from 220 to 223 of Efron's book 
-- 'An introduction to the boostrap'.

local function bootstrap(y0,z0)
     local function sampleWithReplacement(lst)
       local function n()   return math.floor(R.r() * #lst) + 1 end
       local function one() return lst[n()] end
       local out={}
       for i=1,#lst do out[i] = one() end
       return out 
     end
     local function delta(y,z)
       return (y.mu - z.mu) / (10^-64 + (y.sd/y.n + z.sd/z.n)^0.5) 
     end
     local function updates(i,lst)
       for j=1,#lst do
         local x = lst[j]
         i.all[#i.all + 1] = x
         i.n  = i.n + 1
         local delta = x - i.mu
         i.mu = i.mu + delta / i.n
         i.m2 = i.m2 + delta * (x - i.mu)
         if i.n > 1 then
           i.sd = (i.m2 / (i.n - 1))^0.5 end end
       return i 
     end
     local function create(lst)
       return updates({sum=0, n=0,mu=0, all={},m2=0,sd=0}, lst) 
     end
     local function add(i,j)
       return updates( LST.copy(i), j) 
     end
  local y, z = create(y0), create(z0)
  local x    = add(y,z)
  local tobs = delta(y,z)
  local yhat, zhat = {}, {}
  for i=1,#y.all do yhat[i] = y.all[i] - y.mu + x.mu end
  for i=1,#z.all do zhat[i] = z.all[i] - z.mu + x.mu end
  local bigger = 0
  for _ = 1,the.sample.b do
    if delta(create(sampleWithReplacement(yhat)),
             create(sampleWithReplacement(zhat))) > tobs then
      bigger = bigger + 1 end end
  return bigger / the.sample.b > the.num.conf/100 end
-----------------------------------------------------------
-- ### Statistical difference
-- Two populations are statistically similar if they differ by less
-- than a trivially small amount; and if they are statistically significantly different.

local function same(i,j) 
  return not(cliffsDelta(i,j) and bootstrap(i,j)) end
-----------------------------------------------------------
-- ### Rank a set of `samples`
-- Sort a list of _n_ `samples` on their median value
-- then assignssome number 1 &lt; _n_ to each. Note that any
-- adjacent samples that are statisticall the same will
-- get the same rank. Rank out a report of its conclusions.
--
-- Most of this code is trivial bookkeeping. The real worker here
-- is the [`SK` function](sk). Everything else is collecting the data
-- required to print out the results on a similiar scale.

local function rank(samples,epsilon,ranker) 
  local function nth(t,n) 
    if n<1       then n=1       end
    if n>#t._all then n=#t._all end
    return t._all[  math.floor(#t._all*n) ] end
  local function mid(t)   return nth(t,0.5) end
  local function iqr(t)   return nth(t,0.75) - nth(t,0.25) end
  local fmt =  string.format("%%2s %s %s %s %%s\n",
                             the.sample.fmtstr,
                             the.sample.fmtnum,
                             the.sample.fmtnum)
  local lo,hi= 10^64, -10^64
  for _,sample in pairs(samples) do
    for _,v in pairs(sample._all) do
      lo = math.min(lo, v)
      hi = math.max(hi, v) end
    table.sort(sample._all)
  end 
  table.sort(samples, function(a,b) return 
             mid(a) < mid(b) end )
  SK(samples,epsilon, 
     ranker or function(i,j) return 
               same(i._all,j._all) end)
  for _,sample in pairs(samples) do
    local how=TILES.how(sample._all)
    how.lo = lo
    how.hi = hi
    how.fmt = the.sample.fmtnum
    io.write(string.format(fmt, sample.rank, sample.txt or "", 
             mid(sample), iqr(sample),
             TILES.show(sample._all,how))) end  end

-----------------------------------------------
-- External  Interface

return {create=create, same=same, update=update,updates=updates,cliffsDelta=cliffsDelta,
        bootstrap=bootstrap,rank=rank}
