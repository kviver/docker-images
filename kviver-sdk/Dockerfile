FROM ubuntu:xenial-20190222

# common deps

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# non-root user

RUN addgroup --gid 1000 developer && \
    adduser --uid 1000 --ingroup developer --home /home/developer --shell /bin/sh --disabled-password --gecos "" developer

# ARM toolchain

# TODO try cargo-binutils with llvm-tools-preview
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc-arm-none-eabi \
        gdb-arm-none-eabi \ 
        libnewlib-arm-none-eabi \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stable Rust

USER developer:developer

ARG KVIVER_STABLE_RUST_TOOLCHAIN="1.33.0"

RUN wget https://sh.rustup.rs -O /tmp/rustup-init && \
    bash /tmp/rustup-init --default-toolchain ${KVIVER_STABLE_RUST_TOOLCHAIN} -y && \
    rm /tmp/rustup-init

ENV PATH="/home/developer/.cargo/bin:${PATH}"
ENV LD_LIBRARY_PATH="/root/.rustup/toolchains/${KVIVER_STABLE_RUST_TOOLCHAIN}-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib:${LD_LIBRARY_PATH}"

# Unstable Rust with rust-src and targets, for cross-compiling

ARG KVIVER_RUST_TOOLCHAIN="nightly-2019-03-20"
RUN rustup toolchain install ${KVIVER_RUST_TOOLCHAIN}
# TODO maybe rust-src is unnecessary
RUN rustup component add --toolchain ${KVIVER_RUST_TOOLCHAIN} rust-src
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv6m-none-eabi
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv7em-none-eabi
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv7em-none-eabihf
RUN rustup target add --toolchain ${KVIVER_RUST_TOOLCHAIN} thumbv7m-none-eabi

# clippy

RUN rustup component add clippy 
RUN rustup component add clippy --toolchain ${KVIVER_RUST_TOOLCHAIN}

# rustfmt

RUN rustup component add rustfmt 
RUN rustup component add rustfmt --toolchain ${KVIVER_RUST_TOOLCHAIN}

# cargo tree

USER root:root
# TODO merge all apt-get
RUN apt-get update && apt-get install -y --no-install-recommends \
        libssl-dev \
        pkg-config \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER developer:developer

RUN cargo install cargo-tree

# cargo expand

RUN cargo install cargo-expand

# cargo call stack

RUN cargo install cargo-call-stack

# bindgen deps

USER root:root
# TODO merge all apt-get
RUN apt-get update && apt-get install -y --no-install-recommends \
        clang-3.9 \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER developer:developer

# nRF5 SDK
# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK

USER root:root

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

USER developer:developer

# fixuid to help with dev environment
# TODO move this section to separate image, to use clean image in `docker run -it --rm kviver/sdk` as a fast path for debug, and fixuid image in compose

USER root:root
RUN curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid
USER developer:developer

ENTRYPOINT ["fixuid"]
CMD ["bash"]
