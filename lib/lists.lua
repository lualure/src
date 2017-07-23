-- ## lists: "list" routines for tables

local r=require "random"

----------------------------------
-- ### Membership

local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end

----------------------------------
-- ### Positions


-- Return First item in a table
local function first(x)  return x[#x] end
  -- Return last item in a table
local function last(x)  return x[#x] end
-- Push to end 
local function push(t,x)
 t[#t+1] = x
 return x end
-- Randomly change an items position
local function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * r.r() + 0.5)
    t[i],t[j] = t[j], t[i] 
  end
  return t end
-- Return any item in a list
local function any(t)
  return t[ math.floor((#t-1) * r.r() + 0.5) ]
end
-- Sorting
local function sort(t,f)
  f=f or function (x,y) return x < y end
  table.sort(t,f)
  return t end
----------------
local function firsts(x,y)
  print("")
  print{x=x}
  print{y=y}
  return first(x) < first(y) end
local function lasts(x,y)
  return last(x) < last(y) end
local function without(t,n)
  out={}
  for j,x in pairs(t) do
    if j ~= n then
      push(out,x) end end
  return out
end
-----------------------------------
-- ### Mapping

-- Basic map over items, no return
local function map(t,f)
  if t then
    for i,v in pairs(t) do f(v) end end end

-- Basic maps over items, with some working memory `w`. 
local function map2(t,w,f)
  if t then
    for _,v in pairs(t) do f(w,v) end
  end
  return w end

-- Return the results of mapping a function over a table
local function collect(t,f)
  local out={}
  if t then
    for i,v in pairs(t) do out[i] = f(v) end end
  return out end

-- printing
local function maprint(t, first, last)
  first = first or #t
  for j=1,first do print(j,t[j]) end
  if last then
    print("...")
    for j=#t+last, #t do print(j,t[j]) end end end
-----------------------------------
-- ### Copying (and saming)

-- The identity function
local function same(x) return x end
-- Copy top-level items 
local function shallowCopy(t) return collect(t,same) end
-- Recursive copy of contents
local function copy(t)  --recursive       
  return type(t) ~= 'table' and t or collect(t,copy) end

-------------------------------------------------------
-- ### Public interface

return { maprint=maprint,sort=sort,
         without=without, firsts=firsts,lasts=lasts,first=first, last=last,same=same,copy=copy,
         shallowCopy=shallowCopy, member=member,map=map, 
         push=push,map2=map2, collect=collect,shuffle=shuffle}
