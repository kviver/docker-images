FROM ubuntu:xenial-20190222

# common deps

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ARM toolchain

# TODO try cargo-binutils with llvm-tools-preview
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc-arm-none-eabi \
        gdb-arm-none-eabi \ 
        libnewlib-arm-none-eabi \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stable Rust

ARG KVIVER_STABLE_RUST_TOOLCHAIN="1.33.0"

RUN wget https://sh.rustup.rs -O /tmp/rustup-init && \
    bash /tmp/rustup-init --default-toolchain ${KVIVER_STABLE_RUST_TOOLCHAIN} -y && \
    rm /tmp/rustup-init

ENV PATH="/root/.cargo/bin:${PATH}"
ENV LD_LIBRARY_PATH="/root/.rustup/toolchains/${KVIVER_STABLE_RUST_TOOLCHAIN}-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib:${LD_LIBRARY_PATH}"

# Unstable Rust with rust-src and targets, for cross-compiling

ARG KVIVER_RUST_TOOLCHAIN="nightly-2019-03-20"
RUN rustup toolchain install ${KVIVER_RUST_TOOLCHAIN}
RUN rustup component add --toolchain ${KVIVER_RUST_TOOLCHAIN} rust-src
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv7em-none-eabihf

# rustfmt

RUN rustup component add rustfmt-preview

# bindgen deps

RUN apt-get update && apt-get install -y --no-install-recommends \
        clang-3.9 \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nRF5 SDK
# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK

# TODO merge this unzip with common deps
RUN apt-get update && apt-get install -y --no-install-recommends \
        unzip \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG KVIVER_NRF5_SDK="https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.0.0_a53641a.zip"

# TODO remove version from path
ARG KVIVER_NRF5_HOME="/opt/nRF5_SDK_15.0.0_a53641a"

RUN mkdir /tmp/nRF5_SDK && cd /tmp/nRF5_SDK && \
	wget ${KVIVER_NRF5_SDK} -O nRF5_SDK.zip && \
	unzip nRF5_SDK.zip && \
    rm -rf nRF5_SDK_15.0.0_a53641a/*.msi && \
    rm -rf nRF5_SDK_15.0.0_a53641a/examples && \
    mv nRF5_SDK_15.0.0_a53641a ${KVIVER_NRF5_HOME} && \
	cd / && rm -rf /tmp/nRF5_SDK

ARG ARM_GCC_TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2"

RUN mkdir /tmp/gcc-arm && \
    cd /tmp/gcc-arm && \
    wget ${ARM_GCC_TOOLCHAIN_URL} && \
    tar xf gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 && \
    mv gcc-arm-none-eabi-6-2017-q2-update /usr/local/ && \
    cd /tmp && \
    rm -rf /tmp/gcc-arm

# OpenOCD

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	    automake \
        autotools-dev \
        git \
        libtool \
        libusb-1.0-0-dev \
        pkg-config \
    && \
	mkdir /tmp/openocd && cd /tmp/openocd && \
	git clone http://openocd.zylin.com/openocd.git openocd && \
	cd openocd && \
	./bootstrap && \
	./configure --enable-stlink && \
	make && \
	make install && \
	cd / && rm -rf /tmp/openocd && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
