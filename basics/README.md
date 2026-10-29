## TART imaging using widefield tools.

Author: Tim Molteno tim@elec.ac.nz

This directory contains a stimela recipe to generate images from TART data. The data is downloaded, converted to a measurement set and then a high dynamic range image is created using Spotless:

Remember to activate the virtual environment first

The change into the basics directory (cd basics)

    stimela run simple_recipe.yml tart=ghana

(Use `mu-udm` or another TART station name when that telescope is online.)

> **Memory note:** the recipe defaults to `nvis: 10000`. On a machine with 16 GB
> of RAM the `disko` step can be killed by the OOM killer. Lower the `nvis`
> values in `simple_recipe.yml` (e.g. to 1000) if that happens.

### Imaging a different measurement set column

By default the images are made from the `DATA` column of the measurement set.
To image another column (for example `CORRECTED_DATA` after calibration), pass
the `data_column` parameter:

    stimela run simple_recipe.yml tart=ghana data_column=CORRECTED_DATA

This parameter is threaded through to the `column` input of both the `spotless`
and `disko` tools. It requires `tart-cargo >= 0.3.8` (the version that added the
`column` arguments); upgrade with `pip install --upgrade tart-cargo` if needed.

