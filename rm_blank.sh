#!/bin/bash

# Remove single blank from the beginning or end of files' name.

# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-08

cd /path/to/files/

## remove blank from the beginning of files' name
files=`ls | grep '^ '`
for file in $files
do
    mv " $file" "$file"
done

## remove blank from the end of files' name
files=`ls | grep ' $'`
for file in $files
do
    mv "$file " "$file"
done
