# TMS9900 GCC Toolchain Installer

This repository provides a fully automated installer for building and configuring the GCC-based TMS9900 cross‑compiler toolchain (using GCC 4.0.0) along with several essential TI‑99/4A utilities. It is designed for Linux and WSL (Ubuntu recommended) and sets up everything needed to compile TI‑99/4A software using a modern GCC toolchain.

You may **download and run the installer script directly** without cloning this repository.

---

## 🚀 Quick Install (No Repo Clone Required)

You can install the entire TMS9900 GCC toolchain by downloading the installer script and running it.

***There will be 100's of warnings, don't panic, just ignore them.

### 1. Download the installer script
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/gcc4-4-install.sh

### 2. Grant execute permissions to the script
chmod +x gcc4-4-install.sh

### 3. Run the installer
./gcc4-4-install.sh

# What the Installer Sets Up:
The  script performs a complete toolchain setup:
• 	Installs required system packages:
• 	Creates a working directory for all build operations
• 	Download and extracts:
    - gcc-4.4.0.tar.gz
• 	Downloads gcc-4.4.0-tms9900-1.32.patch
•   Builds gcc 4.4.0
• 	Installs gcc 4.4.0 1.32 patch
• 	Builds and installs:
	- binutils
    - elf2ea5
    - ea5split
    - elf2cart
• 	Installs binutils 1.11 patch
•   Clones:
	  - (Tursilion’s TI‑99 support library)
      - (SHIFT838’s 838-ti994amemtest repository)
• 	Adds required environment variables to .bashrc
    - PATH=~/tms9900gcc/bin:$PATH
    - LIBTI99 =~/libti99
• 	Provides instructions for building the 838-ti994a-memtest project

The script includes error‑handling logic to stop on failure and only prints a success message when the installation is fully complete.

# POST Installation

1. Update Makefile.ti99 for libTi99All and save with updates below
	- cd ~/libTi99All
	- nano ./Makefile.ti99
	Update Paths to:
	TMS9900_DIR?=$(HOME)/tms9900gcc/bin
	ELF2EA5_DIR?=$(HOME)/tms9900gcc/bin

	Update path to executables:
	GAS=$(TMS9900_DIR)/tms9900-unknown-elf-as
	LD=$(TMS9900_DIR)/tms9900-unknown-elf-ld
	CC=$(TMS9900_DIR)/tms9900-unknown-elf-gcc
	AR=$(TMS9900_DIR)/tms9900-unknown-elf-ar

2. Compile libTi99All and copy libti99.a to ~/libTi99All folder.
	- make clean
	While inside the ~/libTi99All
	- issue command: rm -rf buildti
	- make ti
	- cp /buildti/libti99.a .
 - 


# The new elf2ea5 in the Phoenix Wright code does not need split anymore
# but if you need it, then go ahead and use this
#EA5_SPLIT_DIR?=~/tms9900gcc/bin
EA5_SPLIT_DIR?=echo Dont need:
2. To activate the updated enviornment variables:

	- Execute command: source ~/.bashrc or simply just open a new terminal

# To build the 838-memory tester project:
1. Edit Makefile to ensure LIBTI99 points to your ~/LibTi99All directory.
2. Perform the below commands:
	- cd ~/838-ti994a-memtest
	- make

# Repository contents:
gcc4-4-install.sh	       		# Automated installer script   
gcc-4.4.0-tms9900-1.32.patch	# GCC 1.32 compatibility patch  
elf2ea5.tar.gz             		# elf2ea5 utility source  
ea5split3.zip              		# ea5split utility source  
elf2cart.tar.gz            		# elf2cart utility source  
README.md                  		# Documentation  

