#!/bin/bash

VERSION=nrf5-2019-07-18

docker build -t kviver/sdk:${VERSION} ./kviver-sdk/
