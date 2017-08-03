-- ## Incremetally watch a stream of numbers
--
-- _tim@menzies.us_   
-- _August'18_   
--

-- add example usages

local the=require "config"
----------------------------------------------------
-- ### Creation
-- Create a new watcher.

local function create()
    return {n=0,mu=0,m2=0,sd=0,hi=-1e32,lo=1e32,w=1} end
----------------------------------------------------
-- ### Update
-- Update a watcher `i` with one value `x`.

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
-- ### Updates
-- Update a watcher `i` with many values from `t`.
-- Optionally:
--
-- - filter every value in `t` through some function `f`. 
-- - If an filter every value in `t` through some function `f`. 
-- - If an `all` value is supplied, the update `all`. Else
--   return a new watcher.

local function updates(t,f,all)
  all = all or create()
  f = f or function (z) return z end
  for _,one in pairs(t) do
    update(all, f(one)) end 
  return all end
----------------------------------------------------
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
  return math.abs(j-k)^2,1 end
----------------------------------------------------
-- ### Map numbers to a range.
-- `i` is a list of pairs {x.label, x.most}.
-- Find `x`'s label iwhtin this list.

local function discretize(i,x) 
  if x==the.ignore then return x end
  if not i.bins    then return x end
  for _,b in pairs(i.bins) do
    r = b.label
    if x<=b.most then break end end
  return r end
----------------------------------------------------
-- ### Normalization

local function norm(i,x)
  if x==the.ignore then return x end
  return (x - i.lo) / (i.hi - i.lo + 1e-32) end
----------------------------------------------------
-- ### Parametric significance tests
-- `ttest` accepts two `num`s alled `i,j`.

local function ttest1(df,first,last,crit) 
  if df <= first  then
    return crit[first] 
  elseif  df >= last then 
    return crit[last]
  else
    local n1 = first
    while n1 < last do
      local n2=n1*2
      if df >= n1 and df <= n2 then
        local old,new = crit[n1],crit[n2]
        return old + (new-old) * (df-n1)/(n2-n1) end 
      n1=n1*2 end end end

local  function ttest(i,j) -- Debugged using https://goo.gl/CRl1Bz
  local t  = (i.mu - j.mu) / 
              math.sqrt(math.max(10^-64, i.sd^2/i.n + j.sd^2/j.n ))
  local a  = i.sd^2/i.n
  local b  = j.sd^2/j.n
  local df = (a + b)^2 / (10^-64 + a^2/(i.n-1) + b^2/(j.n - 1))
  local c  = ttest1(math.floor( df + 0.5 ), 
                    the.num.first,
                    the.num.last,
                    the.num.criticals[the.num.conf])
  return math.abs(t) > c end
----------------------------------------------------
-- ### Parametric Effect Size Test

local function hedges(i,j) -- from https://goo.gl/w62iIL
  local nom   = (i.n - 1)*i.sd^2 + (j.n - 1)*j.sd^2
  local denom = (i.n - 1)        + (j.n - 1)
  local sp    = math.sqrt( nom / denom )
  local g     = math.abs(i.mu - j.mu) / sp  
  local c     = 1 - 3.0 / (4*(i.n + j.n - 2) - 1) -- handle small samples
  return g * c > the.num.small end
----------------------------------------------------
-- ### Statistical difference
-- Two populations are statistically similar if they differ by less
-- than a trvially small amount; and if they are statistically significantly different.

local function same(i,j)
  return not (hedges(i,j) and ttest(i,j)) end
----------------------------------------------------
--- ### External interface

return {create=create, same=same, update=update, updates=updates,norm=norm}

--------------------------------------------------------
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
