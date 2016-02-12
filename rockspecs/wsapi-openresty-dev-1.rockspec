package = "WSAPI-OpenResty"

version = "dev-1"

description = {
	summary = "Lua Web Server API - OpenResty Handler",
	detailed = [[
		WSAPI is an API that abstracts the web server from Lua web applications. This is the rock
		that contains the Openresty adapter.
	]],
	license = "MIT/X11",
	homepage = "http://github.com/ignacio/wsapi-openresty"
}

dependencies = { "lua >= 5.1", "wsapi >= 1.6.1" }

source = {
	url = "git://github.com/ignacio/wsapi-openresty",
	tag = "master"
}

build = {
	type = "builtin",
	modules = {
		["wsapi.openresty"] = "src/wsapi/openresty.lua"
	}
}
