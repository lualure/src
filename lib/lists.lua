local r=require "random"
-------------------------------------------------------
local function first(x) return x[1]  end
local function last(x)  return x[#x] end
-------------------------------------------------------
local function same(x) 
  return x end

local function shallowCopy(t) 
  return map(t,same) end

local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end
-------------------------------------------------------
local function map(t,f)
  if t then
    for i,v in pairs(t) do f(v) end end end

local function map2(t,i,f)
  if t then
    for _,v in pairs(t) do f(i,v) end
  end
  return i end

local function collect(t,f)
  local out={}
  if t then
    for i,v in pairs(t) do out[i] = f(v) end end
  return out end

local function copy(t)  --recursive       
  return type(t) ~= 'table' and t or collect(t,copy) end

-------------------------------------------------------
local function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * r.r() + 0.5)
    t[i],t[j] = t[j], t[i] 
  end
  return t end
-------------------------------------------------------
return { first=first, last=last,same=same,copy=copy,
         shallowCopy=shallowCopy, member=member,map=map, 
         map2=map2, collect=collect,shuffle=shuffle}
