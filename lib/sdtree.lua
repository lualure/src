-- ## sdtree : iterative divisions to minimize sd

-- A decision tree learner. Assumes discrete independent data
-- and a  numeric dependent variable whose standard deviation
-- we aim to minimize.

require "show"
local the=require "config"
local num=require "num"
local lst=require "lists"
local row=require "row"
local tbl=require "tbl"
local str=require "str"
------------------------------------------------
-- ### Create a node in a decision tree
-- Each node contains a table `_t`, a list of `_kids`,
-- an `attr`, `val` pair used to split column `pos`
-- and some `stats` on the rows in the table in this node.

local function create(t,yfun,pos,attr,val)  
  return { _t=t, 
          _kids={},
          yfun = yfun,
          pos=pos, -- split data at this pos
          attr= attr, val= val, 
          stats= num.updates(t.rows,  yfun)}
end
-----------------------------------------------
-- ###  Order the columns
-- Returns the column headers, sorted by how much
-- would reduce the standard deviation if its
-- values are used to split the rows.

local function order(t,y)
      local function xpect(col)
        local tmp = 0
        for _,x in pairs(col.nums) do
          tmp = tmp +  x.sd * x.n / col.n end 
        return tmp 
      end
      local function whatif(head,y)
        local col = {pos=head.pos, what=head.txt, nums={},n=0} 
        for _,row in pairs(t.rows) do
           local x = row.cells[col.pos]
           if x ~= the.ignore then
             col.n = col.n + 1
             col.nums[x] = num.update(col.nums[x] or num.create(), 
                                      y(row))  end end
        return {key=xpect(col), val=col} 
      end
  local out = {}
  for _,h in pairs(t.x.cols) do 
    out[#out+1] = whatif(h,y) end
  table.sort(out, function (x,y) 
                      return x.key < y.key end)
  return lst.collect(out, function (x) 
                              return x.val end) end
------------------------------------------------
-- ### Grow the tree top down.
-- At each step, ask the `order` function what is the best
-- column to split the current data.
-- 
-- Terminate tree growth if there are fewer than  `the.tree.min` in the splits
-- or the tree has grown deeper than `the.tree.maxDepth`.
local function grow1(above,yfun,rows,lvl,b4,pos,attr,val)
  local function pad()       return str.fmt("%-20s",string.rep('| ',lvl)) end
  local function likeAbove() return tbl.copy(above._t,rows)  end
  if #rows >= the.tree.min then 
    if lvl <= the.tree.maxDepth then 
      local here = lvl == 0 and above or create(likeAbove(), yfun,pos,attr,val) 
      if here.stats.sd < b4 then 
        if lvl > 0 then 
          above._kids[ #above._kids+1 ] = here 
        end
        local cuts= order(here._t, yfun) -- where to split?
        local cut= cuts[1] -- where to split?
        local kids= {}
        for _,r in pairs(rows) do
          local val = r.cells[cut.pos]
          if val ~= the.ignore then  -- remember to skip the ignores
            local rows1    = kids[val] or {}
            rows1[#rows1+1] = r  -- push row 
            kids[val]     = rows1 end end
        for val,rows1 in pairs(kids) do
          if #rows1 <  #rows then
            grow1(here,yfun,rows1,lvl+1,here.stats.sd,cut.pos,cut.what,val) 
  end end end end end end

local function grow(t, y)
  local yfun = tbl[y](t)
  local root = create(t,yfun)
  grow1(root, yfun, t.rows,0,10^32) 
  return root end
------------------------------------------------
-- ### Pretty print for tables
local function tprint(tr,    lvl)
  local function pad()       return string.rep('| ',lvl-1) end
  local function left(x)     return str.fmt("%-20s",x) end
  lvl = lvl or 0
  local suffix=""
  if #tr._kids == 0 or lvl ==0 then
      suffix =  str.fmt("n=%s mu=%-.2f sd=%-.2f",
                        tr.stats.n, tr.stats.mu, tr.stats.sd) end
  if lvl ==0 then
    print("\n".. suffix)
  else
    print(left(pad() .. (tr.attr or "") .. " = " .. (tr.val or "")),
          "\t:",suffix) end 
  for j=1,#tr._kids do
      tprint(tr._kids[j],lvl+1) end end  
---------------------------------------------
-- ### Find the table leaf for some cells (used for classifying new examples)

local function leaf(tr,cells,  lvl)
  lvl=lvl or 0
  for j,kid in pairs(tr._kids) do
    local pos,val = kid.pos, kid.val
    if cells[kid.pos] == kid.val then
      return leaf(kid, cells, bins, lvl+1) end end 
  return tr end
--------------------------------------------
-- External itnerface
return {order=order,grow=grow,show=tprint,leaf=leaf}

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
