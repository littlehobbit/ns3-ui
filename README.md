# ns-3 wrapper
This is superproject repo for ns-3 wrapper applications that automize creation of network models. App provides:
    - UI interface for topology
    - HTTP API to start simulations

## Installation
Clone this repository with `--recurse-submodules` to install from sources.

```bash
git clone --recurse-submodules https://github.com/littlehobbit/ns3-wrapper.git 
```

Then install submodules from sources (see 'README.md' files) or create docker image:
```bash
bash ./build-docker.sh
```
This action will create `ns3-server:latest` docker image with installed simulation core and server.

## How to use
# server (with docker-compose)
Use `docker-compose.yaml` file to run server with docker-compose.
```bash
docker-compose up -d
```

Enviroment parameters:
- `NS3_SERVER_HOST` - ip address to bind server (by default is `0.0.0.0`)
- `NS3_SERVER_PORT` - server port (by default is `8000`)
- `SIMULATION_EXECUTABLE` - path to simulation binary (by default is `/app/core/simulation`)
- `FTP_SERVER` - address of FTP result's storage
- `FTP_USER` - FTP login
- `FTP_PASSWORD` - FTP passwod

# client
See `client/README.md` file.