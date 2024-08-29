#!/bin/bash

# Ensure the /dev/net/tun device exists
if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
    chmod 600 /dev/net/tun
fi

# Find the name of the network interface of the container
INTERFACE_NAME=$(ip -o -4 route show to default | awk '{print $5}')

cp -n ./server_config.toml /config/server_config.toml
mkdir /config/qlog/

# Run the Rust program with the detected network interface name
RUST_LOG=error /usr/local/bin/server --local_uplink_device_name "$INTERFACE_NAME" --interface_name tun
