
/*
  Function: Traverse the specified path which includes files & subfolders
  Parameters: path -> specified from caller which to deal with
              HandleFile -> callback function for deal with every file or folder is found
*/  

var fs = require('fs');

function Traverse(path, HandleFile)
{
    // deal with the root folder
    HandleFile(path);

    fs.readdir(path, function(err, files)
    {
        if (err)
        {
            console.log('Read Directory Error!');
        }
        else
        {
            files.forEach(function(item)
            {
                var tmpPath = path + '/' + item;
                fs.stat(tmpPath, function(stat_err, stats)
                {
                    if (stat_err)
                    {
                        console.log('Get Stat Error!');
                    }
                    else
                    {
                        if (stats.isDirectory())
                        {
                            Traverse(tmpPath, HandleFile);
                        }
                        else
                        {
                            HandleFile(tmpPath);
                        }
                    }
                });
            });
        }
    });
}
  
exports.Traverse = Traverse;
