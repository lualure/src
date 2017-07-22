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
return {create=create, update=update, updates=updates,norm=norm,
        spread=function (i) return i.sd end}
