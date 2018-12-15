#!/bin/bash

VERSION=nrf5-2018-12-15

docker build -t kviver/sdk:${VERSION} ./kviver-sdk/
