TART=mu-udm

all:
	APPTAINER_TMPDIR=~/tmp stimela run simple_recipe.yml tart=${TART}

clean:
	rm -rf *${TART}* 
	rm -f *.txt *.deps *.log

