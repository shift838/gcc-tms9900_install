#!/bin/bash

# Download the actual installer
wget https://raw.githubusercontent.com/shift838/gcc-tms9900_install/main/install-gcc-tms9900.sh -O install-gcc-tms9900.sh

# Make it executable
chmod +x install-gcc-tms9900.sh

# Run it
./install-gcc-tms9900.sh
