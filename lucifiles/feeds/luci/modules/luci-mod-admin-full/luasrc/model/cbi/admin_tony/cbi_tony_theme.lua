-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>
-- Copyright 2019 Tony <tony-cn@outlook.com>
luci.sys.exec("opkg  install /etc/*.ipk  >/dev/null") 
-- Licensed to the public under the Apache License 2.0.

local sys   = require "luci.sys"
local zones = require "luci.sys.zoneinfo"
local fs    = require "nixio.fs"
local conf  = require "luci.config"

local m, s, o
local has_ntpd = fs.access("/usr/sbin/ntpd")

m = Map("system", translate("System"), translate("Here you can configure the basic aspects of your device like its hostname or the timezone."))
m:chain("luci")


s = m:section(TypedSection, "system", translate("System Properties"))
s.anonymous = true
s.addremove = false

s:tab("language", translate("Language and Style"))




--
-- Langauge & Style
--

o = s:taboption("language", ListValue, "_lang", translate("Language"))
o:value("auto")

local i18ndir = luci.i18n.i18ndir .. "base."
for k, v in luci.util.kspairs(conf.languages) do
	local file = i18ndir .. k:gsub("_", "-")
	if k:sub(1, 1) ~= "." and fs.access(file .. ".lmo") then
		o:value(k, v)
	end
end

function o.cfgvalue(...)
	return m.uci:get("luci", "main", "lang")
end

function o.write(self, section, value)
	m.uci:set("luci", "main", "lang", value)
end


o = s:taboption("language", ListValue, "_mediaurlbase", translate("Design"))
for k, v in pairs(conf.themes) do
	if k:sub(1, 1) ~= "." then
		o:value(v, k)
	end
end

function o.cfgvalue(...)
	return m.uci:get("luci", "main", "mediaurlbase")
end

function o.write(self, section, value)
	m.uci:set("luci", "main", "mediaurlbase", value)
end



return m
