#!/bin/sh

# eg run like this to fetch one file from the repo 
# ./gco-file.sh git@github.com:clearml/clearml-helm-charts.git charts/clearml/values-production.yaml . 

#REPO=git@github.com:clearml/clearml-helm-charts.git
#FILEPATH=charts/clearml/values-production.yaml
REPO=$1
FILEPATH=$2
DIRN=`dirname $FILEPATH`
BRANCH=main
#COPY_TO=`pwd`
COPY_TO=`realpath $3`

file=`basename $FILEPATH`
file_name=${file%.*}
file_ext=${file##*.}

TEMP=`mktemp -d`
git clone --no-checkout --depth 1 --sparse --filter=blob:none \
    $REPO $TEMP
cd $TEMP
git sparse-checkout init --cone
git sparse-checkout set --no-cone $DIRN
git checkout $BRANCH
REV=`git rev-parse --short HEAD`
ls $TEMP
cp $FILEPATH $COPY_TO/$file_name-$REV.$file_ext
rm -rf $TEMP

