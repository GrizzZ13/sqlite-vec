#!/bin/bash

current_dir=$(pwd)
rm -rf $current_dir/vendor
rm -rf $current_dir/sqlite-autoconf-3450300

tar -xvzf $current_dir/sqlite-autoconf-3450300.tar.gz
cd $current_dir/sqlite-autoconf-3450300

./configure --prefix=$current_dir/vendor
make
make install
