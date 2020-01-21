#!/bin/sh

gitbook install \
    && gitbook build \
    && git checkout gh-pages \
    && cp _book/* . -r
