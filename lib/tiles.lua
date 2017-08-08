-- ## Show percentils
-- 
-- _tim@menzies.us_   
-- _August'18_   
--
--
-- This is a low-level routine that just pretty
-- prints a box plot of lists of numbers. Best
-- described via example. Try `lua tilesok.lua`
-- for pretty-prints of three distributions.

require "show"
local THE = require "config"
local LST= require "lists"
-----------------------------
-- Sort list `i`, break into `1/p' sections,
-- print section 1, then print every `jump`
-- section after that.

local function   tiles(i,p, jump)
  local p    = p or 10
  local jump = jump or 1
  table.sort(i)
  local inc = #i / p
  local q,out = inc, {}
  while q < #i do
    out[#out+1] = i[ math.floor( q ) ]
    q = q + jump*inc end
  return out end
-------------------------------------
-- Control settings for the `show` function

local function hows(t) 
  table.sort(t)
  return {
  width=50,
  lo = t[1],
  hi = t[#t],
  chops={{0.1,"-"},
         {0.3," "},
         {0.5," "},
         {0.7,"-"},
         {0.9," "}},
  bar="|",
  star="*",
  show= THE.sample.fmtnum or "%5.3f"} end
-------------------------------------------------
-- Generate a list that is a pretty print a list of numbers `t`

local function show(t, how)
  how = how or hows(t)
  local function fl(x)    return 1+ math.floor(x) end
  local function pos(p)   return t[ fl(p * #t) ] end
  local function place(x) 
         return fl( how.width*(x- how.lo)/(how.hi - how.lo+10^-32) ) end
  local function whats(chops)
          return  LST.collect(chops, function (_) return 
                              pos(_[1]) end ) end
  local function wheres(what) 
          return LST.collect(what, function (_) return 
                             place(_)  end ) end
  how.lo = math.min(how.lo, t[1])
  how.hi = math.max(how.hi, t[#t])
  local what   = whats(how.chops)
  local where  = wheres(what)
  local out={}
  for i=1,how.width + 1 do out[i] = " " end
  local b4=1
  for k,now in pairs(where) do
    if k> 1 then
      for i = b4,now  do
        out[i] = how.chops[k-1][2] end  end
    b4= now  end
  out[math.floor(how.width/2)] = how.bar
  out[place(pos(0.5))]    = how.star
  local suffix = LST.collect(what,  function (_) return
                     string.format(how.show,_) end) 
  return "(" .. table.concat(out,"") .. ") " .. 
                table.concat(suffix,", ") end
------------------------------------------------
-- Using the min/max of all the numbers anywhere in
-- a table of tables of numbers `ts`, Generate a 
-- pretty print of the tables of numbers `ts`,
-- then print them

local function shows(ts) 
  local lo,hi,out = 10^64, -10^64, {}
  for _,t in pairs(ts) do
    for _,v in pairs(t) do
      lo = math.min(lo, v)
      hi = math.max(hi, v) end
    table.sort(t)
    out[#out+1] = t  end
  table.sort(out, function(a,b) return 
                  a[math.floor(#a/2)] < b[math.floor(#b/2)] end )
  return LST.collect(out, function (t) 
                          local how = hows(t)
                          how.lo = lo
                          how.hi = hi
                          return show(t,how) end) end

-- Convenience function. Generate and pring
local function showAndPrint(ts) 
  for _,one in pairs(shows(ts)) do
    print(one) end end

---------------------------------------------
-- External interface
--
return {tiles=tiles, show=show, 
        print=showAndPrint,shows=shows,how=hows}

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
