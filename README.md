# wsapi-openresty

A plugin for launching [WSAPI](http://keplerproject.github.io/wsapi/) applications on [OpenResty](https://openresty.org/).

# Installing

Install it with [LuaRocks](https://luarocks.org):

    luarocks install wsapi-openresty

# How to use

Take a look at the `samples` folder. There is an example configuration for _OpenResty_ that runs a simple _WSAPI_ application. To launch the example, do the following on a shell:

~~~bash
cd samples
/path/to/openresty/nginx
~~~

Then navigate with your browser to [http://127.0.0.1:3000](http://127.0.0.1:3000).

For an example of an actual application, you can take a look at [SeeRedis](https://github.com/ignacio/seeredis).

# Author

Ignacio Burgueño - [@iburgueno](https://twitter.com/iburgueno) - https://uy.linkedin.com/in/ignacioburgueno

# License

MIT/X11

