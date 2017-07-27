local the=require "config"
local r=require "random"
local lst=require "lists"
local num=require "num"
local tiles=require "tiles"

local function create(  most) return {
  _all={},
  n=0,
  most=most or the.sample.most} end
-----------------------------
local function update(i,x) 
  if x ~= the.ignore then
    i.n = i.n+1
    if #i._all < i.most then
      i._all[#i._all+1] = x
    elseif r.r() < #i._all/i.n then
      i._all [ math.floor(1 + r.r()*#i._all) ] = x
    end end
  return x end
------------------------------
local functions adds(samples)
  out=create()
  for _,sample in pairs(samples) do
    for _,v in pairs(sample._all) do
      update(out,v)
    end
  return v
  end
-------------------------------------------------------------------
local function cliffsDelta(lst1,lst2)
  table.sort(lst2)
  local lt,gt,max=0,0,#lst2
  for _,one in pairs(lst1) do
    local pos0 = lst.bsearch(lst2,one,f)
    local pos = pos0
    while pos < max and lst2[pos] == lst2[pos+1] do pos = pos + 1 end
    gt = gt + max - pos
    local pos = pos0
    while pos > 1   and lst2[pos] == lst2[pos-1] do pos = pos - 1 end
    lt = lt + pos end
  --print(lt,gt,#lst1,#lst2)
  return math.abs(gt - lt) / (#lst1 * #lst2) > the.sample.cliffsDelta end

function bootstrap(y0,z0)
  -- The bootstrap hypothesis test from
  -- 220 to 223 of Efron's book 'An
  -- introduction to the boostrap'.
  local function sampleWithReplacement(lst)
    local function n()   return math.floor(r.r() * #lst) + 1 end
    local function one() return lst[n()] end
    local out={}
    for i=1,#lst do out[i] = one() end
   -- print(out)
    return out end
  ----------------------------------------- 
  local function delta(y,z)
    return (y.mu - z.mu) / (10^-64 + (y.sd/y.n + z.sd/z.n)^0.5) end
  ----------------------------------------- 
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
    return i end
  ----------------------------------------- 
  local function create(lst)
    return updates({sum=0, n=0,mu=0, all={},m2=0,sd=0}, lst) end
  ----------------------------------------- 
  local function add(i,j)
    return updates( lst.copy(i), j) end
  ----------------------------------------- 
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
local function same(i,j) 
  return not(cliffsDelta(i,j) and bootstrap(i,j)) end
-----------------------------------------------------------
local function sk1(samples,epsilon)
  epsilon = epsilon + the.sample.epsilon
  --------------------------------------------
  local function mid(t) return t._all[ math.floor(#t._all/2) ] end
  --------------------------------------------
  local function create() return {
    _all={}, sum=0,n=0} end
  local function update(i,x) 
    i._all[#i._all+1]=x
    i.sum = i.sum + x
    i.n   = i.n + 1 
    i.mu  = i.sum/i.n end
  local function updates(i, b4)
    b4 = b4 or create()
    for j=1,#t do update(b4,t[j]) end end
  local function memo(here,stop,_memo,    b4,inc)
    if stop > here then inc=1 else inc=-1 end
    if here ~= stop then 
       b4=  lst.copy( memo(here+inc, stop, _memo)) end
    _memo[here] = updates(samples[here]._all,  b4)
    return _memo[here] end
  --------------------------------------------
  local function combine(lo,hi,all,bin,lvl)   
    local best = 0
    local lmemo,rmemo = {},{}
    memo(hi,lo, lmemo) -- summarize i+1 using i
    memo(lo,hi, rmemo) -- summarize i using i+1
    local cut, lbest, rbest
    for j=lo,hi-1 do
      local l = lmemo[j]
      local r = rmemo[j+1]
      if mid(l)*epsilon   < mid(r) then
        if not same(l,r) then
          local tmp= l.n/all.n*(l.mu - all.mu)^2 + 
                     r.n/all.n*(r.mu - all.mu^2)
          if tmp > best then
            cut   = j
            best  = tmp
            lbest = lst.copy(l)
            rbest = lst.copy(r) end end end end
    if cut then
      bin = combine(lo,   cut, lbest, bin, lvl+1) + 1
      bin = combine(cut+1, hi, rbest, bin, lvl+1)
    else
      for j=lo,hi do
        samples[j].rank = bin end end
    return bin end 
  --------------------------------------------
  table.sort(samples, function (x,y) return mid(x) < mid(y) end)
  combine(1,#samples, memo(1,#samples,{}),1,0)  
  return samples end

function sk(samples,epsilon) 
  local function nth(t,n) return t._all[ math.floor(#t._all*n) ] end
  local function mid(t)   return nth(t,0.5) end
  local function iqr(t)   return nth(t,0.75) - nth(t,0.25) end
  local lo,hi= 10^64, -10^64
  for _,sample in pairs(samples) do
    for _,v in pairs(sample._all) do
      lo = math.min(lo, v)
      hi = math.max(hi, v) end
    table.sort(sample._all)
    end 
  table.sort(samples, function(a,b) return 
                  mid(a) < mid(n) end )
  sk1(samples,epsilon)
  for _,sample in pairs(samples) do
    local how=tiles.how(sample._all)
    how.lo = lo
    how.hi = hi
    print(one.rank, mid(one), iqr(one),
          tile.show(sample._all,how)) end  end

return {create=create, same=same, update=update,cliffsDelta=cliffsDelta,
        bootstrap=bootstrap,tiles=tiles}
