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

sudo add-apt-repository -y ppa:apptainer/ppa
sudo apt update
sudo apt install -y apptainer-suid

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
echo "  1. Activate the poetry environment: poetry shell"
echo "  2. Run a recipe: poetry run stimela run test/example_recipe.yml tart=mu-udm"
echo ""
