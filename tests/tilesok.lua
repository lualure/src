require "show"
local o=require "tests"	
local r=require "random"
local s=require "sample"
local tiles=require "tiles"
local lst=require "lists"

r.seed(1)
out3={}
out2={}
out1={}
for i=1,10000 do
  out1[i] = r.r()^2 
  out2[i] = 3*r.r()^0.5 
  out3[i] = r.r()^0.5 end


--print(tiles.tiles(out,10,2))

lst.maprint(tiles.shows{out1,out2,out3})
