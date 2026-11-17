# Installation

These instructions set up a machine to run the TART imaging pipeline in the
`basics` directory, e.g.

    cd basics
    make TART=mz-up

The pipeline is driven by [stimela](https://github.com/caracal-pipeline/stimela)
2.x and the [tart-cargo](https://github.com/tart-telescope/tart-cargo) cab
repository. The imaging steps run inside apptainer (singularity) containers,
so apptainer must be installed first.

## 1. Install apptainer

On Debian/Ubuntu (amd64 or arm64), apptainer 1.3.4 can be installed from the
upstream release debs (this is what `.devcontainer/post-create.sh` does):

    sudo apt-get update
    sudo apt-get install -y squashfuse fuse2fs fuse3 libfuse-dev uidmap wget cryptsetup

    APPTAINER_VERSION=1.3.4
    ARCH=$(dpkg --print-architecture)
    wget -q "https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/apptainer_${APPTAINER_VERSION}_${ARCH}.deb" -O /tmp/apptainer.deb
    wget -q "https://github.com/apptainer/apptainer/releases/download/v${APPTAINER_VERSION}/apptainer-suid_${APPTAINER_VERSION}_${ARCH}.deb" -O /tmp/apptainer-suid.deb
    sudo apt-get install -y /tmp/apptainer.deb /tmp/apptainer-suid.deb
    rm /tmp/apptainer.deb /tmp/apptainer-suid.deb

    apptainer --version

On other distributions, install apptainer through your package manager or
follow the [apptainer install docs](https://apptainer.org/docs/user/main/installation.html).
Docker also works if apptainer is unavailable.

## 2. Create the Python environment and install the pipeline packages

Use **Python 3.12 or 3.13** — stimela is not compatible with Python 3.14,
which removed the implicit `asyncio.get_event_loop()` that stimela's process
runner relies on (the run fails with `RuntimeError: There is no current event
loop in thread 'MainThread'`).

From the repository root:

    python3.13 -m venv venv

(On Debian/Ubuntu, if `ensurepip` is missing, install `python3.13-venv` first:
`sudo apt install python3.13-venv`.)
    source ./venv/bin/activate
    pip install --upgrade pip
    pip install --upgrade tart-cargo
    pip install git+https://github.com/caracal-pipeline/cult-cargo

This installs stimela 2.x (pulled in as a dependency of tart-cargo/cult-cargo)
plus the TART cabs (`tart2ms`, `tart-download-data`, `disko`, `spotless`,
`disko-draw`) that `basics/simple_recipe.yml` references via its
`(tartcargo)` include.

## 3. Pre-build the container images (recommended)

The first run otherwise spends a long time building images. Pre-build them
once from the repo root (any station name works here — it is only used to
validate the recipe):

    stimela build ./basics/simple_recipe.yml tart=ghana

## 4. Run the pipeline

The Makefiles use `~/tmp` as `APPTAINER_TMPDIR`, so create it once:

    mkdir -p ~/tmp

Then:

    cd basics
    make TART=mz-up

This downloads visibility data from the `mz-up` TART station
(`https://api.elec.ac.nz/tart/mz-up`), converts it to a measurement set with
`tart2ms`, and produces spotless and disko sky images
(`*-spotless.sphere`, `*-disko.sphere` and `spotless-*.svg` / `disko-*.svg`).

Equivalent direct stimela invocation:

    stimela run simple_recipe.yml tart=mz-up

Notes:

- **Memory:** the recipe defaults to `nvis: 10000`. On a machine with 16 GB
  of RAM the `disko` step can be OOM-killed — lower the `nvis` values in
  `basics/simple_recipe.yml` (e.g. to 1000) if that happens.
- **Caching:** the `download-hdf` and `create-ms` steps skip themselves if
  `mz-up-vis.hdf` / `mz-up.ms` already exist. `make clean` removes them (it
  deletes every file matching `*mz-up*`, plus `*.txt`, `*.deps`, `*.log`).
- To image a calibrated column instead of `DATA`, pass
  `stimela run simple_recipe.yml tart=mz-up data_column=CORRECTED_DATA`
  (requires `tart-cargo >= 0.3.8`).

## Troubleshooting

- **`AttributeError: 'DiSkOOperator' object has no attribute 'shape'`** (in
  the `spotless`/`disko` step): a known bug in the `tools:v1.3.3` image —
  `disko 1.5.0` is incompatible with the `pylops 2.9.0` it ships. Tracked at
  [tart-telescope/tools#5](https://github.com/tart-telescope/tools/issues/5).
  Until a fixed image is released, use a checkout whose `tart-cargo` pins an
  earlier image (e.g. v1.3.2), or patch the image by moving the
  `super().__init__()` call in disko's `DiSkOOperator.__init__` to after
  `self.shape = (self.M, self.N)`.
- **`disko` step exits with code -9 (SIGKILL)**: the OOM killer — see the
  memory note above; lower `nvis` in `basics/simple_recipe.yml`.

## Codespaces / devcontainer alternative

If you prefer not to install anything locally, the repo includes a
devcontainer (`.devcontainer/`) that performs all of the above automatically.
In GitHub, click the green **Code** button → **Codespaces** → **Create codespace**,
then in the default `/workspaces/radio-imaging` directory:

    source ./venv/bin/activate
    cd basics
    make TART=mz-up
