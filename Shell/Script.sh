#!/bin/bash

# Traversal the whole folder & subfolder
# And add xattr with user.uuid & user.hash for all normal files
# Meanwhile add xattr with user.uuid for all normal folders
# Hash uses sha256sum & UUID uses v4 version
# No parameters
setAllUUIDHashTypeXattr()
{
    for filename in $(ls)
    do
        if [ -f ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` "${filename}"

            originalStr=`sha256sum ${filename}`
            processedStr=${originalStr:0:64}
            setfattr -n user.hash -v "${processedStr}" "${filename}"

            setfattr -n user.type -v "file" "${filename}"
        elif [ -d ${filename} ];then
            setfattr -n user.uuid -v `uuid -v 4` "${filename}"

            setfattr -n user.type -v "folder" "${filename}"

            cd ${filename}
            setAllUUIDHashTypeXattr
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

# Get Type value
# Deal with single file
# Parameters: $1 fileName
getTypeXattr()
{
    getfattr -n user.type "${1}" --only-values
}

# Set Type value
# Deal with single file
# Parameters: $1 fileName; $2 TypeValue
setTypeXattr()
{
    setfattr -n user.type -v "${2}" "${1}"     
}

# Clean Type value
# Deal with single file
# Parameters: $1 fileName
cleanTypeXattr()
{ 
    setfattr -x user.type "${1}"
}

##############################################################

# Add xattr with owner for this file
# Deal with single file
# Parameters: $1 fileName; $2 ownerValue
addOwnerXattr()
{
    originalStr=`getfattr -n user.owner "$1" --only-values`
    if [ $? != 0 ]
    then
        # First setting
        setfattr -n user.owner -v "$2" "$1"
    else
        setfattr -n user.owner -v "$originalStr; $2" "$1"
    fi
}

# Clean xattr with owner for this file
# Deal with single file
# Parameters: $1 fileName
cleanOwnerXattr()
{
    setfattr -x user.owner "$1"
}

# Get xattr with owner for this file
# Deal with single file
# Parameters: $1 fileName
getOwnerXattr()
{
    getfattr -n user.owner "$1"
}

# Delete xattr with owner for this file
# Deal with single file
# Parameters: $1 fileName; $2 ownerValue
deleteOwnerXattr()
{
    originalStr=`getfattr -n user.owner "$1" --only-values`
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
            setfattr -x user.owner "${1}"
            setfattr -n user.owner -v "${tmpStr}" "${1}"
        fi
    fi
}

##############################################################

# Add xattr with readlist for this file
# Deal with single file
# Parameters: $1 fileName; $2 readlistValue
addReadListXattr()
{
    originalStr=`getfattr -n user.readlist "$1" --only-values`
    if [ $? != 0 ]
    then
        # First setting
        setfattr -n user.readlist -v "$2" "$1"
    else
        setfattr -n user.readlist -v "$originalStr; $2" "$1"
    fi
}

# Clean xattr with readlist for this file
# Deal with single file
# Parameters: $1 fileName
cleanReadListXattr()
{
    setfattr -x user.readlist "$1"
}

# Get xattr with readlist for this file
# Deal with single file
# Parameters: $1 fileName
getReadListXattr()
{
    getfattr -n user.readlist "$1"
}

# Delete xattr with readlist for this file
# Deal with single file
# Parameters: $1 fileName; $2 readlistValue
deleteReadListXattr()
{
    originalStr=`getfattr -n user.readlist "$1" --only-values`
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
            setfattr -x user.readlist "${1}"
            setfattr -n user.readlist -v "${tmpStr}" "${1}"
        fi
    fi
}

##############################################################

# Add xattr with writelist for this file
# Deal with single file
# Parameters: $1 fileName; $2 writelistValue
addWriteListXattr()
{
    originalStr=`getfattr -n user.writelist "$1" --only-values`
    if [ $? != 0 ]
    then
        # First setting
        setfattr -n user.writelist -v "$2" "$1"
    else
        setfattr -n user.writelist -v "$originalStr; $2" "$1"
    fi
}

# Clean xattr with writelist for this file
# Deal with single file
# Parameters: $1 fileName
cleanWriteListXattr()
{
    setfattr -x user.writelist "$1"
}

# Get xattr with writelist for this file
# Deal with single file
# Parameters: $1 fileName
getWriteListXattr()
{
    getfattr -n user.writelist "$1"
}

# Delete xattr with writelist for this file
# Deal with single file
# Parameters: $1 fileName; $2 writelistValue
deleteWriteListXattr()
{
    originalStr=`getfattr -n user.writelist "$1" --only-values`
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
            setfattr -x user.writelist "${1}"
            setfattr -n user.writelist -v "${tmpStr}" "${1}"
        fi
    fi
}
