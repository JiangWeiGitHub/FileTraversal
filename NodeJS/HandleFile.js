
var fs = require('fs');
var crypto = require('crypto');
var uuid = require('node-uuid');
var xattr = require('fs-xattr');

/******************************************************/

/*
  Function: Add xattr with user.hash for a normal file
  PS: Uses sha256 for hash algorithm
  Parameters: path -> specified from caller which to deal with
*/  

function SetHashXattr(path)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isFile())
            {
                // create a new one when read a new stream
                var shasum = crypto.createHash('sha256');

                var stream = fs.ReadStream(filename);
                stream.on('data', function(contents)
                {
                    shasum.update(contents);
                });

                stream.on('end', function()
                {
                    var data = shasum.digest('hex');
                    xattr.set(path, 'user.hash', data, function(err)
                    {
                        if (err)
                        {
                            console.log('Set Xattr Failed!');
                        
                            //return console.error(err);
                        }
                    });
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.SetHashXattr = SetHashXattr;

/******************************************************/

/*
  Function: Add xattr with user.uuid for a normal file or folder
  PS: Uses V4 for UUID
  Parameters: path -> specified from caller which to deal with
*/  

function SetUUIDXattr(path)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isDirectory() || stats.isFile())
            {
                xattr.set(path, 'user.uuid', uuid.v4(), function(err)
                {
                    if (err)
                    {
                        console.log('Set Xattr Failed!');
                    
                        //return console.error(err);
                    }
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.SetUUIDXattr = SetUUIDXattr;

/******************************************************/

/*
  Function: Add xattr with user.type for a normal file or folder
  Parameters: path -> specified from caller which to deal with
*/  

function SetTypeXattr(path)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isDirectory())
            {
                xattr.set(path, 'user.type', 'folder', function(err)
                {
                    if (err)
                    {
                        console.log('Set Xattr Failed!');
                    
                        //return console.error(err);
                    }
                });
            }
            else if (stats.isFile())
            {
                xattr.set(path, 'user.type', 'file', function(err)
                {
                    if (err)
                    {
                        console.log('Set Xattr Failed!');
                    
                        //return console.error(err);
                    }
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.SetTypeXattr = SetTypeXattr;

/******************************************************/

/*
  Function: Add xattr with user.owner for a normal file or folder
  Parameters: path -> specified from caller which to deal with
              value -> owner's new value
*/  

function SetOwnerXattr(path, value)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isDirectory() || stats.isFile())
            {
                xattr.set(path, 'user.owner', value, function(err)
                {
                    if (err)
                    {
                        console.log('Set Xattr Failed!');
                    
                        //return console.error(err);
                    }
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.SetOwnerXattr = SetOwnerXattr;

/******************************************************/

/*
  Function: Add xattr with user.readlist for a specified file or folder
  Parameters: path -> specified from caller which to deal with
              value -> readlist's new value
*/  

function AddReadlistXattr(path, value)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isDirectory() || stats.isFile())
            {
                // get xattr first
                xattr.get(path, 'user.readlist', function(err, get_value)
                {
                    if (err)
                    {
                        console.log('Get Xattr Value Failed!');

                        xattr.set(path, 'user.readlist', '[' + value + ']', function(err)
                        {
                            if (err)
                            {
                                console.log('Set Xattr [user.readlist] Value Failed!');
                    
                                //return console.error(err);
                            }
                        });
                    
                        //return console.error(err);
                    }
                    else
                    {
                        if (get_value.indexOf("]") <= 0)
                        {
                            xattr.set(path, 'user.readlist', '[' + value + ']', function(err)
                            {
                                if (err)
                                {
                                    console.log('Set Xattr [user.readlist] Value Failed!');
                    
                                    //return console.error(err);
                                }
                            });
                        }
                        else
                        {
                            if (get_value.indexOf(value) <= 0)
                            {
                                var tmp = get_value.toString();

                                var tmp_value = tmp.substr(0, get_value.length - 1);

                                xattr.set(path, 'user.readlist', tmp_value + ',' + value + ']', function(err)
                                {
                                    if (err)
                                    {
                                        console.log('Set Xattr [user.readlist] Value Failed!');
                    
                                        //return console.error(err);
                                    }
                                });
                            }
                            else
                            {
                                console.log('Xattr [user.readlist] Value Already exists!');
                            }
                        }
                    }
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.AddReadlistXattr = AddReadlistXattr;

/******************************************************/

/*
  Function: Add xattr with user.writelist for a specified file or folder
  Parameters: path -> specified from caller which to deal with
              value -> writelist's new value
*/  

function AddWritelistXattr(path, value)
{
    var filename = path;

    fs.stat(path, function(err, stats)
    {
        if (err)
        {
            console.log('Get State Error!');
        }
        else
        {  
            if (stats.isDirectory() || stats.isFile())
            {
                // get xattr first
                xattr.get(path, 'user.writelist', function(err, get_value)
                {
                    if (err)
                    {
                        console.log('Get Xattr Value Failed!');

                        xattr.set(path, 'user.writelist', '[' + value + ']', function(err)
                        {
                            if (err)
                            {
                                console.log('Set Xattr [user.writelist] Value Failed!');
                    
                                //return console.error(err);
                            }
                        });
                    
                        //return console.error(err);
                    }
                    else
                    {
                        if (get_value.indexOf("]") <= 0)
                        {
                            xattr.set(path, 'user.writelist', '[' + value + ']', function(err)
                            {
                                if (err)
                                {
                                    console.log('Set Xattr [user.writelist] Value Failed!');
                    
                                    //return console.error(err);
                                }
                            });
                        }
                        else
                        {
                            if (get_value.indexOf(value) <= 0)
                            {
                                var tmp = get_value.toString();

                                var tmp_value = tmp.substr(0, get_value.length - 1);

                                xattr.set(path, 'user.writelist', tmp_value + ',' + value + ']', function(err)
                                {
                                    if (err)
                                    {
                                        console.log('Set Xattr [user.writelist] Value Failed!');
                    
                                        //return console.error(err);
                                    }
                                });
                            }
                            else
                            {
                                console.log('Xattr [user.writelist] Value Already exists!');
                            }
                        }
                    }
                });
            }
            else
            {
                console.log('Unsupported File Format!');
            }
        }
    })  
}

exports.AddWritelistXattr = AddWritelistXattr;

/******************************************************/
