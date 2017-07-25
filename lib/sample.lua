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
-----------------------------
local function tiles(i,p)
  local p = p or 0.1
  table.sort(i._all)
  local q, out, max = 1, {},  #i._all
  while max*q*p < max do
    out[q] = i._all[ math.floor( max*q*p ) ]
    q      = q + 1 end
  return out end

-----------------------------
local function cliffsDelta(i,j)
  lst1=i._all
  lst2=j._all
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


local function same(i,j) 
  return not (cliffsDelta(i,j) and bootstrap(i,j)) end
-----------------------------
return {create=create, update=update,cliffsDelta=cliffsDelta,tiles=tiles}
