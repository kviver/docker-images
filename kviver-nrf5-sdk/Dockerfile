FROM ubuntu:xenial-20180123

# common packages

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# nRF52 SDK

RUN apt-get update && apt-get install -y --no-install-recommends unzip && \
	mkdir /tmp/sdk && cd /tmp/sdk && \
	wget https://www.nordicsemi.com/eng/nordic/download_resource/59011/71/39504512/116085 -O sdk.zip && \
	unzip sdk.zip -d /opt/ && \
	cd /tmp && rm -rf /tmp/sdk && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# arm compiler

RUN mkdir /tmp/arm && cd /tmp/arm && \
	wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 && \ 
	tar jxvf gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 && \
	mv gcc-arm-none-eabi-6-2017-q2-update /usr/local/ && \
	cd /tmp && rm -rf /tmp/arm

# nRF5 OpenOCD

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	libtool autotools-dev automake pkg-config git libusb-1.0-0-dev && \
	\
	mkdir /tmp/openocd && cd /tmp/openocd && \
	git clone https://github.com/kviver/openocd.git && \
	cd openocd && \
	./bootstrap && \
	./configure --enable-stlink && \
	make && \
	make install && \
	cp nRF52832.cfg /usr/local/share/openocd/ && \
	\
	cd / && rm -rf /tmp/openocd && \
	apt-get remove -y autotools-dev automake pkg-config git && \
	apt-get autoremove -y && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*