-- ## Watch over a stream, regularly reporting
-- 
-- _tim@menzies.us_   
-- _August'17_   
--
require "show"
local the=require "config"
local NUM=require "num"
------------------------------------------------------
-- Create  a new watcher

local function create(n)  return {
  reportEvery = n,
  m           = 0,
  stats       = NUM.create(),
  all         = {}
} end
------------------------------------------------------
--  Report

local function report(i,x) 
  print{n=i.stats.n, mu=i.stats.mu, sd=i.stats.sd} end
------------------------------------------------------
-- Update watcher `i` with one value `x`

local function update(i,x) 
  if x~= the.ignore then
    i.m = i.m + 1
    NUM.update(i.stats,x)
    if i.m % i.reportEvery == 0 then
      i.all[#i.all + 1] = i.stats
      report(i)
      i.stats = NUM.create() end end
  return i end

----------------------------------------------------
-- Handy short cut

local function watch(n)
  local i=create(n)
  return i, function (x) return update(i,x) end end
------------------------------------------------------
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
------------------------------------------------------
-- Public interface

return {create=create, update=update, updates=updates, 
        watch=watch, report=report}

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
