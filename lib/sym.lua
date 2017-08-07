-- ## Incrementally watch a stream of symbols
--
-- _tim@menzies.us_   
-- _August'18_   
--
-- Use this code to incrementally monitor the frequency
-- counts and entropy of
-- of a stream of numbers. 
--
-- Simple usage:
--
--     local i = SYM.create()
--     for word in string.gmatch(words,"([^ ]+)" ) do
--          SYM.update(i,word) end
--     print(SYM.ent(i)) end
--
-- For those who like less typing:
--
--     local i,addi = SYM.watch()
--     for word in string.gmatch(words,"([^ ]+)" ) do
--       addi(word) end
--     print(SYM.ent(i)) end
 
local the=require "config"
------------------------------------------------------
-- ### Creation
-- Create a new watcher.

local function create()
  return {n=0, counts={}, most=0,mode=nil,_ent=nil } end
------------------------------------------------------
-- ### Update
-- Update a watcher `i` with one value `x`.

local function update(i,x)
  if x ~= the.ignore then
    i._ent = nil 
    i.n = i.n + 1
    local seen = i.counts[x]
    seen = seen and seen+1 or 1
    i.counts[x] = seen 
    if seen > i.most then
      i.most, i.mode = seen,x end end end
-------------------------------------------------------
-- ## Handy short cout

local function watch()
  local i = create()
  return i, function (x) return update(i,x) end end
------------------------------------------------------
-- ### Updates
-- Update a watcher `i` with many values from `t`.
-- Optionally:
--
-- - filter every value in `t` through some function `f`. 
-- - If an filter every value in `t` through some function `f`. 
-- - If an `all` value is supplied, the update `all`. Else
--   return a new watcher.

local function updates(lst,f,i)
  i = i or create()
  f = f or function (z) return z end
  for _,one in pairs(lst) do
    update(i, f(one)) end 
  return i end
-----------------------------------------------------
-- ### Distance
-- Using a watcher `i`, work of the distance between
-- two values `j` and `k`. If either is unknown,
-- the return the max possible distance. If both are
-- unknown, just return nothing.
--
-- Returns two numbers `x,y` where `x` is the distance
-- and `y` is 0,1 depending on whether or not we are returning
-- nothing.

local function distance(i,j,k) 
  local no = the.ignore
  if     j==no and k==no then return 0,0
  elseif j == the.ignore then return 1,1
  elseif k == the.ignore then return 1,1
  elseif j==k            then return 0,1
  else                        return 1,1
  end
end
----------------------------------------------------
-- ### Normalization

local function norm(i,x)
  return x end
----------------------------------------------------
-- ### Map numbers to a range.
-- `i` is a list of pairs {x.label, x.most}.
-- Find `x`'s label with this list.

-- XXXX why is this even here? discrete syms should be syms???

local function discretize(i,x) 
  local r
  if x==the.ignore then return x end
  if not i.bins    then return x end
  for _,b in pairs(i.bins) do
    r = b.label
    if x<=b.most then break end end
  return r end

------------------------------------------------------
-- ### Entropy

-- Takes a little time to calculate.  So we cache the
-- result (and note that `update` zaps `_ent` whenever
-- new data arrives.

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
-- ### KE
-- Needed for Fayyad-Irrani. Is this even used?

local function ke(i)
  local e,k = 0,0
  for _,f in pairs(i.counts) do
    e = e + (f/i.n) * math.log((f/i.n), 2)
    k = k + 1
  end
  e = -1*e
  return k,e,k*e end
------------------------------------------------------
-- ### External Interface

return {create=create, update=update, updates=updates, 
        ent=ent, spread=ent, discretize=discretize,
        ke=ke,watch=watch}

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
--
