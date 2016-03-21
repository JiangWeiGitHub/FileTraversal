
var traverse = require('./Traverse.js');
var handleFile = require('./HandleFile.js');

//traverse.Traverse('./AngryBirds', handleFile.SetUUIDXattr);
//traverse.Traverse('./AngryBirds', handleFile.SetHashXattr);

handleFile.AddReadlistXattr('./AngryBirds/AngryBirds.exe', 'world');
