TART=ghana

all:
	APPTAINER_TMPDIR=~/tmp stimela run process-data.yml tart=${TART}

casa:
	APPTAINER_TMPDIR=~/tmp stimela run process-casa.yml tart=${TART}

clean:
# 	rm -rf *${TART}* msdir rawdata
	rm -rf img caltables
	rm -f *.txt *.deps *.log

install:
	pip install tart-cargo git+https://github.com/caracal-pipeline/cult-cargo
