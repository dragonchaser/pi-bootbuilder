#!/bin/bash
BASEPATH=/data
echo "--------> Running pi-bootbuilder"
echo "--------> Cleaning output volume"
rm -Rfv "${BASEPATH}"/output/*

echo "--------> Copying firmware to output volume"
cp -Rfv "${BASEPATH}"/firmware/boot/* output/

echo "--------> Build u-boot"
export CROSS_COMPILE=aarch64-linux-gnu-
pushd u-boot
echo "==============> MAKE: distclean"
make distclean
echo "==============> MAKE: pi4 defconfig"
make rpi_4_defconfig
echo "==============> MAKE: u-boot.bin"
make u-boot.bin
echo "==============> copy u-boot.bin to ${BASEPATH}/output"
cp u-boot.bin ../output
popd

echo "--------> Generating config.txt"
cat <<EOF > "${BASEPATH}/output/config.txt"
dtoverlay=vc4-kms-v3d
max_framebuffers=2
arm_64bit=1
gpu_mem=16
[all]
dtoverlay=gpio-fan,gpiopin=14,temp=80000
kernel=u-boot.bin
enable_uart=1
EOF
