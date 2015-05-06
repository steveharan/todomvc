#!/bin/bash

git remote add current https://github.com/tastejs/todomvc.git && \
git fetch --quiet current && \
git diff HEAD origin/master --name-only |  awk 'BEGIN {FS = "/"}; {print $1 "/" $2 "/" $3}' | uniq | grep -v \/\/ | grep examples | awk -F '[/]' '{print "--framework=" $2}'
