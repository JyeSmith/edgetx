#!/bin/bash

# Stops on first error, echo on
set -e
set -x

# Add GCC_ARM to PATH
if [[ -n ${GCC_ARM} ]] ; then
  export PATH=${GCC_ARM}:$PATH
fi

: ${FLAVOR:="t12;t8;tlite;tx12;tx16s;x12s;nv14;x7;x9d;x9dp;x9e;x9lite;x9lites;xlite;xlites"}
: ${SRCDIR:=$(dirname $(pwd)/"$0")/..}

: ${COMMON_OPTIONS:="-DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_RULE_MESSAGES=OFF -DDISABLE_COMPANION=YES -Wno-dev -DYAML_STORAGE=YES "}

# wipe build directory clean
rm -rf build && mkdir -p build && cd build

target_names=$(echo "$FLAVOR" | tr '[:upper:]' '[:lower:]' | tr ';' '\n')

for target_name in $target_names
do
    BUILD_OPTIONS=${COMMON_OPTIONS}

    echo "Generating YAML structures for ${target_name}"
    case $target_name in

        x9lite)
            BUILD_OPTIONS+="-DPCB=X9LITE"
            ;;
        x9lites)
            BUILD_OPTIONS+="-DPCB=X9LITES"
            ;;
        x7)
            BUILD_OPTIONS+="-DPCB=X7"
            ;;
        x7-access)
            BUILD_OPTIONS+="-DPCB=X7 -DPCBREV=ACCESS -DPXX1=YES"
            ;;
        t12)
            BUILD_OPTIONS+="-DPCB=X7 -DPCBREV=T12 -DINTERNAL_MODULE_MULTI=ON"
            ;;
        tx12)
            BUILD_OPTIONS+="-DPCB=X7 -DPCBREV=TX12"
            ;;
        t8)
            BUILD_OPTIONS+="-DPCB=X7 -DPCBREV=T8"
            ;;
        tlite)
            BUILD_OPTIONS+="-DPCB=X7 -DPCBREV=TLITE"
            ;;
        xlite)
            BUILD_OPTIONS+="-DPCB=XLITE"
            ;;
        xlites)
            BUILD_OPTIONS+="-DPCB=XLITES"
            ;;
        x9d)
            BUILD_OPTIONS+="-DPCB=X9D"
            ;;
        x9dp)
            BUILD_OPTIONS+="-DPCB=X9D+"
            ;;
        x9dp2019)
            BUILD_OPTIONS+="-DPCB=X9D+ -DPCBREV=2019"
            ;;
        x9e)
            BUILD_OPTIONS+="-DPCB=X9E"
            ;;
        x10)
            BUILD_OPTIONS+="-DPCB=X10"
            ;;
        x10-access)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=EXPRESS -DPXX1=YES"
            ;;
        x12s)
            BUILD_OPTIONS+="-DPCB=X12S"
            ;;
        t16)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=T16 -DINTERNAL_MODULE_MULTI=ON"
            ;;
        t16-fs)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=T16 -DINTERNAL_MODULE_MULTI=ON -DFLYSKY_HALL_STICKS=ON"
            ;;
        t18)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=T18"
            ;;
        t18-fs)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=T18 -DFLYSKY_HALL_STICKS=ON"
            ;;
        tx16s)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=TX16S -DINTERNAL_GPS=ON"
            ;;
        tx16s-fs)
            BUILD_OPTIONS+="-DPCB=X10 -DPCBREV=TX16S -DFLYSKY_HALL_STICKS=ON"
            ;;
        nv14)
            BUILD_OPTIONS+="-DPCB=NV14"
            ;;
    esac

    cmake ${BUILD_OPTIONS} "${SRCDIR}"
    make yaml_data

    rm -f CMakeCache.txt
done
