# masquerade-server-docker

Docker container for the masquerade connect-ip server.

The container needs the NET_ADMIN and SYS_MODULE caps, and also the enable the sysctls:

```
net.ipv4.conf.all.src_valid_mark=1
net.ipv4.ip_forward=1
```

In addition to that it needs a rw volume mounted to `/config`.
You can place your `server-config.toml` in there, if the server doesn't find one it will copy a working standard config in there.

Example docker-compose.yml:
```docker-compose
services:
  masquerade_server:
    image: masq_server
    container_name: masquerade_server
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /home/dockeruser/masquerade-docker/config:/config:rw
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    ports:
      - "4433:4433/udp"
    restart: unless-stopped
```

Example with a static docker network ip:

```docker-compose
services:
  masquerade_server:
    image: masq_server
    container_name: masquerade_server
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /home/dockeruser/masquerade-docker/config:/config:rw
    networks:
      default:
        ipv4_address: 172.20.0.50
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    ports:
      - "4433:4433/udp"
    restart: unless-stopped
networks:
  default:
    name: masqNet
    external: true
```