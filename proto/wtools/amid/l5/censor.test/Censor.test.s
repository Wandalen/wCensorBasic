( function _Censor_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../censor/entry/CensorBasic.s' );
  _.include( 'wTesting' );
}

let _global = _global_;
let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'censor' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  context.appJsPath = _.path.nativize( _.module.resolve( 'wCensorBasic' ) );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/censor' ) )
  _.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function fileReplaceBasic( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File1.txt';
    var options =
    {
      filePath : a.abs( 'before/File1.txt' ),
      ins : 'line',
      sub : 'abc',
    }

    var got = _.censor.fileReplace( options )
    test.identical( got.parcels.length, 3 )

    return null;
  } );

  //

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File2.txt';
    var options =
    {
      filePath : a.abs( 'before/File2.txt' ),
      ins : 'line',
      sub : 'abc',
    }

    var got = _.censor.fileReplace( options )
    test.identical( got.parcels.length, 5 )

    return null;
  } );

  return a.ready;
}

//

function filesReplaceBasic( test )
{
  let context = this;
  let a = test.assetFor( 'basic' );
  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File1.txt';
    var options =
    {
      filePath : a.abs( 'before/File1.txt' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
    }

    var got = _.censor.filesReplace( options );
    test.identical( got.nfiles, 1 )
    test.identical( got.nparcels, 3 )


    return null;
  } );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File2.txt';
    var options =
    {
      filePath : a.abs( 'before/File2.txt' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
    }

    var got = _.censor.filesReplace( options );
    test.identical( got.nfiles, 1 )
    test.identical( got.nparcels, 5 )


    return null;
  } );

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File1.txt and File2.txt';
    var options =
    {
      filePath : a.abs( 'before/**' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
    }

    var got = _.censor.filesReplace( options )
    test.identical( got.nfiles, 2 )
    test.identical( got.nparcels, 8 )

    return null;
  } );

  //

  return a.ready;
}

// --
// test suite definition
// --

let Self =
{

  name : 'Tools.mid.Censor',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 300000,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {

    fileReplaceBasic,
    filesReplaceBasic,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
