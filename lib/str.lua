-- # str : string utilities

local the=require "config"

local function fmt(control, ...)
  return string.format(control, unpack{...}) end

local function say(control, ...)
  return io.write(string.format(control, unpack{...})) end

local function sayln(control, ...)
  return io.write(string.format(control.."\n", unpack{...})) end

local function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1) end

return {say=say,fmt=fmt,sayln=sayln,replace_char=replace_char}
