# Pipeline for building the TART images

These are the pipelines, and the data for building the TART images, in the TART paper to be submitted to RAS Techniques and Instruments (RASTI). These use two stimela pipelines. The first (process-data.yml) perform TART imaging using DiSkO and Spotless - two new widefield synthesis imaging algorithms. The second (process-casa.yml) uses a tradition CASA based calibration process and WSCLEAN to image TART data.

## Instructions

Create a python virtual environment

    python3 -m venv venv
    source ./venv/bin/activate
    
Install the required packages

    make install
    
    make data
    make casa

By default these will use the TART telescope at the 'ghana' endpoint. To use a different TART, eg mu-udm. Try

    make data TART=mu-udm

### Note on the bundled data

The `ghana.ms` measurement set checked into this directory is stale: its
`table.dat` no longer matches its column files, so WSClean fails with
`TiledStMan::headerFileGet: mismatch in #row`. Regenerate it from the bundled
HDF file before running `make data`:

    rm -rf ghana.ms
    make data

`make casa` uses `msdir/ghana.ms`, which is valid and already has the
`MODEL_DATA` column needed by the calibration steps.

The imaging recipes use `nvis: 10000`. `disko` can exhaust the memory of a
16 GB machine at that setting; lower the `nvis` values in `process-data.yml`
if needed.
