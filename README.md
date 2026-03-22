# TMS9900 GCC Toolchain Installer

This repository provides a fully automated installer for building and configuring the GCC-based TMS9900 cross‑compiler toolchain (using GCC 4.4.0) along with several essential TI‑99/4A utilities including Tursi's libTi99All library. It is designed for Linux and WSL (Ubuntu recommended) and sets up everything needed to compile TI‑99/4A software using a modern GCC toolchain.

This script has been tested on realy Ubuntu 20, 24.04 linux machines as well as WSL (Windows Subsystem for Linux) with Ubuntu 24.04 installed.

You may **download and run the installer script directly** without cloning this repository.

---

## 🚀 Quick Install (No Repo Clone Required)

You can install the entire TMS9900 GCC toolchain by downloading the installer script and running it.

***There will be 100's of warnings, don't panic, just ignore them.

### 1. cd to home directory
cd ~

### 2. Download the installer script
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/install-gcc-tms9900.sh

### 3. Run the installer
bash ./install-gcc-tms9900.sh

# What the Installer Sets Up

The script performs a complete toolchain setup:

- Installs required system packages
- Creates a working directory for all build operations
- Downloads and extracts:
  - gcc-4.4.0.tar.gz
- Downloads gcc-4.4.0-tms9900-1.32.patch
- Builds GCC 4.4.0
- Installs the GCC 4.4.0 TMS9900 1.32 patch
- Builds and installs:
  - binutils
  - elf2ea5
  - ea5split
  - elf2cart
- Installs binutils 1.11 patch
- Clones:
  - Tursilion’s TI‑99 support library (libTi99All)
  - SHIFT838’s 838-ti994a-memtest repository
- Adds required environment variables to `.bashrc`:
  - `PATH=~/tms9900gcc/bin:$PATH`
  - `LIBTI99ALL=~/libTi99All`
- Automatically patches Makefile.ti99 for correct paths
- Builds libTi99All and copies `libti99.a` into place
- Provides instructions for building the 838-ti994a-memtest project

The script includes error‑handling logic to stop on failure and only prints a success message when the installation is fully complete.

# *** POST Installation ***

1. To activate the updated enviornment variables with the following command or simply just open a new terminal.
	- source ~/.bashrc 

# To build the 838-memory tester project:
1. Edit Makefile to ensure LIBTI99 points to your ~/LibTi99All directory.
2. Perform the below commands:
	- cd ~/838-ti994a-memtest
	- make

# Repository contents

| File | Description |
|------|-------------|
| gcc4-4-install.sh | Automated installer script |
| gcc-4.4.0-tms9900-1.32.patch | GCC 1.32 compatibility patch |
| elf2ea5.tar.gz | elf2ea5 utility source |
| ea5split3.zip | ea5split utility source |
| elf2cart.tar.gz | elf2cart utility source |
| README.md | Documentation |

