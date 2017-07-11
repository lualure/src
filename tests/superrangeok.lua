--[[

# superrangesok : unit tests for superranges

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
local range=require "range"
local super=require "superrange"
local num=require "num"
----------------------------------------------
local function x(z) return z[1] end
local function y(z) return z[#z] end
local function klass(z) 
  if z < 0.23 then return  9 + 2*r.r()/100 end
  if z < 0.76 then return 19 + 2*r.r()/100 end
  return                  29 + 2*r.r()/100 end
----------------------------------------------
local function _test1()
  local lst,n={},num.create()
  for _=1,10^5 do
    local w=r.r()^0.5
    num.update(n,klass(w))
    lst[#lst+1] = {w, klass(w)} end
  print( super(lst,x,y))
end
----------------------------------------------
r.seed(1)
o.k{_test1}
