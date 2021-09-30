#!/bin/bash
set +ex
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

echo "--------> Generating copy EFI blob to /boot/EFI"
BOOTDIR=${BASEPATH}/output/EFI/BOOT
mkdir -p ${BOOTDIR}/locale
pushd ${BOOTDIR}
wget https://download.opensuse.org/ports/aarch64/tumbleweed/repo/oss/EFI/BOOT/bootaa64.efi
wget https://download.opensuse.org/ports/aarch64/tumbleweed/repo/oss/EFI/BOOT/grub.efi
wget https://download.opensuse.org/ports/aarch64/tumbleweed/repo/oss/EFI/BOOT/MokManager.efi
cat <<EOF >"${BOOTDIR}/grub.cfg"
set btrfs_relative_path="yes"
search --no-floppy --label rootfs --set=root rootfs
set prefix=(\$root)/boot/grub2
configfile (\$root)/boot/grub2/grub.cfg
EOF
pushd locale
wget https://download.opensuse.org/ports/aarch64/tumbleweed/repo/oss/EFI/BOOT/locale/en.mo
popd && popd

echo "--------> Generating config.txt"
cat <<EOF > "${BASEPATH}/output/config.txt"
force_turbo=0
initial_turbo=30
over_voltage=0
dtoverlay=upstream
dtoverlay=smbios
arm_freq=840
core_frequ=375
sdram_freq=400
dtoverlay=vc4-kms-v3d
max_framebuffers=2
arm_64bit=1
gpu_mem=16
[all]
dtoverlay=gpio-fan,gpiopin=14,temp=80000
kernel=u-boot.bin
enable_uart=1
EOF
