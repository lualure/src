local the=require "config"
----------------------------------------------------
local function create()
    return {n=0,mu=0,m2=0,sd=0,hi=-1e32,lo=1e32,w=1} end
----------------------------------------------------
local function update(i,x)
  if x ~= the.ignore then 
    i.n = i.n + 1
    if x < i.lo then i.lo = x end
    if x > i.hi then i.hi = x end
    local delta = x - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (x - i.mu) 
    if i.n > 1 then 
      i.sd = (i.m2 / (i.n - 1))^0.5 end end 
  return i end
----------------------------------------------------
local function updates(lst,f,i)
  i = i or create()
  f = f or function (z) return z end
  for _,one in pairs(lst) do
    update(i, f(one)) end 
  return i end
----------------------------------------------------
local function distance(i,j,k) 
  if j == the.ignore and k == the.ignore then
    return 0,0 
  elseif  j == the.ignore then
    k = norm(i,k)
    j =  k < 0.5 and 1 or 0
  elseif k == the.ignore then
    j = norm(i,j)
    k = j < 0.5 and 1 or 0
  else
    j,k = norm(i,j), norm(i,k)
  end
  return math.abs(j-k)^2,1
end
----------------------------------------------------
local function discretize(i,x) 
  if x==the.ignore then return x end
  if not i.bins    then return x end
  for _,b in pairs(i.bins) do
    r = b.label
    if x<=b.most then break end end
  return r end

----------------------------------------------------
local function spread(i) return i.sd end
----------------------------------------------------
local function norm(i,x)
  if x==the.ignore then return x end
  return (x - i.lo) / (i.hi - i.lo + 1e-32) end
----------------------------------------------------
local function ttest1(df,first,last,crit) 
  print{c3=crit[3],first=first, last=last}
  if df < first  then
    return crit[first] end
  local n1 = first
  while n1 < last do
    local n2=n1*2
    if df >= n1 and df <= n2 then
      local old,new = crit[n1],crit[n2]
      print(">>",df,n1,n2,old,new)
      return old + (new-old) * (df-n1)/(n2-n1) end 
    n1=n2 end
  return crit[last] end
----------------------------------------------------
local  function ttest(i,j) 
  -- debugged using https://goo.gl/CRl1Bz
  local t  = (i.mu - j.mu) / 
              math.sqrt(math.max(10^-64, i.sd^2/i.n + j.sd^2/j.n ))
  local a  = i.sd^2/i.n
  local b  = j.sd^2/j.n
  local df = (a + b)^2 / (10^-64 + a^2/(i.n-1) + b^2/(j.n - 1))
  local c  = ttest1(math.floor( df + 0.5 ), 
                    the.num.first,
                    the.num.last,
                    the.num.criticals[the.num.conf])
  print("tc> ",t,c)
  return math.abs(t) > c end
----------------------------------------------------
local function hedges(i,j)
  -- from https://goo.gl/w62iIL
  local nom   = (i.n - 1)*i.sd^2 + (j.n - 1)*j.sd^2
  local denom = (i.n - 1)        + (j.n - 1)
  local sp    = math.sqrt( nom / denom )
  local g     = math.abs(i.mu - j.mu) / sp  
  local c     = 1 - 3.0 / (4*(i.n + j.n - 2) - 1) -- handle small samples
  return g * c > the.num.small
end
----------------------------------------------------
local function same(i,j)
  return not (hedges(i,j) and ttest(i,j)) end
----------------------------------------------------
return {create=create, same=same, update=update, updates=updates,norm=norm,
        spread=function (i) return i.sd end}
