#!/bin/bash

mkdir git_cache; cd git_cache
git init --bare
git remote add rtems-source-builder https://github.com/thenewwazoo/rtems-source-builder.git
git remote add rtems-tools https://github.com/thenewwazoo/rtems-tools.git
git remote add rtems https://github.com/thenewwazoo/rtems.git

git fetch --all
