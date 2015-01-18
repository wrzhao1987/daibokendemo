#/bin/bash

SCRIPT_PATH=$(dirname $0)
SCRIPT_NAME=$(basename $0)

files=$(ls $SCRIPT_PATH)
echo $files

for file in $files; do
    if [ $file == $SCRIPT_NAME ]; then
        continue;
    fi
    if [[ -x $file && ! -d $file ]]; then
        echo "x" $file;
        $SCRIPT_PATH/$file
    fi
done
