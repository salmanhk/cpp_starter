FROM fedora:38

RUN dnf -y update && dnf install -y \
    boost-devel \
    cmake \
    curl \
    gcc \ 
    g++ \ 
    git \
    ninja-build \
    tar \
    perl \
    perl-App-cpanminus \
    kernel-headers \
    unzip \ 
    zip 

WORKDIR /workspaces

RUN git clone https://github.com/microsoft/vcpkg.git && \
   ./vcpkg/bootstrap-vcpkg.sh -disableMetrics && \
   ./vcpkg/vcpkg integrate install

### DuckDB takes too long to compile in project via cmake. Also causes issues when linking
#   to precompiled binaries. Best to get it in docker step.
RUN curl -L -o duckdb.tar.gz https://github.com/duckdb/duckdb/archive/refs/tags/v0.9.1.tar.gz
RUN tar -xzf duckdb.tar.gz --strip-components=1
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install
RUN rm -rf /build

ENV VCPKG_ROOT=/workspaces/vcpkg
