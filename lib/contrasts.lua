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

local function monitors(branches)
  return plans(branches, function(x,y)
               return x < y end) end

local function holds(branch)
  local out = {}
  for i=1,#branch do
    step = branch[i]
    --print(step)
    out[#out+1] = {step[1], step[2]} end 
  return out end

local function plans(branches, better)
  better = better or function(x,y) return x > y end
  for i,branch1 in pairs(branches) do
    local out={}
    local h1= holds(branch1)
    local num1=LST.last(branch1)[3]
    for j,branch2 in pairs(branches) do
      if i ~= j then
        local num2=LST.last(branch2)[3]
        if better(num2.mu, num1.mu)  then
          if not NUM.same(num1,num2) then
            local h2= holds(branch2)
            local inc = delta(h2,h1)
            if #inc > 1 then
              out[#out+1] = {ninc=#inc,muinc=num2.mu - num1.mu,inc=inc,
                             branch1=h1,mu1=num1.mu, branch1=h2,mu2=num2.mu}
               end end end end end 
    table.sort(out, function (x,y) return x.muinc > y.muninc end)
    print("mu ",out[1])
    table.sort(out, function (x,y) return x.ninc < y.ninc end)
    print("deltq ",out[1])

    end end

               

local function member2(twin0,twins) 
  for _,twin1 in pairs(twins) do
    if twin0[1] == twin1[1] and
       twin0[2] == twin1[2] then
       return true end end
  return false end


function delta(held1, held2) 
  local out={}
  for _,twin in pairs(held1) do
    if not member2(twin,held2) then
      out[#out+1] = {twin[1], twin[2]} end end
  return out end


defaults()
the.tree.min=4
x=TREES.auto()
b=branches(x,{},{})
--LST.maprint(b)

TREE.show(x)

plans(b)
