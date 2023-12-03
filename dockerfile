# Use an Ubuntu base image
FROM ubuntu:latest

# Install LuaJIT and LuaRocks
RUN apt-get update && \
    apt-get install -y lua5.1 luarocks cmake build-essential git

# Set up LuaRocks for LuaJIT
# This assumes Lua 5.1 is compatible with LuaJIT for your needs
RUN luarocks install busted
RUN luarocks install lua-messagepack
RUN luarocks install redis-lua
RUN luarocks install luasocket
RUN luarocks install rapidjson