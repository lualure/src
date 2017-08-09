-- ## Handling Tables of Data
-- 
-- _tim@menzies.us_   
-- _August'17_   
--
-- One of my core data structures is `tbl` (table). Its a place to store
-- `row`s of data. 
--
-- - When data comes in from disk, it gets  stored  it as a `tbl`;
-- - When data in one `tbl` is divided, the divisions are `tbl`s.
-- - When we cluster, each cluster is its own `tbl`.
-- - When we build a denogram (a recursive division of data into sub-data, then sub-sub data, then sub-sub-sub data, etc)
--   then each node in that tree is `tbl`.
--
-- Each column in   `tbl` has a header that is a `num` or a `sym` 
-- and that header maintains a summary of what was seen in each column.
--
-- `Tbl`s are incremental readers of rows of data. As rows are found, we can throw them at a table:
--
-- - If this is other than  the first `row` then `Tbl` assumes it is a `row` to be stored in the table.
--   As a side-effect of storage, all the column headers are updated.
-- - If this is the first `row`
--   then `Tbl` assumes it is a `header` that lists the names and types of each column.
--        - If the name contains `?`, then `Tbl` should ignore this column;
--        - If the name contains `<,>`, then the column can be categoried as a numeric goal to eb minimized or maximized;
--        - If the name contains `!`, then the column can be categorised as a   symbolic goal, to be used in classification;
--        - If the name contains `$`, then the column is categorised as a  numeric indepedent variable;
--        - Otherwise, the column can be categories as  a symbolic independent variable.
--  
-- Note that there is nothing hard-wired in this code about `?<>!$`. These can be easily changed in 
-- the `categories` function. 
--
-- What `Tbl` does assume is that columns of data can be categoried as :
-- 
-- - `x` : the independent columns;
-- - `y` : the dependent columns;
-- - `all` : all columns.
--
-- Within `all,x,y` the columns are further categorised as:
--
-- - `nums`: the numeric columns;
-- - `syms`: the symbolic columns;
-- - `cols`: all columns.
--
-- Note that a column can have multiple categories (see `categories`). This is done
-- since sometimes we have to (e.g.) process all the numerics together or  process all
-- the independent symbolics together etc. For an example of a column in multiple categories, a `<` column is
-- 
-- - .all.cols 
-- - .y.cols 
-- - .all.nums 
-- - .goals 
-- - .less
-- - .y.nums
--
-- Note that each column gets one, and only one `num` or `sym` header structure and that header structure
-- may be stored in multiple categories.

local the=require "config"
local NUM=require "num"
local SYM=require "sym"
local ROW=require "row"
local CSV=require "csv"
local LST=require "lists"
local SUPER=require "superrange"
-------------------------------------------------------------
-- ### Create a new table

local function create() return {
  rows={}, 
  spec={}, 
  goals={} , less={}, more={}, 
  name={},
  all={nums={}, syms={}, cols={}}, -- all columns
  x  ={nums={}, syms={}, cols={}}, -- all independent columns
  y  ={nums={}, syms={}, cols={}}  -- all depednent   columns
} end
-------------------------------------------------------------
-- ### Define column categories. 
-- Input the column header `txt` and look for the special characters "$,<,>,!".

local function categories(i,txt)
  local spec =  {
    {when= "%$", what= NUM, weight= 1, where= {i.all.cols, i.x.cols, i.all.nums,                  i.x.nums}},
    {when= "<",  what= NUM, weight=-1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.less, i.y.nums}},
    {when= ">",  what= NUM, weight= 1, where= {i.all.cols, i.y.cols, i.all.nums, i.goals, i.more, i.y.nums}},
    {when= "!",  what= SYM, weight= 1, where= {i.all.cols, i.y.cols,             i.all.syms}},
    {when= "",   what= SYM, weight= 1, where= {i.all.cols, i.x.cols,             i.all.syms,      i.x.syms}}}
  for _,want in pairs(spec) do
    if string.find(txt,want.when) ~= nil then
      return want.what, want.weight, want.where end end end
-------------------------------------------------------------
-- ### Define table  column headers 
-- Called on the first row ever passed to a table.

local function header(i,cells)
  i.spec = cells
  for col,cell in ipairs(cells) do
    local what, weight, wheres = categories(i,cell)
    local one = what.create()
    one.pos   = col
    one.txt   = cell
    one.what  = what
    one.weight= weight
    i.name[one.txt] = one
    for _,where in pairs(wheres) do
      where[ #where + 1 ] = one end end 
  return i end
-------------------------------------------------------------
-- ### Define a row of data 
-- Called on every row after row one.
-- Note that such rows are stored in the `ROW` struct.

local function data(i,cells,old)
  local new = ROW.update(ROW.create(),cells,i)
  i.rows[#i.rows+1] = new
  if old then
    new.id=old.id end
  return new end
-------------------------------------------------------------
-- ### Update a table with a row of cells
-- Calls `header` for row1 and `data` for all other rows

local function update(i,cells) 
  local fn= #i.spec==0 and header or data
  return fn(i,cells) end
-------------------------------------------------------------
-- ### Copy a table
--
-- If `from` == `full` then copy all rows from the old
-- table to the new.
--
-- If `from` is a number then copy than number of rows
-- (selected at random from the old to new table).
--
-- If `from` is another table then add the rows in that
-- table into this new table.
--
-- Note that when rows are copied as deep copies; i.e.
-- the contents move but not the container (so updates
-- to the old table will not effect the new table).

local function copy(i, from) 
  local j=create()
  header(j, LST.copy(i.spec)) 
  if from=="full" then
    for _,r in pairs(i.rows) do
      data(j, LST.copy(r.cells))  end
  elseif type(from)=='number' then
    LST.shuffle(i.rows)
    for k=1,from do
      data(j, LST.copy(i.rows[k].cells)) end 
  elseif type(from)=='table' then
    for _,r in pairs(from) do
      data(j, LST.copy(r.cells),r) end end
  return j 
end
-------------------------------------------------------------
-- suspect this is broken
--

local function discretizeCells(i,cells) 
  out=LST.copy(cells)
  for _,head in pairs(i.x.cols) do
     out[head.pos] = SYM.discretize(head,cells[head.pos]) end
  return out
end
-------------------------------------------------------------
-- ### Goal functions
--
-- Feature extractors from a ROW.

local function goallast(t,n) 
  return function(r) 
           return LST.last(r.cells )  end  end

local function goaln(t,n) 
  return function(r) 
           return r.cells [ t.y.nums[n].pos ] end  end

local function goal1(t) 
  return goaln(t,1) end 

local function dom(t)
  local b4={}
  return function (r)   
           if not b4[r.id] then 
             b4[r.id]=ROW.dominate(r,t) end
           return b4[r.id] end end

local funs={goaln=goaln, goal1=goal1,dom=dom,goallast=goallast}
-------------------------------------------------------------
-- ### Convert a numeric header to symbolic
--
local function discretizeHeaders(spec)
  return LST.collect(spec, 
           function(txt) 
             return string.gsub(txt,"%$","") end) end
-------------------------------------------------------------
-- ### Discretize rows
--
-- Return a new table with the numerics broken up into
-- symbolic ranges.
-- Each header on the new table gets an extra variable, `bins`, which is a list
-- specifying how to change a `Num` into a `Sym`.
-- Using that inormation, all the rows in the old table are turned into
-- symbols in the new table.

local function discretizeRows(i, y)
  local j = header(create(), 
             discretizeHeaders(i.spec))
  local yfun = funs[y](i)
  for _,head in pairs(i.x.nums) do
    local cooked = j.all.cols[head.pos]
    local function x(r) return r.cells[cooked.pos] end
    cooked.bins = SUPER(i.rows,x, yfun) 
  end
  for _,r in pairs(i.rows) do
    local tmp=LST.copy(r.cells)
    for _,head in pairs(i.x.nums) do
      local cooked    = j.all.cols[head.pos]
      local old       = tmp[cooked.pos]
      local new       = SYM.discretize(cooked, old)
      tmp[cooked.pos] = new  end
    data(j,tmp,r) end 
  return j end
-------------------------------------------------------------
-- ### Create a table from a csv file
--
local function fromCsv(f)
  local out = create()
  CSV(f, function (cells) update(out,cells) end)
  return out end
-------------------------------------------------------------
-- ### External interface

return {copy=copy, header=header,update=update,
        create=fromCsv,goal1=goal1,dom=dom,goaln=goaln,goallast=goallast,
        discretize=discretizeRows,discretize1=discretizeCells}

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
