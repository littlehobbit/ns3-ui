FROM ubuntu:focal as build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y g++ make cmake libboost-dev \
  libfmt-dev libtinyxml-dev libtinyxml2-dev gzip python3

## Install simulation-core dependencies
COPY deps /app/deps

# Install CLI11
WORKDIR /app/deps
RUN tar -xf cli11-v2.3.2.tar.gz
WORKDIR /app/deps/cli11-v2.3.2/build
RUN cmake -DCLI11_BUILD_TESTS=OFF -DCLI11_BUILD_DOCS=OFF -DCLI11_BUILD_EXAMPLES=OFF .. \
  && cmake --build . --target install

# Install NS-3
WORKDIR /app/deps
RUN tar -xf ns-3-dev-ns-3.38.tar.gz
WORKDIR /app/deps/ns-3-dev-ns-3.38/build
RUN cmake  .. && cmake --build . --target install --parallel `nproc --ignore=1`

# Install tinyxml2
WORKDIR /app/deps
RUN tar -xf tinyxml2-master.tar.gz
WORKDIR /app/deps/tinyxml2-master/build
RUN cmake -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF .. \
  && cmake --build . --target install --parallel `nproc --ignore=1`

# Build simulation-core
WORKDIR /app
COPY simulation-core simulation-core

WORKDIR /app/simulation-core/build
RUN cmake .. && cmake --build . --target simulation --parallel

## Create target image
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y python3 python3-pip

# Copy artifacts from build step
WORKDIR /app/core
COPY --from=build /usr/local/lib/libns3*.so             /usr/local/lib/
COPY --from=build /app/simulation-core/build/simulation .

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/
ENV SIMULATION_EXECUTABLE=/app/core/simulation

# Copy server
COPY server /app/server
WORKDIR /app/server 

# Install server dependencies
RUN pip install -r requirements.txt
