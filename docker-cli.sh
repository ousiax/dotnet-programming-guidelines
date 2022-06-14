#!/bin/sh

docker run -it --rm -v $PWD:/book -w /book -u $(id -u) qqbuby/gitbook:3.2 bash
