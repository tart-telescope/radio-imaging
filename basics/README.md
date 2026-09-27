## TART imaging using widefield tools.

Author: Tim Molteno tim@elec.ac.nz

This directory contains a stimela recipe to generate images from TART data. The data is downloaded, converted to a measurement set and then a high dynamic range image is created using Spotless:

Remember to activate the virtual environment first

The change into the basics directory (cd basics)

    stimela run simple_recipe.yml tart=nz-elec

### Imaging a different measurement set column

By default the images are made from the `DATA` column of the measurement set.
To image another column (for example `CORRECTED_DATA` after calibration), pass
the `data_column` parameter:

    stimela run simple_recipe.yml tart=nz-elec data_column=CORRECTED_DATA

This parameter is threaded through to the `column` input of both the `spotless`
and `disko` tools. It requires `tart-cargo >= 0.3.8` (the version that added the
`column` arguments); upgrade with `pip install --upgrade tart-cargo` if needed.

