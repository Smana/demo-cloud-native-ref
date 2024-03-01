#!/bin/bash

set -e

apt update -yy -qq
apt install -qq --no-install-recommends -y curl gnupg apt-transport-https ca-certificates gnupg python3-pip git unzip
install -m 0755 -d /etc/apt/keyrings

# Opentofu
curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
chmod a+r /etc/apt/keyrings/opentofu.gpg
echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | tee /etc/apt/sources.list.d/opentofu.list > /dev/null
echo "deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | tee -a /etc/apt/sources.list.d/opentofu.list > /dev/null

apt update -yy -qq
apt install -qq --no-install-recommends -y tofu
rm -rf /var/lib/apt/lists/*

# Terraform (This is temporary until it will be supported by the pre-commit)
TERRAFORM_VERSION="1.5.7"
curl -sLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/ && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip


curl https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -sLo terraform.zip \
unzip terraform.zip && install -m 755 terraform /usr/local/bin/terraform && rm terraform*

# Tfsec
TFSEC_VERSION="v1.28.5"
curl -sLo tfsec https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64
chmod +x tfsec && mv tfsec /usr/local/bin/

# Tflint
TFLINT_VERSION=v0.50.3
curl https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip -sLo tflint.zip
unzip tflint.zip && install -m 755 tflint /usr/local/bin/tflint && rm tflint*

pip3 install pre-commit
