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

function profileDel( test )
{
  const a = test.assetFor( 'basic' );

  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const absoluteProfileDir = a.abs( a.path.dirUserHome(), _.censor.storageDir, profileDir );

  /* */

  test.case = 'no profile dir';
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with only config';
  _.censor.configSet({ profileDir, set : { name : profileDir } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with only arrangement';
  a.reflect();
  var options =
  {
    filePath : a.abs( 'before/File1.txt' ),
    ins : 'line',
    sub : 'abc',
    profileDir,
  };
  _.censor.fileReplace( options );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './arrangement.default.json' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external terminal file';
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external directory';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './dir' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file', './dir', './dir/file' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with config, external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  _.censor.configSet({ profileDir, set : { name : profileDir } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml', './file', './dir', './dir/file' ] );
  var got = _.censor.profileDel( profileDir );
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
}

//

function profileDelWithOptionsMap( test )
{
  const a = test.assetFor( 'basic' );

  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const absoluteProfileDir = a.abs( a.path.dirUserHome(), _.censor.storageDir, profileDir );

  /* */

  test.case = 'no profile dir';
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with only config';
  _.censor.configSet({ profileDir, set : { name : profileDir } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with only arrangement';
  a.reflect();
  var options =
  {
    filePath : a.abs( 'before/File1.txt' ),
    ins : 'line',
    sub : 'abc',
    profileDir,
  };
  _.censor.fileReplace( options );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './arrangement.default.json' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external terminal file';
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external directory';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './dir' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file', './dir', './dir/file' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );

  test.case = 'profile dir with config, external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  _.censor.configSet({ profileDir, set : { name : profileDir } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml', './file', './dir', './dir/file' ] );
  var got = _.censor.profileDel({ profileDir });
  test.identical( got, undefined );
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
}

//

function configRead( test )
{
  const a = test.assetFor( 'basic' );

  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const absoluteProfileDir = a.abs( a.path.dirUserHome(), _.censor.storageDir, profileDir );

  /* */

  test.case = 'no profile dir';
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with only config';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with only arrangement';
  a.reflect();
  var options =
  {
    filePath : a.abs( 'before/File1.txt' ),
    ins : 'line',
    sub : 'abc',
    profileDir,
  };
  _.censor.fileReplace( options );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './arrangement.default.json' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external terminal file';
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external directory';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './dir' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file', './dir', './dir/file' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with config, external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml', './file', './dir', './dir/file' ] );
  var got = _.censor.configRead( profileDir );
  test.identical( got, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );
}

//

function configReadWithOptionsMap( test )
{
  const a = test.assetFor( 'basic' );

  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const absoluteProfileDir = a.abs( a.path.dirUserHome(), _.censor.storageDir, profileDir );

  /* */

  test.case = 'no profile dir';
  test.false( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with only config';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with only arrangement';
  a.reflect();
  var options =
  {
    filePath : a.abs( 'before/File1.txt' ),
    ins : 'line',
    sub : 'abc',
    profileDir,
  };
  _.censor.fileReplace( options );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './arrangement.default.json' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external terminal file';
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external directory';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './dir' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './file', './dir', './dir/file' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, null );
  _.censor.profileDel( profileDir );

  test.case = 'profile dir with config, external directory and files in root and nested directories';
  a.fileProvider.dirMake( a.abs( absoluteProfileDir, 'dir' ) );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'file' ), 'file' );
  a.fileProvider.fileWrite( a.abs( absoluteProfileDir, 'dir/file' ), 'file' );
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  test.true( a.fileProvider.fileExists( absoluteProfileDir ) );
  var files = a.find( absoluteProfileDir );
  test.identical( files, [ '.', './config.yaml', './file', './dir', './dir/file' ] );
  var got = _.censor.configRead({ profileDir });
  test.identical( got, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );
}

//

function identityCopy( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  test.case = 'copy identity from existed config, single identity, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identityCopy({ profileDir, identitySrcName : 'user', identityDstName : 'user3' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( _.props.keys( config.identity ), [ 'user', 'user3' ] );
  test.identical( config.identity.user, { login : 'userLogin', type : 'general' } );
  test.identical( config.identity.user, config.identity.user3 );
  _.censor.profileDel( profileDir );

  test.case = 'copy identity from existed config, several identities, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( _.props.keys( config.identity ), [ 'user', 'user2' ] );
  var got = _.censor.identityCopy({ profileDir, identitySrcName : 'user', identityDstName : 'user3' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( _.props.keys( config.identity ), [ 'user', 'user2', 'user3' ] );
  test.identical( config.identity.user, { login : 'userLogin', type : 'general' } );
  test.identical( config.identity.user2, { login : 'userLogin2', type : 'general' } );
  test.identical( config.identity.user, config.identity.user3 );
  _.censor.profileDel( profileDir );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityCopy() );

  test.case = 'extra arguments';
  var o = { profileDir, identitySrcName : 'user', identityDstName : 'user2' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o, o ) );

  test.case = 'wrong type of options map';
  var o = { profileDir, identitySrcName : 'user', identityDstName : 'user2' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy([ o ]) );

  test.case = 'unknown option in options map';
  var o = { profileDir, identitySrcName : 'user', identityDstName : 'user2', unknown : 1 };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o ) );

  test.case = 'o.identitySrcName is not defined string';
  var o = { profileDir, identitySrcName : '', identityDstName : 'user2' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o ) );

  test.case = 'o.identitySrcName is string with glob, get several identities';
  _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin' } });
  _.censor.identityNew({ profileDir, identity : { name : 'user2', login : 'userLogin2' } });
  var o = { profileDir, identitySrcName : 'user*', identityDstName : 'user3' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o ) );
  _.censor.profileDel( profileDir );

  test.case = 'o.identityDstName is not defined string';
  var o = { profileDir, identitySrcName : 'user', identityDstName : '' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o ) );

  test.case = 'o.identityDstName is string with glob';
  var o = { profileDir, identitySrcName : 'user', identityDstName : 'user2*' };
  test.shouldThrowErrorSync( () => _.censor.identityCopy( o ) );

  test.case = 'config is not existed';
  test.shouldThrowErrorSync( () => _.censor.identityCopy({ profileDir, identitySrcName : 'user', identityDstName : 'user3' }) );

  test.case = 'config exists, identities not exist';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  test.shouldThrowErrorSync( () => _.censor.identityCopy({ profileDir, identitySrcName : 'user', identityDstName : 'user3' }) );
  _.censor.profileDel( profileDir );

  test.case = 'config exists, identity exists, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  test.shouldThrowErrorSync( () => _.censor.identityCopy({ profileDir, identitySrcName : 'user2', identityDstName : 'user3' }) );
  _.censor.profileDel( profileDir );
}

//

function identityGet( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  getAllIdentities( profileDir );
  getAllIdentities({ profileDir });
  getAllIdentities({ profileDir, selector : null });
  getAllIdentities({ profileDir, selector : '' });

  /* */

  function getAllIdentities( arg )
  {
    test.open( `${ _.entity.exportStringSolo( arg ) }` );

    test.case = 'get identities from not existed config';
    var config = _.censor.configRead({ profileDir });
    test.identical( config, null );
    var got = _.censor.identityGet( _.entity.make( arg ) );
    test.identical( got, undefined );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, identities not exist';
    _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : { name : profileDir }, path : {} } );
    var got = _.censor.identityGet( _.entity.make( arg ) );
    test.identical( got, undefined );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, single identity';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityGet( _.entity.make( arg ) );
    test.identical( got, { user : { login : 'userLogin', type : 'general' } } );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, several identities';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var identity = { name : 'user2', login : 'userLogin2' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityGet( _.entity.make( arg ) );
    var exp =
    {
      user : { login : 'userLogin', type : 'general' },
      user2 : { login : 'userLogin2', type : 'general' }
    };
    test.identical( got, exp );
    _.censor.profileDel( profileDir );

    test.close( `${ _.entity.exportStringSolo( arg ) }` );
  }

  /* - */

  test.open( 'with selector' );

  test.case = 'get identity from not existed config';
  var config = _.censor.configRead({ profileDir });
  test.identical( config, null );
  var got = _.censor.identityGet({ profileDir, selector : 'user' });
  test.identical( got, undefined );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, identities not exist';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var got = _.censor.identityGet({ profileDir, selector : 'user' });
  test.identical( got, undefined );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, single identity, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'user' });
  test.identical( got, { login : 'userLogin', type : 'general' } );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, single identity, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'user2' });
  test.identical( got, undefined );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, several identities, selector matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'user2' });
  test.identical( got, { login : 'userLogin2', type : 'general' } );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, several identities, selector matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'user3' });
  test.identical( got, undefined );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, several identities, selector with glob, matches identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'user*' });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' }
  };
  test.identical( got, exp );
  _.censor.profileDel( profileDir );

  test.case = 'get identity from existed config, several identities, selector with glob, matches not identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identityGet({ profileDir, selector : 'git*' });
  test.identical( got, {} );
  _.censor.profileDel( profileDir );

  test.close( 'with selector' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityGet() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.censor.identityGet( profileDir, profileDir ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityGet([ profileDir ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identityGet({ profileDir, selector : '', unknown : 1 }) );

  test.case = 'wrong type of o.selector';
  test.shouldThrowErrorSync( () => _.censor.identityGet({ profileDir, selector : undefined }) );
}

//

function identityList( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  getAllIdentities( profileDir );
  getAllIdentities({ profileDir });

  /* */

  function getAllIdentities( arg )
  {
    test.open( `${ _.entity.exportStringSolo( arg ) }` );

    test.case = 'get identities from not existed config';
    var config = _.censor.configRead({ profileDir });
    test.identical( config, null );
    var got = _.censor.identityList( _.entity.make( arg ) );
    test.identical( got, [] );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, identities not exist';
    _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
    var config = _.censor.configRead({ profileDir });
    test.identical( config, { about : { name : profileDir }, path : {} } );
    var got = _.censor.identityList( _.entity.make( arg ) );
    test.identical( got, [] );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, single identity';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityList( _.entity.make( arg ) );
    test.identical( got, [ 'user' ] );
    _.censor.profileDel( profileDir );

    test.case = 'get identities from existed config, several identities';
    var identity = { name : 'user', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    var identity = { name : 'user2', login : 'userLogin2' };
    _.censor.identityNew({ profileDir, identity });
    var config = _.censor.configRead({ profileDir });
    test.true( _.map.is( config.identity ) );
    var got = _.censor.identityList( _.entity.make( arg ) );
    test.identical( got, [ 'user', 'user2' ] );
    _.censor.profileDel( profileDir );

    test.close( `${ _.entity.exportStringSolo( arg ) }` );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityList() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.censor.identityList( profileDir, profileDir ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityList([ profileDir ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identityList({ profileDir, unknown : '' }) );
}

//

function identitySet( test )
{
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

  /* */

  test.case = 'set no properties in identity in config that not exists';
  var config = _.censor.configRead({ profileDir });
  test.identical( config, null );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : {} });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : {}, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'set properties into identity in config that not exists';
  var config = _.censor.configRead({ profileDir });
  test.identical( config, null );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : { login : 'userLogin' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : {}, path : {}, identity : { user : { login : 'userLogin' } } } );
  _.censor.profileDel( profileDir );

  /* */

  test.case = 'set no properties in identity in config that exists, identities not exist';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : {} });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  _.censor.profileDel( profileDir );

  test.case = 'set properties in identity in config that exists, identities not exist';
  _.censor.configSet({ profileDir, set : { about : { name : profileDir } } });
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {} } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : { login : 'userLogin' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config, { about : { name : profileDir }, path : {}, identity : { user : { login : 'userLogin' } } } );
  _.censor.profileDel( profileDir );

  /* */

  test.case = 'set no properties in identity in config that exists, single identity, identityName matches identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : {} });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'set properties in identity in config that exists, single identity, identityName matches identity, replace';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : { type : 'git' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'git' } } );
  _.censor.profileDel( profileDir );

  test.case = 'set properties in identity in config that exists, single identity, identityName matches identity, extend';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user', set : { email : 'user@domain.com' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general', email : 'user@domain.com' } } );
  _.censor.profileDel( profileDir );

  /* */

  test.case = 'set no properties in identity in config that exists, single identity, identityName matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user2', set : {} });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  _.censor.profileDel( profileDir );

  test.case = 'set properties in identity in config that exists, single identity, identityName matches not identity';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' } } );
  var got = _.censor.identitySet({ profileDir, identityName : 'user2', set : { login : 'userLogin2' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity, { user : { login : 'userLogin', type : 'general' }, user2 : { login : 'userLogin2' } } );
  _.censor.profileDel( profileDir );

  /* */

  test.case = 'set no properties in identity in config that exists, several identities, identityName with glob, matches identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identitySet({ profileDir, identityName : 'user*', set : {} });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    user : { login : 'userLogin', type : 'general' },
    user2 : { login : 'userLogin2', type : 'general' }
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set properties in identity in config that exists, several identities, identityName with glob, matches identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var config = _.censor.configRead({ profileDir });
  test.true( _.map.is( config.identity ) );
  var got = _.censor.identitySet({ profileDir, identityName : 'user*', set : { login : 'userLogin3' } });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  var exp =
  {
    'user' : { login : 'userLogin3', type : 'general' },
    'user2' : { login : 'userLogin3', type : 'general' },
  };
  test.identical( config.identity, exp );
  _.censor.profileDel( profileDir );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identitySet() );

  test.case = 'extra arguments';
  var o = { profileDir, identityName : 'user', set : {} };
  test.shouldThrowErrorSync( () => _.censor.identitySet( o, o ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identitySet([ { profileDir, identityName : 'user', set : {} } ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identitySet({ profileDir, identityName : 'user', set : {}, unknown : 1 }) );

  test.case = 'o.identityName is not defined string';
  test.shouldThrowErrorSync( () => _.censor.identitySet({ profileDir, identityName : '', set : {} }) );

  test.case = 'wrong type of o.set';
  test.shouldThrowErrorSync( () => _.censor.identitySet({ profileDir, identityName : 'user', set : null }) );
}


//

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

  test.case = 'o.identity.*login is not defined string';
  var o = { profileDir, identity : { name : 'user', login : '' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  var o = { profileDir, identity : { name : 'user', login : null } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  var o = { profileDir, identity : { 'name' : 'user', 'git.login' : '' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  var o = { profileDir, identity : { 'name' : 'user', 'git.login' : null } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );

  test.case = 'try to create identity with the existed name';
  var o = { profileDir, identity : { name : 'user', login : 'userLogin' } };
  _.censor.identityNew( o );
  var o = { profileDir, identity : { name : 'user', login : 'different' } };
  test.shouldThrowErrorSync( () => _.censor.identityNew( o ) );
  _.censor.profileDel( profileDir );
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
  test.shouldThrowErrorSync( () => _.censor.identityDel( profileDir, profileDir ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityDel([ profileDir ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identityDel({ profileDir, selector : '', unknown : 1 }) );

  test.case = 'wrong type of o.selector';
  test.shouldThrowErrorSync( () => _.censor.identityDel({ profileDir, selector : undefined }) );
}

//

function identityHookSet( test )
{
  const a = test.assetFor( false );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );
  const hook = 'console.log( `hook` );';

  /* */

  test.case = 'set git hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/git',
    './hook/git/GitIdentity.user.js'
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set npm hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'npm', selector : 'user' });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/npm',
    './hook/npm/NpmIdentity.user.js'
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set hooks for general type';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'general', selector : 'user' });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/git',
    './hook/git/GitIdentity.user.js',
    './hook/npm',
    './hook/npm/NpmIdentity.user.js',
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set git hooks for different identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
  _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user2' });
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/git',
    './hook/git/GitIdentity.user.js',
    './hook/git/GitIdentity.user2.js',
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet() );

  test.case = 'extra arguments';
  var o = { profileDir, hook, type : 'git', selector : 'user' };
  test.shouldThrowErrorSync( () => _.censor.identityHookSet( o, o ) );

  test.case = 'wrong type of options map';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet([ { profileDir, hook, type : 'git', selector : 'user' } ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user', unknown : 1 }) );

  test.case = 'wrong type of o.type';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : null, selector : 'user' }) );

  test.case = 'unknown type of o.type';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'unknown', selector : 'user' }) );

  test.case = 'o.selector is glob';
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'unknown', selector : 'user*' }) );

  test.case = 'identity type is not equal to o.type, not general identity type';
  _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin', type : 'npm' } });
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' }) );
  _.censor.profileDel( profileDir );
  _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin', type : 'npm' } });
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'general', selector : 'user' }) );
  _.censor.profileDel( profileDir );
}

//

function identityHookSetWithOptionDefault( test )
{
  const a = test.assetFor( false );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );
  const hook = 'console.log( `hook` );';

  /* */

  test.case = 'set default git hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : '', default : true });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/git',
    './hook/git/GitIdentity.js'
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set default npm hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'npm', selector : '', default : true });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/npm',
    './hook/npm/NpmIdentity.js'
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  test.case = 'set default hooks for general type';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var files = a.find( userProfileDir );
  test.identical( files, [ '.', './config.yaml' ] );
  var got = _.censor.identityHookSet({ profileDir, hook, type : 'general', selector : '', default : true });
  test.identical( got, undefined );
  var files = a.find( userProfileDir );
  var exp =
  [
    '.',
    './config.yaml',
    './hook',
    './hook/git',
    './hook/git/GitIdentity.js',
    './hook/npm',
    './hook/npm/NpmIdentity.js',
  ];
  test.identical( files, exp );
  _.censor.profileDel( profileDir );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'default - true, selector - not empty string';
  _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin' } });
  test.shouldThrowErrorSync( () => _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user', default : true }) );
  _.censor.profileDel( profileDir );
}

//

function identityHookCallWithDefaultGitHook( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  a.fileProvider.dirMake( a.abs( '.' ) );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );

  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );

  /* - */

  begin().then( () =>
  {
    test.case = 'call git hook';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin();
  a.shell( 'git config --global user.name anotherUser' )
  a.ready.then( () =>
  {
    test.case = 'git user name exists';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'call twice';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'change identity';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com' };
    _.censor.identityNew({ profileDir, identity });
    var identity = { name : 'user2', login : 'userLogin2', email : 'user2@domain.com' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
    var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user2' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user2@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
      return null;
    });
  }

  /* */

  function requireClean()
  {
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/git/GitIdentity.js' ) ) ];
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/npm/NpmIdentity.js' ) ) ];
  }
}

//

function identityHookCallWithDefaultNpmHook( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  a.fileProvider.dirMake( a.abs( '.' ) );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );
  const login = 'wtools-bot';
  const npmPass = process.env.PRIVATE_WTOOLS_BOT_NPM_PASS;
  const email = process.env.PRIVATE_WTOOLS_BOT_EMAIL;

  if( !npmPass || !email )
  return test.true( true );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'call npm hook';
    var identity = { name : 'user', login, email, npmPass };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'npm', selector : 'user' });
    test.identical( got, undefined );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'npm whoami' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), login );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'call npm hook twice';
    var identity = { name : 'user', login, email, npmPass };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var got = _.censor.identityHookCall({ profileDir, type : 'npm', selector : 'user' });
    var got = _.censor.identityHookCall({ profileDir, type : 'npm', selector : 'user' });
    test.identical( got, undefined );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'npm whoami' )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output.trim(), login );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function requireClean()
  {
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/git/GitIdentity.js' ) ) ];
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/npm/NpmIdentity.js' ) ) ];
  }
}

//

function identityHookCallWithUserHooks( test )
{
  const a = test.assetFor( false );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );
  const hook =
`function onIdentity( identity )
{
  const _ = this;
  _.censor.identitySet({ profileDir : '${ profileDir }', identityName : 'user', set : { email : 'user@domain.com' } });
}
module.exports = onIdentity;`;
  const hook2 =
`function onIdentity( identity )
{
  const _ = this;
  debugger;
  _.censor.identitySet({ profileDir : '${ profileDir }', identityName : 'user', set : { token : 'userToken' } });
}
module.exports = onIdentity;`;

  /* */

  test.case = 'call git hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, undefined );
  var got = _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, 'user@domain.com' );
  _.censor.profileDel( profileDir );
  requireClean();

  test.case = 'call npm hook';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  _.censor.identityHookSet({ profileDir, hook, type : 'npm', selector : 'user' });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, undefined );
  var got = _.censor.identityHookCall({ profileDir, type : 'npm', selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, 'user@domain.com' );
  _.censor.profileDel( profileDir );
  requireClean();

  test.case = 'call hooks for general type';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
  _.censor.identityHookSet({ profileDir, hook : hook2, type : 'npm', selector : 'user' });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, undefined );
  test.identical( config.identity.user.token, undefined );
  var got = _.censor.identityHookCall({ profileDir, type : 'general', selector : 'user' });
  test.identical( got, undefined );
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, 'user@domain.com' );
  test.identical( config.identity.user.token, 'userToken' );
  _.censor.profileDel( profileDir );
  requireClean();

  test.case = 'call git hooks for different identities';
  var identity = { name : 'user', login : 'userLogin' };
  _.censor.identityNew({ profileDir, identity });
  var identity = { name : 'user2', login : 'userLogin2' };
  _.censor.identityNew({ profileDir, identity });
  _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
  _.censor.identityHookSet({ profileDir, hook : hook2, type : 'npm', selector : 'user2' });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, undefined );
  test.identical( config.identity.user.token, undefined );
  test.identical( config.identity.user2.email, undefined );
  test.identical( config.identity.user2.token, undefined );
  _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' });
  _.censor.identityHookCall({ profileDir, type : 'npm', selector : 'user2' });
  var config = _.censor.configRead({ profileDir });
  test.identical( config.identity.user.email, 'user@domain.com' );
  test.identical( config.identity.user.token, 'userToken' );
  test.identical( config.identity.user2.email, undefined );
  test.identical( config.identity.user2.token, undefined );
  _.censor.profileDel( profileDir );
  requireClean();

  /* - */

  if( Config.debug )
  {
    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall() );

    test.case = 'extra arguments';
    var o = { profileDir, type : 'git', selector : 'user' };
    test.shouldThrowErrorSync( () => _.censor.identityHookCall( o, o ) );

    test.case = 'wrong type of options map';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall([ { profileDir, type : 'git', selector : 'user' } ]) );

    test.case = 'unknown option in options map';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user', unknown : 1 }) );

    test.case = 'wrong type of o.type';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : null, selector : 'user' }) );

    test.case = 'unknown type of o.type';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'unknown', selector : 'user' }) );

    test.case = 'o.selector is glob';
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'unknown', selector : 'user*' }) );

    test.case = 'identity type is not equal to o.type, not general identity type';
    _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin', type : 'npm' } });
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' }) );
    _.censor.profileDel( profileDir );
    _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin', type : 'npm' } });
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'general', selector : 'user' }) );
    _.censor.profileDel( profileDir );

    test.case = 'hook return no routine';
    _.censor.identityNew({ profileDir, identity : { name : 'user', login : 'userLogin' } });
    _.censor.identityHookSet({ profileDir, hook : 'console.log( `hook` );', type : 'git', selector : 'user' });
    test.shouldThrowErrorSync( () => _.censor.identityHookCall({ profileDir, type : 'git', selector : 'user' }) );
    _.censor.profileDel( profileDir );
  }

  /* */

  function requireClean()
  {
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/git/GitIdentity.user.js' ) ) ];
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/npm/NpmIdentity.user.js' ) ) ];
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/npm/NpmIdentity.user2.js' ) ) ];
  }
}

//

function identityUse( test )
{
  const a = test.assetFor( false );

  if( !_.process.insideTestContainer() )
  return test.true( true );

  a.fileProvider.dirMake( a.abs( '.' ) );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;
  const userProfileDir = a.fileProvider.configUserPath( `.censor/${ profileDir }` );

  const originalConfig = a.fileProvider.fileRead( a.fileProvider.configUserPath( '.gitconfig' ) );

  const hook =
`function onIdentity( identity )
{
  const _ = this;
  _.censor.identitySet({ profileDir : '${ profileDir }', identityName : 'user', set : { email : 'user@domain.com' } });
}
module.exports = onIdentity;`;

  /* - */

  begin().then( () =>
  {
    test.case = 'use git identity from scratch, no type';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com', type : 'git' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', email : 'user@domain.com', type : 'git' } );
    test.identical( config.identity._current, undefined );
    test.identical( config.identity._previous, undefined );
    var got = _.censor.identityUse({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._current, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._previous, undefined );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'use git identity from scratch';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com', type : 'git' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._current, undefined );
    test.identical( config.identity._previous, undefined );
    var got = _.censor.identityUse({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._current, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._previous, undefined );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'switch several identities';
    var identity = { name : 'user', login : 'userLogin', email : 'user@domain.com', type : 'git' };
    _.censor.identityNew({ profileDir, identity });
    var identity = { name : 'user2', login : 'userLogin2', email : 'user2@domain.com', type : 'general' };
    _.censor.identityNew({ profileDir, identity });
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity.user2, { login : 'userLogin2', type : 'general', email : 'user2@domain.com' } );
    test.identical( config.identity._current, undefined );
    test.identical( config.identity._previous, undefined );

    var got = _.censor.identityUse({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity.user2, { login : 'userLogin2', type : 'general', email : 'user2@domain.com' } );
    test.identical( config.identity._current, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity._previous, undefined );

    var got = _.censor.identityUse({ profileDir, type : 'git', selector : 'user2' });
    test.identical( got, undefined );
    var files = a.find( userProfileDir );
    test.identical( files, [ '.', './config.yaml', './hook', './hook/git', './hook/git/GitIdentity.js' ] );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    test.identical( config.identity.user2, { login : 'userLogin2', type : 'general', email : 'user2@domain.com' } );
    test.identical( config.identity._current, { login : 'userLogin2', type : 'general', email : 'user2@domain.com' } );
    test.identical( config.identity._previous, { login : 'userLogin', type : 'git', email : 'user@domain.com' } );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });
  a.shell( 'git config --global --list' )
  .then( ( op ) =>
  {
    test.identical( _.strCount( op.output, 'user.name=userLogin2' ), 1 );
    test.identical( _.strCount( op.output, 'user.email=user2@domain.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@github.com.insteadof=https://github.com' ), 1 );
    test.identical( _.strCount( op.output, 'url.https://userLogin2@bitbucket.org.insteadof=https://bitbucket.org' ), 1 );
    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'call user hook';
    var identity = { name : 'user', type : 'git', login : 'userLogin' };
    _.censor.identityNew({ profileDir, identity });
    _.censor.identityHookSet({ profileDir, hook, type : 'git', selector : 'user' });
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user.email, undefined );
    var got = _.censor.identityUse({ profileDir, type : 'git', selector : 'user' });
    test.identical( got, undefined );
    var config = _.censor.configRead({ profileDir });
    test.identical( config.identity.user.email, 'user@domain.com' );
    _.censor.profileDel( profileDir );
    requireClean();
    return null;
  });

  /* */

  a.ready.finally( ( err, arg ) =>
  {
    a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), originalConfig );
    if( err )
    throw _.err( err );
    return arg;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    return a.ready.then( () =>
    {
      a.fileProvider.fileWrite( a.fileProvider.configUserPath( '.gitconfig' ), '' );
      return null;
    });
  }

  /* */

  function requireClean()
  {
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/git/GitIdentity.js' ) ) ];
    delete require.cache[ a.path.nativize( a.abs( userProfileDir, 'hook/npm/NpmIdentity.js' ) ) ];
  }
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
    };

    var got = _.censor.fileReplace( options );
    test.identical( got.parcels.length, 3 );

    _.censor.profileDel( profile );
    return null;
  });

  /* */

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
    };

    var got = _.censor.fileReplace( options );
    test.identical( got.parcels.length, 5 );

    _.censor.profileDel( profile );
    return null;
  });

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
  const a = test.assetFor( false );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

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
  const a = test.assetFor( 'listingSqueeze' );
  const profileDir = `test-${ _.intRandom( 1000000 ) }`;

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
    profileDel,
    profileDelWithOptionsMap,

    configRead,
    configReadWithOptionsMap,

    identityCopy,
    identityGet,
    identityList,
    identitySet,
    identityNew,
    identityDel,
    identityHookSet,
    identityHookSetWithOptionDefault,
    identityHookCallWithDefaultGitHook,
    identityHookCallWithDefaultNpmHook,
    identityHookCallWithUserHooks,
    identityUse,

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
