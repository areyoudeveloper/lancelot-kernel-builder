apt-get install gcc-arm* gcc-aarch64-linux-gnu android-tools-mkbootimg bc bison build-essential ca-certificates cpio curl flex git kmod libssl-dev libtinfo5 python2 python python3 gcc g++ sudo unzip wget xz-utils -y --no-install-recommends
apt autoremove python && apt install python #fix DrvGen.py for gitpod.io
export ARCH=arm64
git clone https://github.com/areyoudeveloper1/android_kernel_xiaomi_mt6768/ -b eleven --depth 1
export TMP=/workspace/lancelot-kernel-builder/
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b pie-gsi --depth 1
export GCC_PATH="$TMP/aarch64-linux-android-4.9"
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b pie-gsi --depth 1
export GCC_ARM32_PATH="$TMP/arm-linux-androideabi-4.9"
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 -b android10-gsi --depth 1
export CLANG_PATH="$TMP/linux-x86/clang-r353983c"
export CC=clang 
export CLANG_TRIPLE=/usr/bin/aarch64-linux-gnu- 
export PATH="$CLANG_PATH/bin:$GCC_PATH/bin:$GCC_ARM32_PATH/bin:${PATH}"
git clone https://android.googlesource.com/platform/system/libufdt --depth 1
git clone https://android.googlesource.com/platform/external/dtc --depth 1
cat > Makefile <<'EOF'
CFLAGS = -Ilibufdt/include -Ilibufdt/sysdeps/include -Idtc/libfdt
OBJS_APPLY = libufdt/tests/src/util.o libufdt/tests/src/ufdt_overlay_test_app.o
OBJS_UFDT = libufdt/ufdt_convert.o libufdt/ufdt_node_pool.o libufdt/ufdt_prop_dict.o libufdt/ufdt_node.o libufdt/ufdt_overlay.o libufdt/sysdeps/libufdt_sysdeps_posix.o
OBJS_FDT = dtc/libfdt/fdt_addresses.o dtc/libfdt/fdt_overlay.o dtc/libfdt/fdt_strerror.o dtc/libfdt/fdt.o dtc/libfdt/fdt_ro.o dtc/libfdt/fdt_sw.o dtc/libfdt/fdt_empty_tree.o dtc/libfdt/fdt_rw.o dtc/libfdt/fdt_wip.o
all: ufdt_apply_overlay
ufdt_apply_overlay: $(OBJS_APPLY) $(OBJS_UFDT) $(OBJS_FDT)
	$(CC) -o $@ $(LDFLAGS) $(OBJS_APPLY) $(OBJS_UFDT) $(OBJS_FDT)
clean:
	$(RM) ufdt_apply_overlay $(OBJS_APPLY) $(LDFLAGS) $(OBJS_UFDT) $(OBJS_FDT)
EOF

make ufdt_apply_overlay
cd $TMP && cd android_kernel_xiaomi_mt6768
mkdir out
export CROSS_COMPILE="/usr/bin/aarch64-linux-android-"
export CROSS_COMPILE_ARM32="/usr/bin/arm-linux-androideabi-"
make O=out lancelot_defconfig
make O=out CC=$CC -j$(nproc --all)
