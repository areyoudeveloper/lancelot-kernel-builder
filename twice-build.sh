apt-get install gcc-arm* gcc-aarch64-linux-gnu android-tools-mkbootimg bc bison build-essential ca-certificates cpio curl flex git kmod libssl-dev libtinfo5 python2 python python3 gcc g++ sudo unzip wget xz-utils -y --no-install-recommends
apt autoremove python && apt install python #fix DrvGen.py for gitpod.io
export ARCH=arm64
export TMP=/workspace/lancelot-kernel-builder/
export GCC_PATH="$TMP/aarch64-linux-android-4.9"
export GCC_ARM32_PATH="$TMP/arm-linux-androideabi-4.9"
export CLANG_PATH="$TMP/linux-x86/clang-r353983c"
export CC=clang 
export CLANG_TRIPLE=/usr/bin/aarch64-linux-gnu- 
export PATH="$CLANG_PATH/bin:$GCC_PATH/bin:$GCC_ARM32_PATH/bin:${PATH}"
cd $TMP && cd android_kernel_xiaomi_mt6768
mkdir out
export CROSS_COMPILE="/usr/bin/aarch64-linux-android-"
export CROSS_COMPILE_ARM32="/usr/bin/arm-linux-androideabi-"
make O=out lancelot_defconfig
make O=out CC=$CC -j$(nproc --all)
