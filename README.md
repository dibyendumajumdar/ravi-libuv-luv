luv - Libuv bindings for Ravi / Lua 5.3
=======================================

This library makes libuv available to lua scripts.  It was made for the [luvit](http://luvit.io/) project but should usable from nearly any lua project. 

The library can be used by multiple threads at once.  Each thread is assumed to load the library from a different `lua_State`.  Luv will create a unique `uv_loop_t` for each state.  You can't share uv handles between states/loops.

The best docs currently are the [libuv docs](http://docs.libuv.org/) themselves.  Hopfully soon we'll have a copy locally tailored for lua.

```lua
local uv = require('luv')

-- Create a handle to a uv_timer_t
local timer = uv.new_timer()

-- This will wait 1000ms and then continue inside the callback
timer:start(1000, 0, function ()
  -- timer here is the value we passed in before from new_timer.

  print ("Awake!")

  -- You must always close your uv handles or you'll leak memory
  -- We can't depend on the GC since it doesn't know enough about libuv.
  timer:close()
end)

print("Sleeping");

-- uv.run will block and wait for all events to run.
-- When there are no longer any active handles, it will return
uv.run()
```


Here is an example of an TCP echo server
```lua
local uv = require('luv')

local function create_server(host, port, on_connection)

  local server = uv.new_tcp()
  server:bind(host, port)

  server:listen(128, function(err)
    -- Make sure there was no problem setting up listen
    assert(not err, err)

    -- Accept the client
    local client = uv.new_tcp()
    server:accept(client)

    on_connection(client)
  end)

  return server
end

local server = create_server("0.0.0.0", 0, function (client)

  client:read_start(function (err, chunk)

    -- Crash on errors
    assert(not err, err)

    if chunk then
      -- Echo anything heard
      client:write(chunk)
    else
      -- When the stream ends, close the socket
      client:close()
    end
  end)
end)

print("TCP Echo server listening on port " .. server:getsockname().port)

uv.run()
```

More examples can be found in the [examples](examples) and [tests](tests) folders.

## Running tests

Set the Suravi environment variables.
Cd to the `ravi-libuv-luv` folder.

```
ravi tests/run.lua
```

## Building From Source

See the Suravi project for how this is built.
The main thing to note is that we use externally provided libuv library.

