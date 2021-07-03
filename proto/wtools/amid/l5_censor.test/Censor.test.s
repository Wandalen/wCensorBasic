( function _Censor_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../l5_censor/entry/CensorBasic.s' );
  _.include( 'wTesting' );
}

const _global = _global_;
const _ = _global_.wTools;

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
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      filePath : a.abs( 'before/File1.txt' ),
      ins : 'line',
      sub : 'abc',
      profileDir : profile
    }

    var got = _.censor.fileReplace( options )
    test.identical( got.parcels.length, 3 )

    _.censor.profileDel( profile );
    return null;
  } );

  //

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File2.txt';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      filePath : a.abs( 'before/File2.txt' ),
      ins : 'line',
      sub : 'abc',
      profileDir : profile
    }

    var got = _.censor.fileReplace( options )
    test.identical( got.parcels.length, 5 )

    _.censor.profileDel( profile );
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
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      filePath : a.abs( 'before/File1.txt' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
      profileDir : profile
    }

    var got = _.censor.filesReplace( options );
    test.identical( got.nfiles, 1 )
    test.identical( got.nparcels, 3 )

    _.censor.profileDel( profile );
    return null;
  });

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File2.txt';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      filePath : a.abs( 'before/File2.txt' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
      profileDir : profile
    }

    var got = _.censor.filesReplace( options );
    test.identical( got.nfiles, 1 )
    test.identical( got.nparcels, 5 )

    _.censor.profileDel( profile );
    return null;
  });

  /* - */

  a.ready.then( ( op ) =>
  {
    test.case = 'replace in File1.txt and File2.txt';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      filePath : a.abs( 'before/**' ),
      basePath : a.abs( '.' ),
      ins : 'line',
      sub : 'abc',
      profileDir : profile
    }

    var got = _.censor.filesReplace( options )
    test.identical( got.nfiles, 2 )
    test.identical( got.nparcels, 8 )

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  return a.ready;
}

//

function renameBasic( test )
{
  let context = this;
  let a = test.assetFor( false );
  let profileDir = `test-${ _.intRandom( 1000000 ) }`;
  profileDir = null;

  /* */

  test.case = 'single file';

  _.censor.profileDel( profileDir );
  a.reflect();
  a.fileProvider.fileWrite( a.abs( 'File1.txt' ), 'File1.txt' );

  var expected = { 'File1.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.fileRename
  ({
    dstPath : a.abs( 'File2.txt'),
    srcPath : a.abs( 'File1.txt' ),
    profileDir,
  });

  _.censor.do({ profileDir });

  var expected = { 'File2.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected = { 'File1.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  test.case = 'to itself ';

  _.censor.profileDel( profileDir );
  a.reflect();
  a.fileProvider.fileWrite( a.abs( 'File1.txt' ), 'File1.txt' );

  var expected = { 'File1.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.fileRename
  ({
    dstPath : a.abs( 'File1.txt'),
    srcPath : a.abs( 'File1.txt' ),
    profileDir,
  });

  _.censor.do({ profileDir });

  var expected = { 'File1.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected = { 'File1.txt' : 'File1.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  test.case = 'several files';

  _.censor.profileDel( profileDir );
  a.reflect();
  a.fileProvider.fileWrite( a.abs( 'File1.txt' ), 'File1.txt' );
  a.fileProvider.fileWrite( a.abs( 'File2.txt' ), 'File2.txt' );

  var expected = { 'File1.txt' : 'File1.txt', 'File2.txt' : 'File2.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.fileRename
  ({
    dstPath : a.abs( 'File3.txt'),
    srcPath : a.abs( 'File2.txt' ),
    profileDir,
  });

  var got = _.censor.fileRename
  ({
    dstPath : a.abs( 'File2.txt'),
    srcPath : a.abs( 'File1.txt' ),
    profileDir,
  });

  _.censor.do({ profileDir });

  var expected = { 'File2.txt' : 'File1.txt', 'File3.txt' : 'File2.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected = { 'File1.txt' : 'File1.txt', 'File2.txt' : 'File2.txt' };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  _.censor.profileDel( profileDir );
}

//

function listingReorder( test )
{
  let context = this;
  let a = test.assetFor( 'listingSqueeze' );
  let profileDir = `test-${ _.intRandom( 1000000 ) }`;
  profileDir = null;

  /* */

  test.case = 'basic';

  _.censor.profileDel( profileDir );
  a.reflect();

  var expected =
  {
    '11_F3.txt' : '11_F3.txt',
    '3_F1.txt' : '3_F1.txt',
    '3_F2.txt' : '3_F2.txt',
    '5_F0.txt' : '5_F0.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.listingReorder
  ({
    dirPath : a.abs( '.' ),
    profileDir,
  });
  _.censor.do({ profileDir });

  var expected =
  {
    '10_F1.txt' : '3_F1.txt',
    '20_F2.txt' : '3_F2.txt',
    '30_F0.txt' : '5_F0.txt',
    '40_F3.txt' : '11_F3.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected =
  {
    '11_F3.txt' : '11_F3.txt',
    '3_F1.txt' : '3_F1.txt',
    '3_F2.txt' : '3_F2.txt',
    '5_F0.txt' : '5_F0.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  _.censor.profileDel( profileDir );
}

//

function listingReorderPartiallyOrdered( test )
{
  let context = this;
  let a = test.assetFor( 'listingReorderPartiallyOrdered' );
  let profileDir = `test-${ _.intRandom( 1000000 ) }`;
  profileDir = null;

  /* */

  test.case = 'basic';

  _.censor.profileDel( profileDir );
  a.reflect();

  var expected =
  { '10_F1.txt' : '10_F1.txt', '20_F2.txt' : '20_F2.txt', '31_F3.txt' : '31_F3.txt' }
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.listingReorder
  ({
    dirPath : a.abs( '.' ),
    profileDir,
  });
  _.censor.do({ profileDir });

  var expected =
  { '10_F1.txt' : '10_F1.txt', '20_F2.txt' : '20_F2.txt', '30_F3.txt' : '31_F3.txt' }
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected =
  { '10_F1.txt' : '10_F1.txt', '20_F2.txt' : '20_F2.txt', '31_F3.txt' : '31_F3.txt' }
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  _.censor.profileDel( profileDir );
}

//

function listingSqueeze( test )
{
  let context = this;
  let a = test.assetFor( 'listingSqueeze' );
  let profileDir = `test-${ _.intRandom( 1000000 ) }`;
  profileDir = null;

  /* */

  test.case = 'basic';

  _.censor.profileDel( profileDir );
  a.reflect();

  var expected =
  {
    '11_F3.txt' : '11_F3.txt',
    '3_F1.txt' : '3_F1.txt',
    '3_F2.txt' : '3_F2.txt',
    '5_F0.txt' : '5_F0.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  var got = _.censor.listingSqueeze
  ({
    dirPath : a.abs( '.' ),
    profileDir,
  });
  _.censor.do({ profileDir });

  var expected =
  {
    '1_F1.txt' : '3_F1.txt',
    '2_F2.txt' : '3_F2.txt',
    '3_F0.txt' : '5_F0.txt',
    '4_F3.txt' : '11_F3.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  _.censor.undo({ profileDir });

  var expected =
  {
    '11_F3.txt' : '11_F3.txt',
    '3_F1.txt' : '3_F1.txt',
    '3_F2.txt' : '3_F2.txt',
    '5_F0.txt' : '5_F0.txt',
    '_3_F1.txt' : '_3_F1.txt',
  };
  var extract = a.fileProvider.filesExtract( a.abs( '.' ) );
  test.identical( extract.filesTree, expected );

  /* */

  _.censor.profileDel( profileDir );
}

//

function filesHardLink( test )
{
  let context = this;
  let a = test.assetFor( 'hlink' );

  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink 3 files, all are identical';
    let profile = `test-${ _.intRandom( 1000000 ) }`;

    let file1 = a.abs( 'dir1/File1.txt' );
    let file2 = a.abs( 'dir1/File2.txt' );
    let file3 = a.abs( 'dir1/File3.txt' );

    var options =
    {
      basePath : a.abs( './dir1' ),
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( a.fileProvider.areHardLinked( file2, file3 ) );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink 3 files, 2 files are identical';
    let profile = `test-${ _.intRandom( 1000000 ) }`;

    let file1 = a.abs( 'dir2/File1.txt' );
    let file2 = a.abs( 'dir2/File2.txt' );
    let file3 = a.abs( 'dir2/File3.txt' );

    var options =
    {
      basePath : a.abs( './dir2' ),
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink 3 files, 2 in folder, all identical';
    let profile = `test-${ _.intRandom( 1000000 ) }`;

    let file1 = a.abs( 'dir3/dir3.1/File1.txt' );
    let file2 = a.abs( 'dir3/dir3.1/File2.txt' );
    let file3 = a.abs( 'dir3/File3.txt' );

    var options =
    {
      basePath : a.abs( './dir3' ),
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( a.fileProvider.areHardLinked( file2, file3 ) );

    _.censor.profileDel( profile );
    return null;
  });

  return a.ready;
}

//

function filesHardLinkOptionExcludingPath( test )
{
  let context = this;
  let a = test.assetFor( 'hlink' );

  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink 3 files, 1 file in excludingPath';
    let profile = `test-${ _.intRandom( 1000000 ) }`;

    let file1 = a.abs( 'dir1/File1.txt' );
    let file2 = a.abs( 'dir1/File2.txt' );
    let file3 = a.abs( 'dir1/File3.txt' );

    var options =
    {
      basePath : a.abs( './dir1' ),
      excludingPath : file3,
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink 4 files, folder with 2 files in excludingPath';
    let profile = `test-${ _.intRandom( 1000000 ) }`;

    let file1 = a.abs( 'dir4/dir4.1/File1.txt' );
    let file2 = a.abs( 'dir4/dir4.1/File2.txt' );
    let file3 = a.abs( 'dir4/File3.txt' );
    let file4 = a.abs( 'dir4/File4.txt' );

    var options =
    {
      basePath : a.abs( './dir4' ),
      excludingPath : a.abs( './dir4/dir4.1' ),
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.isHardLink( file4 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file3, file4 ) );

    var got = _.censor.filesHardLink( options );

    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.isHardLink( file4 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file3 ) );
    test.true( !a.fileProvider.areHardLinked( file2, file3 ) );
    test.true( a.fileProvider.areHardLinked( file3, file4 ) );

    _.censor.profileDel( profile );
    return null;
  });

  return a.ready;
}

//

function filesHardLinkOptionExcludingHyphened( test )
{
  let context = this;
  let a = test.assetFor( 'hlinkHyphened' );
  let file1 = a.abs( 'dir1/File1.txt' );
  let file2 = a.abs( 'dir1/File2.txt' );

  let file3 = a.abs( 'dir2/-File1.txt' );
  let file4 = a.abs( 'dir2/-File2.txt' );
  a.reflect();

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink non-ignored';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      basePath : a.abs( '.' ),
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file1 ) );
    test.true( !a.fileProvider.isHardLink( file2 ) );
    test.true( !a.fileProvider.areHardLinked( file1, file2 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file1 ) );
    test.true( a.fileProvider.isHardLink( file2 ) );
    test.true( a.fileProvider.areHardLinked( file1, file2 ) );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink ignored, excludingHyphened : 1';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      basePath : a.abs( '.' ),
      excludingHyphened : 1,
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.isHardLink( file4 ) );
    test.true( !a.fileProvider.areHardLinked( file3, file4 ) );

    var got = _.censor.filesHardLink( options );

    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.isHardLink( file4 ) );
    test.true( !a.fileProvider.areHardLinked( file3, file4 ) );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

  a.ready.then( ( op ) =>
  {
    test.case = 'hardlink ignored, excludingHyphened : 0';
    let profile = `test-${ _.intRandom( 1000000 ) }`;
    var options =
    {
      basePath : a.abs( '.' ),
      excludingHyphened : 0,
      profileDir : profile
    }
    test.true( !a.fileProvider.isHardLink( file3 ) );
    test.true( !a.fileProvider.isHardLink( file4 ) );
    test.true( !a.fileProvider.areHardLinked( file3, file4 ) );

    var got = _.censor.filesHardLink( options );

    test.true( a.fileProvider.isHardLink( file3 ) );
    test.true( a.fileProvider.isHardLink( file4 ) );
    test.true( a.fileProvider.areHardLinked( file3, file4 ) );

    _.censor.profileDel( profile );
    return null;
  });

  return a.ready;
}

// --
// test suite definition
// --

const Proto =
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

    renameBasic,
    listingReorder,
    listingReorderPartiallyOrdered,
    listingSqueeze,

    filesHardLink,
    filesHardLinkOptionExcludingPath,
    filesHardLinkOptionExcludingHyphened,

  }

}

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
