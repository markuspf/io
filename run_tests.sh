#!/bin/sh

mkdir tmp
cd tmp

case $1 in
    gap)
        git clone --depth=50 https://github.com/gap-system/gap.git gap
        cd gap  
        ./configure --with-gmp=system
        make
        mkdir pkg
        cd pkg
        wget ftp://ftp.gap-system.org/pub/gap/gap47/tar.gz/packages/GAPDoc-1.5.1.tar.gz
        tar xvzf GAPDoc-1.5.1.tar.gz > /dev/null
        ln -s ../.. io
        cd io
        ./configure
        make
        ;;
    hpcgap)
        git clone --depth=50 https://github.com/gap-system/gap.git gap
        cd gap
        git checkout hpcgap-default
        ./make.hpc
        cd pkg
        ln -s ../.. io
        cd io
        ./configure CFLAGS="`cat ../../build/cflags`"
        make
    ;;
esac
echo "Read(\"tst/testall.g\"); quit;" | sh bin/gap.sh | tee testlog.txt | grep --colour=always -E "########> Diff|$"
( ! grep "########> Diff" testlog.txt )
