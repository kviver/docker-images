#!/bin/bash

VERSION=nrf5-2019-03-21

docker build -t kviver/sdk:${VERSION} ./kviver-sdk/
