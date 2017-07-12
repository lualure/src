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
local range=require "range"
local copy=(require "lists").copy
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
local function same(j) return j end
--------------------------------------------
return function (lst,x,y)
  y = y or function(j) return j[#j] end
  local breaks,ranges = {},range(lst,x)
  --------------------------------------------
  local function data(j) return ranges[j]._all._all end
  --------------------------------------------
  local function memo(here,stop,_memo,    b4,inc)
    if stop > here then inc=1 else inc=-1 end
    if here ~= stop then 
       b4=  copy( memo(here+inc, stop, _memo)) end
    _memo[here] = num.updates(data(here), y, b4)
    return _memo[here] end
  --------------------------------------------
  local function combine(lo,hi,all,bin,lvl)   
    local best = all.sd
    local lmemo,rmemo = {},{}
    memo(hi,lo, lmemo) -- summarize i+1 using i
    memo(lo,hi, rmemo) -- summarize i using i+1
    local cut, lbest, rbest
    for j=lo,hi-1 do
      local l = lmemo[j]
      local r = rmemo[j+1]
      local tmp= l.n/all.n*l.sd + r.n/all.n*r.sd
      if (tmp*1.01 < best) then
        cut  = j
        best = tmp
        lbest = copy(l)
        rbest = copy(r)
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
           -- table.sort(breaks)
  return labels(breaks) end
