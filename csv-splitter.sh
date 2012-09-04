#!/bin/bash
# Takes a large CSV file and splits into multiple smaller files.
#
# check if an input filename was passed as a command
# line argument:
if [ ! $# == 1 ]; then
echo "Please specify the name of a file to split!"
exit
fi

dirpath=$(dirname ${1})
pushd $dirpath

# create a directory to store the output:
mkdir output

# create a temporary file containing the header without
# the content:
head -n 1 $1 > header.csv

# create a temporary file containing the content without
# the header:
tail -n +2 $1 > content.csv

# split the content file into multiple files of 5 lines each:
split -l 500 content.csv output/data_

# loop through the new split files, adding the header
# and a '.csv' extension:
for f in output/*; do cat header.csv $f > $f.csv; rm $f; done;

# remove the temporary files:
rm header.csv
rm content.csv

popd
