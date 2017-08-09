-- ## Simple unit tests
--  
-- _tim@menzies.us_   
-- _August'17_   
--
-- Standard usage:
--
--    require "show"
--    local O=require "tests"
--    
--    local function _num1()
--      local NUM=require "num"
--      local  i = NUM.create()
--      for _,x in pairs{9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4} do
--        NUM.update(i,x) 
--      end
--      assert(i.mu == 7)
--
--    O.k{_num1}
--
-------------------------------------
-- Track and report the `pass`, `fail` counts.
local pass,fail = 0,0

local function report() 
  print(string.format(
        ":pass %s :fail %s :percentPass %.0f%%",
         pass, fail, 100*pass/(0.001+pass+fail))) end
-------------------------------------------------------
-- Report stray globals, skipping the built-ins.

local builtin = { 
  math=true, package=true, 
  table=true, coroutine=true, os=true, 
  io=true, bit32=true, string=true, 
  arg=true, debug=true, _VERSION=true, _G=true,
  load=true, xpcall=true, type=true, print=true,
  pcall=true, require=true, tonumber=true,
  getmetatable=true, setmetatable=true, ipairs=true,
  tostring=true, loadfile=true, collectgarbage=true,
  next=true, rawequal=true, rawget=true, rawlen=true,
  pairs=true, error=true, dofile=true, unpack=true,
  select=true, loadstring=true, module=true, assert=true,
  rawset=true, gcinfo=true, setfenv=true, jit=true,
  bit=true, newproxy=true, getfenv=true}

local function globals()
  for k,v in pairs( _G ) do
    --if type(v) ~= 'function' then  
       if not builtin[k] then 
         print("-- Global: " .. k) end end end --end
------------------------------------------------------
-- Call all the functions in the list `t`.
-- Update the `pass` and `fail` counts.

local function tests(t)
  for s,x in pairs(t) do  
    print("# test:", s) 
    pass = pass + 1
    local t1= os.clock()
    local passed,err = pcall(x) 
    local t2= os.clock()
    print((t2-t1) .. " secs")
    if not passed then   
       fail = fail + 1
       print("Failure: ".. err) end end end
------------------------------------------------------
-- Help for comparing real numbers. Converts them to
-- a string with a limited number of significant figures.    
-- e.g. `assert(O.nstr(sd,4) == O.nstr(73.571,4))`

local function nstr(x,n)
  return  string.format("%.".. n .."f",x) end

local function n5(x,n) return nstr(x,5) end
local function n4(x,n) return nstr(x,4) end
local function n3(x,n) return nstr(x,3) end
local function n2(x,n) return nstr(x,2) end
------------------------------------------------------
local function main(t) 
  if next(t) ~= nil then tests(t) end 
  report()
  globals()  end
------------------------------------------------------
return {k=main,nstr=nstr,n2=n2,n3=n3,n4=n4,n5=n5}

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
