require "show"
local THE=require "config"
local TBL=require "tbl"
local TREE=require "sdtree"

local function create(f,y)
  y = y or "goal1"
  f = f or "/data/auto.csv"
  f = THE.here .. f
  return TREE.grow(
           TBL.discretize( TBL.create(f),y), 
                           y) end

local function auto(y)      
   return create("/data/auto.csv",y or "dom") end
local function pom3a(y)     
  return create("/data/POM3A_short.csv",y or "dom") end
local function xomo(y)      
  return create( "/data/xomo_all_short.csv",y or "dom") end

local function autogoal1()  return auto("goal1") end
local function pom3agoal1() return pom3a("goal1") end
local function xomogoal1(y) return xomo("goal1") end

return {auto=auto, pom3a=pom3a, xomo=xomo, autogoal1=autogoal1,
        pom3agoal1=pom3agoal1, xomogoal1=xomogoal1}
