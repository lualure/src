-- ## Helpful routines for tables

-- _tim@menzies.us_     
-- _August 2017_ 
--
local R=require "random"

----------------------------------
-- ### Membership

local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false end

----------------------------------
-- ### Positions

-- Return First item in a table
local function first(x)  return x[1] end
-- Return last item in a table
local function last(x)  return x[#x] end
-- Push to end 
local function push(t,x)   
 t[#t+1] = x
 return x end
-- Randomly change an items position
local function shuffle( t )
  for i= 1,#t do
    local j = i + math.floor((#t - i) * R.r() + 0.5)
    t[i],t[j] = t[j], t[i] 
  end
  return t end
-- Return any item in a list
local function any(t)
  return t[ math.floor((#t-1) * R.r() + 0.5) ]
end

-- Return an iterator that can return
-- some items in a list.
--
-- e.g.  the following prints 20 then 30
--
--     for x in some({10,20,30,40,50,60},{2,3}) do
--        print(x) end

local function some(t,cols)
  local i = 0
  return function ()
    if i < #cols then
      i= i+1
      return t[cols[i]] end end end

-----------------------------
-- ### Sorting. 
-- Unlike `table.sort`, this `sort` function
-- returns the sorted list.
local function sort(t,f)
  f=f or function (x,y) return x < y end
  table.sort(t,f)
  return t end

local function firsts(x,y)
  return first(x) < first(y) end

local function lasts(x,y)
  return last(x) < last(y) end
-----------------------
-- ### Seek and Destroy

-- Return a list without some item
local function without(t,n)
  out={}
  for j,x in pairs(t) do
    if j ~= n then
      push(out,x) end end
  return out
end

-- Search for the index of an item
local function bsearch(t,val,f) 
  f = f or function (t,x) return t[x] end
  local lo,hi=1,#t
  while lo <= hi do
    local mid = (lo+hi)/2
    mid = math.floor(mid)
    if f(t,mid) >= val then
      hi = mid - 1
    else
      lo = mid + 1 end end
  return math.min(lo,#t)  end
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

-----------------------------------
-- ### Printing

-- `mapprint` shows the `first` m items and
-- the `last` n items (and the default is to
-- show everything).

local function maprint(t, first, last)
  first = first or #t
  for j=1,first do print(j,t[j]) end
  if last then
    print("...")
    for j=#t+last, #t do print(j,t[j]) end end end


-- `mprint` = matrix print. Displays a list of lists,
-- all the columns (right) aligned.
local function mprint(ts,sep) 
  sep = sep or ", "
  local fmt,w={},{}
  local function width(col,x)
    if not w[col] then w[col]=0 end
    local tmp= #tostring(x)
    if tmp > w[col] then 
      w[col] = tmp 
      fmt[col] = "%" .. tmp .. "s" end 
  end ----------------------------
  for _,t in pairs(ts) do
    for col,x in pairs(t) do width(col,x) end end
  for i,t in pairs(ts) do
    io.write(
      string.format(
        table.concat(fmt,sep)  .. "\n",
        unpack(t))) end end

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

return { maprint=maprint,sort=sort,mprint=mprint,
         without=without, firsts=firsts,lasts=lasts,first=first, last=last,same=same,copy=copy,
         shallowCopy=shallowCopy, member=member,map=map, bsearch=bsearch,
         push=push,map2=map2, collect=collect,shuffle=shuffle}

---------------------------------------------------------
-- 
-- ## Legal
-- 
-- <img align=right width=150 src="https://www.xn--ppensourced-qfb.com/media/reviews/photos/original/e2/b9/b3/22-bsd-3-clause-new-or-revised-modified-license-60-1424101605.png">
-- LURE, Copyright (c) 2017, Tim Menzies   
-- All rights reserved, BSD 3-Clause License
-- 
-- Redistribution and use in source and binary forms, with
-- or without modification, are permitted provided that
-- the following conditions are met:
-- 
-- - Redistributions of source code must retain the above
--   copyright notice, this list of conditions and the 
--   following disclaimer.
-- - Redistributions in binary form must reproduce the
--   above copyright notice, this list of conditions and the 
--   following disclaimer in the documentation and/or other 
--   materials provided with the distribution.
-- - Neither the name of the copyright holder nor the names 
--   of its contributors may be used to endorse or promote 
--   products derived from this software without specific 
--   prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
-- CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
-- THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
-- USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
-- IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
