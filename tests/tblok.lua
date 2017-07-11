--[[

# tableok : unit tests for table

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
local the=  require "config"
local o=    require "tests"	
local tbl=  require "tbl"
local row=  require "row"

local function _test1()
   local t=tbl.create("data/weather.csv")
   print(t.spec)
   assert(#t.rows==14)
   assert(t.rows[14].cells[1]=="rainy")
   assert(o.nstr(t.all.nums[1].mu,4) == o.nstr(73.5714,4))
   assert(o.nstr(t.all.nums[1].sd,4) ==  o.nstr(6.5717,4))
   assert(t.x.syms[1].counts["overcast"] == 4)
   assert(t.x.syms[2].counts["TRUE"]==6)
end
local function someShow(i,j) 
  local r=i.rows[j]
  local tmp={j,r.dom}
  for _,c in pairs(i.goals)  do
    tmp[#tmp+1] = r.cells[c.pos] end
  print(tmp)
end
local function _test3()
   local t=tbl.create("data/auto.csv")
   tbl.dominates(t)
   for j=1,5 do someShow(t,j) end
   print(t.spec)
   print("...")
   for j=#t.rows-5,#t.rows do someShow(t,j) end
   --for i=1,250 do row.dominates(t.rows[i],t) print(t.rows[i].dom) end
end 

o.k{_test1,_test2,_test3}
