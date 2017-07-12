--[[

# listsok : unit tests for lists

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
	
local o=require "tests"	
local r=require "random"
local lst=require "lists"
 
local function _test1()
 assert(lst.shuffle{1,2,3,4,5} ~= 3)
 assert(lst.member(10,{10,20,30}))
 assert(lst.first{10,20,30} == 10)
 assert(lst.last{10,20,30} == 30)
end

local function _mapping()
  local t1={1,2,3,4}
  local function visit(w,x) 
            w.sum = w.sum + x
            w.n = w.n+1 end
  local w= lst.map2({10,20,30},
                    {sum=0,n=0},
                    visit)
 assert(w.sum== 60)
 assert(w.n== 3)
end

local function _copy()
  local t1={1,2,3,4}
  local function visit(w,x) 
            w.sum = w.sum + x
            w.n = w.n+1 end
  local w= lst.map2({10,20,30},
                    {sum=0,n=0},
                    visit)
 assert(w.sum== 60)
 assert(w.n== 3)
end

r.seed()
o.k{_test1,_mapping}
