## TART Calibration and imaging using CASA

This is a more advanced workthrough that makes (square) images from TART data, using the CASA framework. CASA is widely used for radio astronomy imaging, and has good plotting utilities to provide feedback on the quality of calibration.

Authors: Ben A Hugo (SARAO)
         Tim Molteno (tim@elec.ac.nz) - updated to use cult-cargo casa containers


## To Run this example

First install the Stimela cargo packages (the devcontainer does this for you):

    pip install tart-cargo git+https://github.com/caracal-pipeline/cult-cargo

The following command will execute this script, downloading data from the Ghana TART

    stimela run tart_cal_casa.yml tart=ghana

(Use another TART station name, e.g. `mu-udm`, when that telescope is online.)

### Calibration requires a model

The amplitude calibration step (`casa.gaincal`) needs a populated `MODEL_DATA`
column. A fresh download from the live TART API may not contain a source
catalogue, in which case `gaincal` logs `No output calibration table written`
and the following `plotcaltable_amp` step fails. If that happens, use the
measurement set shipped with the paper pipeline, which already has a model:

    mkdir -p msdir
    cp -a ../tart-paper/msdir/ghana.ms msdir/ghana.ms

The `download-hdf` and `create-ms` steps are then skipped automatically.
