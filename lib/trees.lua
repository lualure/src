require "show"
local the=require "config"
	
local O=require "tests"	
local TBL=require "tbl"
local TREE=require "sdtree"

local function create(f,y)
  return TREE.grow(
           TBL.discretize( 
             TBL.create(
                THE.here .. f or "/data/auto.csv"), 
                y or "goal1")) end

local function auto(y)      return create("/data/auto.csv",y or "dom") end
local function autogoal1()  return auto("goal1") end

local function pom3a(y)     return create("/data/POM3A_short.csv",y or "dom") end
local function pom3agoal1() return pom3a("goal1") end

local function xomo(y)      return create( "/data/xomo_all_short.csv",y or "dom") end
local function xomogoal1(y) return xomo("goal1") end

TREE.show(auto)
