--[[

# table : utilities

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

local the=require "config"
local num=require "num"
local sym=require "sym"
local row=require "row"
local csv=require "csv"
-------------------------------------------------------------
local function create(cells) return {
  rows={}, 
  spec={}, 
  goals={} , less={}, more={}, 
  -- goals={less={}, more={}, cols={}}
  all={nums={}, syms={}, cols={}}, -- all columns
  x  ={nums={}, syms={}, cols={}}, -- all independent columns
  y  ={nums={}, syms={}, cols={}}  -- all depednent   columns
} end
-------------------------------------------------------------
local function meta(i,txt)
  local spec =  {
    {when= "%$", what= num, weight= 1, where= {i.all.cols, i.x.cols, i.all.nums,                  i.x.nums}},
    {when= "<",  what= num, weight=-1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.less, i.y.nums}},
    {when= ">",  what= num, weight= 1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.more, i.y.nums}},
    {when= "!",  what= sym, weight= 1, where= {i.all.cols, i.y.cols, i.all.syms                   }},
    {when= "",   what= sym, weight= 1, where= {i.all.cols, i.x.cols, i.all.syms,                  i.x.syms}}}
  for _,want in pairs(spec) do
    if string.find(txt,want.when) ~= nil then
      return want.what, want.weight, want.where end end end
-------------------------------------------------------------
local function header(i,cells)
  i.spec = cells
  for col,cell in ipairs(cells) do
    local what, weight, wheres = meta(i,cell)
    local one = what.create()
    one.pos   = col
    one.txt   = cell
    one.what  = what
    one.weight= weight
    for _,where in ipairs(wheres) do
      where[ #where + 1 ] = one end end end
-------------------------------------------------------------
local function data(i,cells)
  i.rows[#i.rows+1] = row.update(row.create(), cells,i) end
-------------------------------------------------------------
local function update(i,cells) 
  local fn= #i.spec==0 and header or data
  fn(i,cells) end
-------------------------------------------------------------
local function copy(i) 
  return header(create(),i.spec) end
-------------------------------------------------------------
local function dominates(i)
  for _,r in pairs(i.rows) do 
    row.dominate(r,i) end
  table.sort(i.rows,function (r1,r2) 
             return r1.dom > r2.dom end) end
-------------------------------------------------------------
local function fromCsv(f)
  local out = create()
  csv(f, function (cells) update(out,cells) end)
  return out end
-------------------------------------------------------------
return {copy=copy, dominates=dominates,create=fromCsv} 
