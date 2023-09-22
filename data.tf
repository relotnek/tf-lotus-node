
# Read the public IP address from the file
data "local_file" "public_ip" {
  depends_on = [null_resource.fetch_public_ip]
  filename = "${path.module}/public_ip.json"
}