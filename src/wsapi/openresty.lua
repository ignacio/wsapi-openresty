-- Hack
-- Provide a fake coxpcall module that does nothing, since coxpcall will
-- crash if pcall or xpcall is called.
package.preload.coxpcall = function()
	return {
		pcall = pcall,
		xpcall = xpcall,
		running = coroutine.running
	}
end

local common = require("wsapi.common")
local ngx = require("ngx")

local module = {}

local function get_cgivars (diskpath, path_info_pat, script_name_pat, extra_vars)
	diskpath = diskpath or ""
	local headers = ngx.req.get_headers()
	local cgivars = {
		SERVER_SOFTWARE   = "nginx",
		SERVER_NAME       = ngx.var.http_host,
		GATEWAY_INTERFACE = "CGI/1.1",
		SERVER_PROTOCOL   = "HTTP/1.1",
		SERVER_PORT       = ngx.var.server_port,
		REQUEST_METHOD    = ngx.var.request_method,
		DOCUMENT_ROOT     = diskpath,
		PATH_INFO         = string.match(ngx.var.uri, path_info_pat) or "",
		PATH_TRANSLATED   = script_name_pat and (diskpath .. script_name_pat),
		SCRIPT_NAME       = script_name_pat,
		QUERY_STRING      = ngx.encode_args(ngx.req.get_uri_args()),
		REMOTE_ADDR       = string.gsub(ngx.var.server_addr, ":%d*$", ""),
		CONTENT_TYPE      = headers["content-type"],
		CONTENT_LENGTH    = headers["content-length"],
	}
	if cgivars.PATH_INFO == "" then cgivars.PATH_INFO = "/" end
	for n,v in pairs(extra_vars or {}) do
		cgivars[n] = v
	end
	for n,v in pairs(headers) do
		cgivars ["HTTP_"..string.gsub (string.upper (n), "-", "_")] = v
	end
	return cgivars
end


local function wsapihandler (app_func, app_prefix, docroot, app_path, extra_vars)
	-- To build PATH_INFO
	local path_info_pat = "^" .. (app_prefix or "") .. "(.*)"
	local cgi_vars = get_cgivars(docroot, path_info_pat, app_prefix, extra_vars)

	local socket = ngx.req.socket()
	local input_stream = {
		read = function(_, n)
			-- see https://github.com/openresty/lua-nginx-module#tcpsockreceive
			return socket:receive(n)
		end
	}

	local output_stream = {
		write = function (_, data)
			return ngx.print(data)
		end
	}

	local error_stream = {
		write = function(_, ...)
			ngx.log(ngx.ERR, ...)
		end
	}

	local wsapi_env = common.wsapi_env({
	--local wsapi_env = {
		input       = input_stream,
		output = output_stream,
		error       = error_stream,
		env = cgi_vars,
	})
	wsapi_env.APP_PATH = app_path

	-- TODO: Fix orbit so I can just use common.run(wsapi_run, wsapi_env)

	local function set_status(status)
		status = (type(status) == "number" and status) or (type(status) == "string" and status:match("^(%d+)")) or 500
		ngx.status = status
	end

	local function send_headers(headers)
		for h, v in pairs(headers) do
			if type(v) == "table" then
				for _, value in ipairs(v) do
					ngx.header[h] = tostring(value)
				end
			else
				ngx.header[h] = v
			end
		end
	end

	--common.run(wsapi_run, wsapi_env)
	local ok, status, headers, res_iter = common.run_app(app_func, wsapi_env)
	if ok then
		set_status(status or 500)
		send_headers(headers or {})
		common.send_content(output_stream, res_iter)
	else
		if wsapi_env.STATUS == 404 then
			ngx.status = ngx.HTTP_NOT_FOUND
			send_headers({ ["Content-Type"] = "text/html", ["Content-Length"] = (status and #status) or 0 })
			ngx.print(status)
		else
			local content = common.error_html(status)
			ngx.status = 500
			send_headers({ ["Content-Type"] = "text/html", ["Content-Length"] = #content})
			ngx.print(content)
		end
	end
end

-- Makes a WSAPI handler for a single WSAPI application
function module.makeHandler (app_func, app_prefix, docroot, app_path, extra_vars)
	return function ()
		return wsapihandler(app_func, app_prefix, docroot, app_path, extra_vars)
	end
end

return module
