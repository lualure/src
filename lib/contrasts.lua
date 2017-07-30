require "show"
local THE=require "config"
local TREE=require "sdtree"
local TREES=require "trees"
local LST=require "lists"
local NUM=require "num"

local function branches(tr,out,b)
  if tr.attr then
    b[#b+1] = {tr.attr,tr.val,tr.stats} end
  if #b > 0 then out[#out+1] = b   end
  for _,kid in pairs(tr._kids) do
      branches(kid,out,LST.copy(b)) end  
  return out end

local function plans(branches)
  for i,branch1 in pairs(branches) do
    for j,branch2 in pairs(branches) do
      if i ~= j then
        local num1=LST.last(branch1)[3]
        local num2=LST.last(branch2)[3]
        if num2.mu > num1.mu then
          if not NUM.same(num1,num2) then
            print(i,j,(num2.mu - num1.mu)/num1.mu) end end end end end end

defaults()
the.tree.min=4
x=TREES.xomo()
b=branches(x,{},{})
LST.maprint(b)

TREE.show(x)

plans(b)
