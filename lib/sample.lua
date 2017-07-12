local the=require "config"
local r=require "random"

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
return {create=create, update=update}
