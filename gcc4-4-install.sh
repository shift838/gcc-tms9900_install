#!/bin/bash

# SHIFT838 TMS9900 GCC 4.4.0 Installation Script
# Version 1.6 – Switched to libTi99All and updated environment exports

set -e

trap 'echo; echo "❌ Installation failed. See the error above."; exit 1' ERR

echo "Installing dependencies..."
sudo apt update
sudo apt install -y build-essential libgmp-dev libmpfr-dev unzip git wget make texinfo bzip2
echo "Dependencies installed."
echo

echo "Creating work directory..."
mkdir -p ~/work
cd ~/work
WORK=`pwd`
echo "Work directory: $WORK"
echo

PREFIX="$HOME/tms9900gcc"
mkdir -p "$PREFIX"

# ---------------------------------------------------------
# 1. Download and build BINUTILS 2.19.1
# ---------------------------------------------------------
echo "Downloading binutils 2.19.1..."
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/binutils-2.19.1.tar.bz2 -O binutils-2.19.1.tar.bz2

echo "Extracting binutils..."
tar -xvjf binutils-2.19.1.tar.bz2

echo "Downloading binutils TMS9900 patch 1.11..."
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/binutils-2.19.1-tms9900-1.11.patch -O binutils.patch

echo "Applying binutils patch..."
cd binutils-2.19.1
patch -p1 < ../binutils.patch
cd "$WORK"
echo "Binutils patch applied."
echo

echo "Configuring binutils..."
mkdir -p build-binutils
cd build-binutils

../binutils-2.19.1/configure \
    --target=tms9900-unknown-elf \
    --prefix="$PREFIX" \
    --disable-nls

echo "Building binutils..."
make CFLAGS="-Wno-error"
make install

echo "Binutils installed."
echo

# ---------------------------------------------------------
# 2. Download and extract GCC 4.4.0
# ---------------------------------------------------------
cd "$WORK"
echo "Downloading GCC 4.4.0..."
wget https://ftp.gnu.org/gnu/gcc/gcc-4.4.0/gcc-4.4.0.tar.gz -O gcc-4.4.0.tar.gz

echo "Extracting GCC..."
tar -xvzf gcc-4.4.0.tar.gz
cd gcc-4.4.0
echo

# ---------------------------------------------------------
# 3. Apply TMS9900 patch
# ---------------------------------------------------------
echo "Downloading TMS9900 Patch 1.32..."
cd "$WORK"
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/gcc-4.4.0-tms9900-1.32.patch -O tms9900.patch

echo "Applying GCC patch..."
cd gcc-4.4.0
patch -p1 < ../tms9900.patch
echo "Patch applied."
echo

# ---------------------------------------------------------
# 4. Configure and build GCC 4.4.0
# ---------------------------------------------------------
echo "Configuring GCC for TMS9900..."

export MAKEINFO=true

./configure \
    --target=tms9900-unknown-elf \
    --prefix="$PREFIX" \
    --disable-nls \
    --disable-libssp \
    --disable-shared \
    --disable-threads \
    --enable-languages=c

echo "Building GCC (this will take a while)..."
make all-gcc
make install-gcc

echo "GCC installed."
echo

# ---------------------------------------------------------
# 5. Build elf2ea5
# ---------------------------------------------------------
cd "$WORK"
echo "Installing elf2ea5..."
wget https://raw.githubusercontent.com/shift838/GCC-tms9900_install/main/elf2ea5.tar.gz -O elf2ea5.tar.gz

mkdir -p elf2ea5
cd elf2ea5
tar -xvzf ../elf2ea5.tar.gz
make
cp elf2ea5 "$PREFIX/bin/"
echo "elf2ea5 installed."
echo

# ---------------------------------------------------------
# 6. Build ea5split
# ---------------------------------------------------------
cd "$WORK"
echo "Installing ea5split..."
wget https://raw.githubusercontent.com/shift838/GCC-tms9900_install/main/ea5split3.zip -O ea5split3.zip

unzip -o ea5split3.zip
cd ea5split
make
cp ea5split "$PREFIX/bin/"
echo "ea5split installed."
echo

# ---------------------------------------------------------
# 7. Build elf2cart
# ---------------------------------------------------------
cd "$WORK"
echo "Installing elf2cart..."
wget https://raw.githubusercontent.com/shift838/GCC-tms9900_install/main/elf2cart.tar.gz -O elf2cart.tar.gz

mkdir -p elf2cart
cd elf2cart
tar -xvzf ../elf2cart.tar.gz
make
cp elf2cart "$PREFIX/bin/"
echo "elf2cart installed."
echo

# -------------------------------------------------------------------------------------
# 8. Download libraries and 838 Memory Tester Project (libTi99All + 838-ti994a-memtest)
# -------------------------------------------------------------------------------------
echo "Downloading libTi99All and 838-ti994a-memtest..."
cd ~

# --- libTi99All (tursilion fork, branch: main) ---
wget https://github.com/tursilion/libTi99All/archive/refs/heads/main.zip -O libTi99All.zip
unzip -o libTi99All.zip
rm -f libTi99All.zip
mv libTi99All-main libTi99All 2>/dev/null || true

# --- 838-ti994a-memtest (branch: main) ---
wget https://github.com/shift838/838-ti994a-memtest/archive/refs/heads/main.zip -O memtest.zip
unzip -o memtest.zip
rm -f memtest.zip
mv 838-ti994a-memtest-main 838-ti994a-memtest 2>/dev/null || true

echo "Libraries and 838-ti994a-memtest downloaded and extracted."
echo

# ---------------------------------------------------------
# 9. Environment variables
# ---------------------------------------------------------
echo "Setting environment variables..."

# Add bin path
if ! grep -q "tms9900gcc/bin" ~/.bashrc; then
    echo 'export PATH=~/tms9900gcc/bin:$PATH' >> ~/.bashrc
fi

# Add New libTi99All path
if ! grep -q "LIBTI99ALL" ~/.bashrc; then
    echo 'export LIBTI99ALL=~/libTi99All' >> ~/.bashrc
fi

echo "Environment variables added."
echo

echo "Reloading environment..."
# Note: source only works in the current script context; 
# User must still run 'source ~/.bashrc' manually after script ends.
source ~/.bashrc || true
echo

echo "✔ TMS9900 GCC 4.4.0 toolchain installation completed successfully."
echo

echo "Verifying TMS9900 GCC installation..."
$PREFIX/bin/tms9900-unknown-elf-gcc -v
echo 
echo "Before bulding the test project, you will need to build the libTi99All library."
echo "Perform the below..."
echo
echo "cd ~/libTi99All"
echo "nano ./Makefile.ti99"
echo "Update the Paths to:"
echo
echo "TMS9900_DIR?=$(HOME)/tms9900gcc/bin"
echo "ELF2EA5_DIR?=$(HOME)/tms9900gcc/bin"
echo
echo "Update path to executables:"
echo
echo "GAS=$(TMS9900_DIR)/tms9900-unknown-elf-as"
echo "LD=$(TMS9900_DIR)/tms9900-unknown-elf-ld"
echo "CC=$(TMS9900_DIR)/tms9900-unknown-elf-gcc"
echo "AR=$(TMS9900_DIR)/tms9900-unknown-elf-ar"
echo "Save your changes!"
echo
echo "Issue the commands below to compile and copy the required file."
echo "make clean"
echo "rm -rf buildti"
echo "make ti"
echo "cp /buildti/libti99.a ."
echo
echo "You will be ready to compile the 838-ti994a-memteset project."
echo
echo "Happy coding!!!"

