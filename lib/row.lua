-- ## Rows in a table
-- 
-- _tim@menzies.us_    
-- _August, 2018_
--
-- A `row` is a slave module to  `tbl`.
-- `Rows` are where `tbl`s store one line of data.
-- Note that it is not possible to test `row`s without
-- also testing `tbl`s.

local ID=  require "id"
local LST= require "lists"
local NUM= require "num"
-----------------------------------------------------------
-- `Row`s have a unique id and cells of data.

local function create()
  return {id=ID.new(),   cells={}} end
-----------------------------------------------------------
-- When `row` data is added, go to the `tbl` headers and
-- update their counts of what numbers and symbols have been seen

local function update(i,cells,t)
  i.cells=LST.copy(cells)
  for _,head in pairs(t.all.cols) do
    head.what.update(head, cells[head.pos]) end
  return i end
-----------------------------------------------------------
-- Copied `row`s have the same unique id but their
-- cells are held in a different container.

local function copy(i)
  local j = create()
  j.cells = LST.copy(i.cells) -- get different cells
  j.id = i.id -- keep their same id (for reference purposes)
  return j end
----------------------------------------------------------
-- The distance between two `row`s  is normalized 0..1
-- by dividing it by the maximum possible distance.
-- To compute that distance, rows ask each column for
-- a function `f` that determines the distance between
-- two values in that kind of column (to see how that works,
-- look at `distance` in `num.lua` and `sym.lua`).

local function distance(i,j,t)
  local d,n,p=0,10^-64,0.5
  for _,col in pairs(t.x.cols) do
    local f = col.what.distance
    local d1,n1 = f(col, i.cells[col.pos], j.cells[col.pos])
    d = d + d1
    n = n + n1 end
  return d^p / n^p end
-----------------------------------------------------------
-- A `row`s position can be projected using the cosine rule
-- onto a line running between two other points (called
-- `west` and `east`).

local function x(i,west,east,t,      c)
  local c= c or distance(west,east,t)
  local b= distance(i,east,t)
  local a= distance(i,west, t)
  return (a^2 + c^2 - b^2) / (2*c),c  
end
-----------------------------------------------------------
-- Imagine we have some function `f` that inputs a `row`,
-- and outputs some value calulated for that `row.` Then,
-- given a new `row` (without that value), 
-- then that value can be extraloated from
-- two other `row`s. Note that the following code assumes
-- `f(west) &le; f(east)`.

local function extrapolate(i,west, east,f,t,c)
  local x0,c = x(i,west,east,t,c)
  local x1,x2,y1,y2 = 0,c,f(west,t), f(east,t)
  local m  = (y2 - y1) / (x2 - x1) -- rise/run
  local b  = y2 - m*x2  -- the slope
  return m * x0 + b end
------------------------------------------------------------
-- To see if row `i` dominates rows `j` in table `t`,
-- then sum the difference in  the goal values between
-- the two rows (we raise that difference to an exponent to make
-- any such difference "shout load").

local function dominate1(i,j,t)
  local e,n = 2.71828,#t.goals
  local sum1,sum2=0,0
  for _,col in pairs(t.goals)  do
    local w= col.weight
    local x= NUM.norm(col, i.cells[col.pos])
    local y= NUM.norm(col, j.cells[col.pos])
    sum1 = sum1 - e^(w * (x-y)/n)
    sum2 = sum2 - e^(w * (y-x)/n) 
  end 
  return sum1/n < sum2/n end
-----------------------------------------------------------
-- Count how many times row `i` dominates row `j` (where
-- "domination" is computed by the function `f`).

local function dominate(i,t,f) 
  f = f or dominate1
  local tmp = 0
  for x,j in pairs(t.rows) do
    if i.id ~= j.id then 
      if f(i,j,t) then
        tmp= tmp + 1  end end end 
  return tmp end
-----------------------------------------------------------
-- External Interface

return {create=create, update=update,dominate=dominate,copy=copy}

---------------------------------------------------------
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
