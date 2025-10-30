#!/bin/bash
set -e

echo "================================================"
echo "Setting up TART Cargo Development Environment"
echo "================================================"

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install dependencies for apptainer
echo "Installing apptainer dependencies..."
sudo apt-get install -y \
    squashfuse \
    fuse2fs \
    fuse3 \
    libfuse-dev \
    uidmap \
    wget \
    cryptsetup

# Install gocryptfs if available (might not be in all repos)
echo "Installing gocryptfs..."
sudo apt-get install -y gocryptfs || echo "gocryptfs not available in repos, skipping..."


# Determine architecture
ARCH=$(dpkg --print-architecture)
echo "Detected architecture: $ARCH"

# Download and install apptainer
echo "Installing Apptainer..."
APPTAINER_VERSION="1.3.4"

if [ "$ARCH" = "amd64" ]; then
    APPTAINER_DEB="apptainer_${APPTAINER_VERSION}_amd64.deb"
    APPTAINER_SUID_DEB="apptainer-suid_${APPTAINER_VERSION}_amd64.deb"
elif [ "$ARCH" = "arm64" ]; then
    APPTAINER_DEB="apptainer_${APPTAINER_VERSION}_arm64.deb"
    APPTAINER_SUID_DEB="apptainer-suid_${APPTAINER_VERSION}_arm64.deb"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

wget -q "https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/${APPTAINER_DEB}" -O /tmp/apptainer.deb
sudo apt-get install -y /tmp/apptainer.deb
rm /tmp/apptainer.deb

wget -q "https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/${APPTAINER_SUID_DEB}" -O /tmp/apptainer_suid.deb
sudo apt-get install -y /tmp/apptainer_suid.deb
rm /tmp/apptainer_suid.deb

# Verify apptainer installation
echo "Verifying Apptainer installation..."
apptainer --version

# Upgrade pip
echo "Upgrading pip..."
python -m pip install --upgrade pip

python -m venv venv
source ./venv/bin/activate

pip install tart-cargo
pip install cult-cargo

echo "Preloading singularity images"

echo "================================================"
echo "Setup complete! You can now use tart-cargo."
echo "================================================"
echo ""
echo "To get started:"
echo "  1. Run a recipe: poetry run stimela run basics/example_recipe.yml tart=mu-udm"
echo ""
