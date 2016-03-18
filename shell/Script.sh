#!/bin/bash

# Traversal the whole folder & subfolder
# And add xattr with user.uuid & user.hash for all normal files
# Meanwhile add xattr with user.uuid for all normal folders
# Hash uses sha256sum & UUID uses v4 version
# No parameters
setAllUUIDHashXattr()
{
    for filename in $(ls)
    do
        if [ -f ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` "${filename}"

            originalStr=`sha256sum ${filename}`
            processedStr=${originalStr:0:64}
            setfattr -n user.hash -v "${processedStr}" "${filename}"
        elif [ -d ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` "${filename}"

            cd ${filename}
            setAllUUIDHashXattr
            cd ..
        else
            echo "Unsupported File Format!"
        fi
    done
}

# Get UUID value
# Deal with single file & folder
# Parameters: $1 fileName
getUUIDXattr()
{
    getfattr -n user.uuid "${1}" --only-values
}

# Set UUID value
# Deal with single file & folder
# Parameters: $1 fileName; $2 UUIDValue
setUUIDXattr()
{
    setfattr -n user.uuid -v "${2}" "${1}"    
}

# Clean UUID value
# Deal with single file & folder
# Parameters: $1 fileName
cleanUUIDXattr()
{
    setfattr -x user.uuid "${1}"     
}

# Get Hash value
# Deal with single file
# Parameters: $1 fileName
getHashXattr()
{
    getfattr -n user.hash "${1}" --only-values
}

# Set Hash value
# Deal with single file
# Parameters: $1 fileName; $2 HashValue
setHashXattr()
{
    setfattr -n user.hash -v "${2}" "${1}"     
}

# Clean Hash value
# Deal with single file
# Parameters: $1 fileName
cleanHashXattr()
{ 
    setfattr -x user.hash "${1}"
}

##############################################################

# Add xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName; $2 ownerlistValue
addOwnerListXattr()
{
    originalStr=`getfattr -n user.ownerlist "$1" --only-values`
    if [ $? != 0 ]
    then
        # First setting
        setfattr -n user.ownerlist -v "$2" "$1"
    else
        setfattr -n user.ownerlist -v "$originalStr; $2" "$1"
    fi
}

# Clean xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName
cleanOwnerListXattr()
{
    setfattr -x user.ownerlist "$1"
}

# Get xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName
getOwnerListXattr()
{
    getfattr -n user.ownerlist "$1"
}

# Delete xattr with ownerlist for this file
# Deal with single file
# Parameters: $1 fileName; $2 ownerlistValue
deleteOwnerListXattr()
{
    originalStr=`getfattr -n user.ownerlist "$1" --only-values`
    if [ $? != 0 ]
    then
        # Empty
        return 101
    else
        oldIFS="$IFS"
        IFS="; "
        array=(${originalStr})
        IFS=${oldIFS}
        tmpStr=""
        counter=0

        for name in ${array[@]}
        do
            if [ ${name} != ${2} ]
            then
                if [ ${counter} -eq 0 ]
                then
                    tmpStr=${name}
                    let counter+=1
                else
                    tmpStr="${tmpStr}; ${name}"
                    let counter+=1
                fi
            else
                continue
            fi
        done

        if [ ${counter} -eq ${#array[@]} ]
        then
            return 102
        else
            setfattr -x user.ownerlist "${1}"
            setfattr -n user.ownerlist -v "${tmpStr}" "${1}"
        fi
    fi
}










