variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}

variable "private_key_path" {
  description = "The path to the private key corresponding to the SSH key pair."
}

variable "calibrationsnap" {
  description = "The url to the calibration snapshot."
  default = "https://snapshots.calibrationnet.filops.net/minimal/latest.zst"
}

variable "mainsnap" {
  description = "The url to the mainnet snapshot."
  default = "https://snapshots.mainnet.filops.net/minimal/latest.zst"
}

variable "cuda-driver-url" {
    description = "The url to the cuda driver."
    default = "https://us.download.nvidia.com/tesla/460.73.01/NVIDIA-Linux-x86_64-460.73.01.run"
}

variable "cuda-tools-url" {
    description = "The url to the cuda tools."
    default = "https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run"
}

