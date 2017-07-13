--[[

# superranges : utilities

DARE, Copyright (c) 2017, Tim Menzies
All rights reserved, BSD 3-Clause License

Redistribution and use in source and binary forms, with
or without modification, are permitted provided that
the following conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the 
  following disclaimer.

* Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the 
  following disclaimer in the documentation and/or other 
  materials provided with the distribution.

* Neither the name of the copyright holder nor the names 
  of its contributors may be used to endorse or promote 
  products derived from this software without specific 
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

------------------------------------------------------

--]]

require "show"
local the=require "config"
local num=require "num"
local sym=require "sym"
local range=require "range"
local lst= require "lists"
local replace=(require "str").replace_char
--------------------------------------------
local function labels(nums)
  local out={}
  for i =1,#nums do
    out[#out+1] =  {
      most  = nums[i], 
      label  =replace(i,string.rep("_",#nums),
                        string.char(64+i))} end 
  return out end
--------------------------------------------
-- covenient short cuts
local function same(_)    return _ end
local function sd(_)      return _.sd end
local function ent(_)     return sym.ent(_)  end
local function below(x,y) return x*1.01 < y end
local function above(x,y) return x > y*1.01 end
--------------------------------------------
return function (things,x,y,   nump, lessp)
  -- setting up
  y    = y or lst.last -- klass is last arg
  nump = nump==nil  and true or nump 
  lessp= lessp==nil and true or lessp
  local better= lessp and below or above
  local what  = nump and num or sym 
  local z     = nump and sd or ent
  local breaks,ranges = {},range(things,x) -- breaks is the output
  --------------------------------------------
  -- Useful short cut function
  local function data(j) return ranges[j]._all._all end
  --------------------------------------------
  -- We'll always be counting right and left from current pos.
  -- So, to save time, pre-compute and cache the left and right stats.
  local function memo(here,stop,_memo,    b4,inc)
    if stop > here then inc=1 else inc=-1 end
    if here ~= stop then 
       b4=  lst.copy( memo(here+inc, stop, _memo)) end
    _memo[here] = what.updates(data(here), y, b4)
    return _memo[here] end
  --------------------------------------------
  local function combine(lo,hi,all,bin,lvl)   
    local best = z(all)
    local lmemo,rmemo = {},{}
    memo(hi,lo, lmemo) -- summarize i+1 using i
    memo(lo,hi, rmemo) -- summarize i using i+1
    local cut, lbest, rbest
    for j=lo,hi-1 do
      local l = lmemo[j]
      local r = rmemo[j+1]
      local tmp= l.n/all.n*z(l) + r.n/all.n*z(r)
      if better(tmp, best) then
        cut  = j
        best = tmp
        lbest = lst.copy(l)
        rbest = lst.copy(r)
    end end
    if cut then
      bin = combine(lo,   cut, lbest, bin, lvl+1) + 1
      bin = combine(cut+1, hi, rbest, bin, lvl+1)
    else
      breaks[bin] = breaks[bin] or -10^32
      if ranges[hi].hi > breaks[bin] then
          breaks[bin] = ranges[hi].hi  end end
    return bin end 
  --------------------------------------------
  combine(1,#ranges, 
           memo(1,#ranges,{}),
           1,0)  
  return labels(breaks) end
