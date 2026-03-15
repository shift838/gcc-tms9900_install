#!/bin/bash

#SHIFT838 tms9900-gcc Installation Script Version 1.0
#This version uses current gcc Installation script and older libti99 from Tursi

set -e

# Trap any error and print a clean message
trap 'echo; echo "❌ Installation failed. See the error above."; exit 1' ERR

# Update and install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y build-essential libgmp-dev libmpfr-dev unzip git wget make
echo "Dependencies installation complete."
echo

# Create working directory
echo "Creating work directory..."
mkdir -p ~/work
cd ~/work
WORK=$(pwd)
echo "Work directory created."
echo

# Download and extract GCC installer
echo "Downloading GCC installer..."
wget "https://raw.githubusercontent.com/<your-username>/GCC-tms9900_install/main/gcc-installer.tar.gz" -O gcc-installer.tar.gz
echo "Extracting GCC installer..."
tar -xvzf gcc-installer.tar.gz
echo

# Download and apply GCC10 patch
echo "Downloading GCC10 patch..."
wget "https://raw.githubusercontent.com/<your-username>/GCC-tms9900_install/main/gcc10-patch.zip" -O gcc10-patch.zip
echo "Extracting GCC10 patch..."
unzip -xo gcc10-patch.zip
echo

# Run installer
echo "Installing GCC for TMS9900... This may take a while..."
chmod +x install.sh
mkdir -p ~/tms9900gcc
./install.sh ~/tms9900gcc
echo "GCC TMS9900 installed."
echo

# Build elf2ea5
echo "Installing elf2ea5..."
cd "$WORK"
wget "https://raw.githubusercontent.com/<your-username>/GCC-tms9900_install/main/elf2ea5.tar.gz" -O elf2ea5.tar.gz
mkdir -p elf2ea5
cd elf2ea5
echo "Extracting elf2ea5..."
tar -xvzf ../elf2ea5.tar.gz
echo "Building elf2ea5 binary..."
make
echo "Copying elf2ea5 to ~/tms9900gcc/bin/"
cp elf2ea5 ~/tms9900gcc/bin/
echo "elf2ea5 installed."
echo

# Build ea5split
echo "Installing ea5split..."
cd "$WORK"
wget "https://raw.githubusercontent.com/<your-username>/GCC-tms9900_install/main/ea5split3.zip" -O ea5split3.zip
echo "Extracting ea5split..."
unzip ea5split3.zip
cd ea5split
echo "Building ea5split binary..."
make
cp ea5split ~/tms9900gcc/bin/
echo "ea5split installed."
echo

# Build elf2cart
echo "Installing elf2cart..."
cd "$WORK"
wget "https://raw.githubusercontent.com/<your-username>/GCC-tms9900_install/main/elf2cart.tar.gz" -O elf2cart.tar.gz
mkdir -p elf2cart
cd elf2cart
echo "Extracting elf2cart..."
tar -xvzf ../elf2cart.tar.gz
echo "Building elf2cart binary..."
make
cp elf2cart ~/tms9900gcc/bin/
echo "elf2cart installed."
echo

# Clone libraries and projects
echo "Cloning libti99 library and 32kmemtest project..."
cd ~
git clone https://github.com/tursilion/libti99.git || true
git clone https://github.com/jedimatt42/ti994a-32kmemtest.git || true
echo "Clone complete."
echo

# Export environment variables
echo "Setting up environment variables..."
echo 'export PATH=~/tms9900gcc/bin:$PATH' >> ~/.bashrc
echo 'export LIBTI99=~/libti99' >> ~/.bashrc
echo "Environment variable setup complete."
echo

# Reloading environment variables (only affects this script)
echo "Reloading environment variables..."
source ~/.bashrc
echo

# Build memory tester instructions
echo "To build the 32kmemtest project:"
echo "1. Edit Makefile and point LIBTI99 to /home/USERNAME/libti99"
echo "2. cd ~/ti994a-32kmemtest"
echo "3. make"
echo

# Success message (only prints if NO errors occurred)
echo "✔ TMS9900 GCC toolchain installation completed successfully."
echo "Restart your terminal or run: source ~/.bashrc"
echo
