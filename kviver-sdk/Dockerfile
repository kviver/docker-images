FROM ubuntu:xenial-20180123

# common deps

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ARM toolchain

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc-arm-none-eabi \
        gdb-arm-none-eabi \ 
        libnewlib-arm-none-eabi \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# stlink

RUN apt-get update && apt-get install -y --no-install-recommends \
        cmake \
        libusb-1.0-0-dev \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG KVIVER_STLINK_VERSION="1.4.0"

RUN mkdir /tmp/stlink && cd /tmp/stlink && \
    wget https://github.com/texane/stlink/archive/${KVIVER_STLINK_VERSION}.tar.gz && \
    tar xvf ${KVIVER_STLINK_VERSION}.tar.gz && cd stlink-${KVIVER_STLINK_VERSION} && \
    make release && cd build/Release && make install && \
    cd / && rm -rf /tmp/stlink

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

# Rust

ARG KVIVER_RUST_TOOLCHAIN="nightly-2018-06-04"

RUN wget https://sh.rustup.rs -O /tmp/rustup-init && \
    bash /tmp/rustup-init --default-toolchain ${KVIVER_RUST_TOOLCHAIN} -y && \
    rm /tmp/rustup-init

ENV PATH="/root/.cargo/bin:${PATH}"
ENV LD_LIBRARY_PATH="/root/.rustup/toolchains/${KVIVER_RUST_TOOLCHAIN}-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib:${LD_LIBRARY_PATH}"

# rust-src and targets, for cross-compiling

RUN rustup component add --toolchain ${KVIVER_RUST_TOOLCHAIN} rust-src
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv7em-none-eabihf

# rustfmt

RUN rustup component add rustfmt-preview

# bindgen deps

RUN apt-get update && apt-get install -y --no-install-recommends \
        clang-3.9 \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
