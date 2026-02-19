TART=mu-udm

all:
	APPTAINER_TMPDIR=~/tmp stimela run tart_cal_casa.yml tart=${TART}

clean:
	rm -rf img rawdata caltables msdir
	rm -f *.txt *.deps *.log

##  pip install git+https://github.com/caracal-pipeline/cult-cargo
