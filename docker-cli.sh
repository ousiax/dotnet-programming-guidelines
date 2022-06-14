#!/bin/sh

docker run -it --rm -p 40000:4000 -v $PWD:/book -w /book -u $(id -u) qqbuby/gitbook:3.2 bash
