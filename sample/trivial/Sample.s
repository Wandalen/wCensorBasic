
let _ = require( 'wcensorbasic' );

/**/

var result = _.censor.fileReplace({ filePath : __filename, ins : '/**/', sub : '/**//**/' });
console.log( result.parcels )
