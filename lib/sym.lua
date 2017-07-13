local the=require "config"
------------------------------------------------------
local function create()
  return {n=0, counts={}, most=0,mode=nil,_ent=nil } end
------------------------------------------------------
local function update(i,x)
  if x ~= the.ignore then
    i._ent = nil 
    i.n = i.n + 1
    local seen = i.counts[x]
    seen = seen and seen+1 or 1
    i.counts[x] = seen 
    if seen > i.most then
      i.most, i.mode = seen,x end end end
------------------------------------------------------
local function updates(lst,f,i)
  i = i or create()
  f = f or function (z) return z end
  for _,one in pairs(lst) do
    update(i, f(one)) end 
  return i end
------------------------------------------------------
local function ent(i)
  if i._ent == nil then 
    local e = 0
    for _,f in pairs(i.counts) do
      e = e - (f/i.n) * math.log((f/i.n), 2)
    end
    i._ent = e
  end
  return i._ent end
------------------------------------------------------
local function ke(i)
  local e,k = 0,0
  for _,f in pairs(i.counts) do
    e = e + (f/i.n) * math.log((f/i.n), 2)
    k = k + 1
  end
  e = -1*e
  return k,e,k*e end
------------------------------------------------------
return {create=create, update=update, updates=updates, ent=ent, spread=ent, ke=ke}
