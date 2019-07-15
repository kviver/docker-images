#!/bin/bash

VERSION=nrf5-2019-07-15

docker build -t kviver/sdk:${VERSION} ./kviver-sdk/
