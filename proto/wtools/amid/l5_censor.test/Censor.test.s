( function _Censor_test_s_()
{

'use strict';

/* xxx : qqq : check no garbage left in ~/.censor/* */
/* xxx : qqq : check default profile is not demaged in ~/.censor/default/* especiall ~/.censor/default/config.yaml */

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

function identityNew( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  test.case = 'add identity to not existed config';
  var identity = { name : 'user', login : 'userLogin' };
  var got = _.censor.identityNew({ profileDir, identity });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'add identity to existed config';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var identity = { name : 'user', login : 'userLogin' };
  var got = _.censor.identityNew({ profileDir, identity });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.about, { name : profileDir } );
  test.identical( config.path, {} );
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'add several identities to not existed config';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' }
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.case = 'add several identities to existed config';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' }
  };
  test.identical( config.about, { name : profileDir } );
  test.identical( config.path, {} );
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.case = 'create identity with user defined fields';
  var identity = { name : 'user', login : 'userLogin', type : 'git', email : 'user@domain.com', token : 'someToken' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  var exp = { user : { login : 'userLogin', type : 'git', email : 'user@domain.com', token : 'someToken' } };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityNew() );

  test.case = 'extra arguments';
  var o = { profileDir, identity : { name : 'user', login : 'userLogin' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o, o ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityNew( 'wrong' ) );

  test.case = 'unknown option in options map';
  var o = { profileDir, identity : { name : 'user', login : 'userLogin' }, unknown : 1 };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'wrong type of o.identity';
  var o = { profileDir, identity : [ { name : 'user', login : 'userLogin' } ] };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'unknown o.identity.type';
  var o = { profileDir, identity : { name : 'user', login : 'userLogin', type : 'unknown' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'o.identity.name is not defined string';
  var o = { profileDir, identity : { name : '', login : 'userLogin' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  var o = { profileDir, identity : { name : null, login : 'userLogin' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'o.identity.login is not defined string';
  var o = { profileDir, identity : { name : 'user', login : '' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  var o = { profileDir, identity : { name : 'user', login : null } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'try to create identity with the existed name';
  var o = { profileDir, identity : { name : 'user', login : 'userLogin' } };
  _.censor.identityNew( o );
  var o = { profileDir, identity : { name : 'user', login : 'different' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
}

//

function identityDel( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  delAllIdentities( profileDir );
  delAllIdentities({ profileDir });
  delAllIdentities({ profileDir, selector : null });
  delAllIdentities({ profileDir, selector : '' });

  /* */

  function delAllIdentities( arg )
  {
    test.open( `${ _.entity.exportStringSolo( arg ) }` );

    test.case = 'del identities from not existed config';
    var config = _.censor.configRead({ profileDir });
    test.identical( config, null );
    var got = _.censor.identityDel( _.entity.make( arg ) );
    test.identical( got, undefined );
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : {}, path : {} } );
    _.censor.profileDel( profileDir );

    test.case = 'del identities from existed config, identities not exist';
    _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : { name : profileDir }, path : {} } );
    var got = _.censor.identityDel( _.entity.make( arg ) );
    test.identical( got, undefined );
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : { name : profileDir }, path : {} } );
    _.censor.profileDel( profileDir );

    test.case = 'del identities from existed config, single identity';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityDel( _.entity.make( arg ) );
    test.identical( got, undefined );
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : {}, path : {} } );
    _.censor.profileDel( profileDir );

    test.case = 'del identities from existed config, several identities';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var identity = { name : 'user2', login : 'userLogin2' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityDel( _.entity.make( arg ) );
    test.identical( got, undefined );
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : {}, path : {} } );
    _.censor.profileDel( profileDir );

    test.close( `${ _.entity.exportStringSolo( arg ) }` );
  }

  /* - */

  test.open( 'with selector' );

  test.case = 'del identity from not existed config';
  var config = _.censor.configRead({ profileDir });
  test.identical( config, null );
  var got = _.censor.identityDel({ profileDir, selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : {}, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, identities not exist';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var got = _.censor.identityDel({ profileDir, selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, single identity, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : {}, path : {}, identity : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, single identity, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user2' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, several identities, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user2' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, several identities, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user3' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' },
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, several identities, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user3' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' },
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.case = 'del identity from existed config, several identities, selector with glob';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityDel({ profileDir, selector : 'user*' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' },
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.close( 'with selector' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityDel() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.censor.identityDel( profileDel, profileDel ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityDel([ profileDel ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identityDel({ profileDir, selector : '', unknown : 1 }) );

  test.case = 'wrong type of o.selector';
  test.shouldThrowErrorSync( () => _.censor.identityDel({ profileDir, selector : undefined }) );
}

//

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

  a.reflect();
  let file3 = a.abs( 'dir2/-File1.txt' );
  let file4 = a.abs( 'dir2/-File2.txt' );
  a.fileProvider.fileWrite( file3, 'file' )
  a.fileProvider.fileWrite( file4, 'file' )

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

    identityNew,
    identityDel,

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
