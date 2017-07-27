local the=require "config"
local r=require "random"
local lst=require "lists"

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
return {create=create, same=same, update=update,cliffsDelta=cliffsDelta,
        bootstrap=bootstrap,tiles=tiles}
