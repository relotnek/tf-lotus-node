#!/bin/bash

# Update and install packages
sudo apt update -y
sudo apt install -y mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev wget
sudo apt upgrade -y

# Install CUDA Toolkit
wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
sudo sh cuda_12.2.2_535.104.05_linux.run --silent --toolkit --driver --override 

# Install Driver
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/470.199.02/NVIDIA-Linux-x86_64-470.199.02.run
sudo sh NVIDIA-Linux-x86_64-470.199.02.run --silent

# Install aria2c
sudo snap install aria2c

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
# Install Go
wget -c https://golang.org/dl/go1.19.12.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local

# Update PATH for Go
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin

# Clone Lotus
git clone https://github.com/filecoin-project/lotus.git
cd lotus
git checkout releases

# Set environment variables
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
export CGO_CFLAGS_ALLOW="-D__BLST_PORTABLE__"
export CGO_CFLAGS="-D__BLST_PORTABLE__"
export FFI_USE_CUDA=1
export RUST_GPU_TOOLS_CUSTOM_GPU="GRID K520:3072"
export CUDA_HOME="/usr/local/cuda-12.2/bin/"

# Build and install Lotus for calibnet
make clean calibnet
sudo -E make install

# Install services
sudo -E make install-daemon-service
sudo -E make install-miner-service

# Download calibration snapshot
aria2c -x5 "$1" -o calibnet.car
lotus daemon --import-snapshot calibnet.car --halt-after-import
nohup lotus daemon 2>&1 > lotus.log &

echo "Setup complete."
