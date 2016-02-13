# wsapi-openresty

A plugin for launching [WSAPI](http://keplerproject.github.io/wsapi/) applications on [OpenResty](https://openresty.org/).

# Installing

Install it with [LuaRocks](https://luarocks.org):

    luarocks install wsapi-openresty

# How to use

Take a look at the `samples` folder. There is an example configuration for _OpenResty_ that runs a simple _WSAPI_ application. To launch the example, first [install OpenResty](https://openresty.org/#Download).
Then open a shell and do the following:

~~~bash
cd samples
/path/to/openresty/nginx
~~~

Then navigate with your browser to [http://127.0.0.1:3000](http://127.0.0.1:3000).

For an example of an actual application, you can take a look at [SeeRedis](https://github.com/ignacio/seeredis).

The documentation about WSAPI is [here](http://keplerproject.github.io/wsapi/manual.html) and if you're looking for other applications, take a look at [Orbit](https://github.com/keplerproject/orbit), [Mercury](https://github.com/nrk/mercury) or [Sputnik](http://sputnik.freewisdom.org/).

# Author

Ignacio Burgueño - [@iburgueno](https://twitter.com/iburgueno) - https://uy.linkedin.com/in/ignacioburgueno

# License

MIT/X11

