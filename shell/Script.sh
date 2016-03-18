#!/bin/bash

# Traversal the whole folder & subfolder
# And add xattr with user.uuid & user.hash for all normal files
# Meanwhile add xattr with user.uuid  for all normal folders
# Hash uses sha256sum & UUID uses v4 version
# No parameters
setUUIDHashXattr()
{
    for filename in $(ls)
    do
        if [ -f ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` ${filename}

            originalStr=`sha256sum ${filename}`
            processedStr=${originalStr:0:64}
            setfattr -n user.hash -v ${processedStr} ${filename}
        elif [ -d ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` ${filename}

            cd ${filename}
            setUUIDHashXattr
            cd ..
        else
            echo "Unsupported File Format!"
        fi
    done
}

# Add xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName; $2 ownerlistValue
addOwnerListXattr()
{
    originalStr=`getfattr -n user.ownerlist "$1" --only-values`
    if [ $? != 0 ]
    then
        setfattr -n user.ownerlist -v "$2" "$1"
    else
        setfattr -n user.ownerlist -v "$originalStr; $2" "$1"
    fi
}

# Reset xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName
resetOwnerListXattr()
{
    setfattr -x user.ownerlist "$1"
}
