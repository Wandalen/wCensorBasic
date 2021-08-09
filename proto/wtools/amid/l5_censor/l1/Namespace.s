( function _Namespace_s_( )
{

'use strict';

const _ = _global_.wTools;
_.censor = _.censor || Object.create( null );

// --
// storage
// --

function _storageNameMapFromDefaults( o )
{

  if( o.storageDir === null )
  o.storageDir = _.censor.storageDir;

  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );

  let storageName = _.path.normalize( o.storageDir );

  return storageName;
}

//

function storageNameMapFrom( o )
{
  let self = this;

  o = _.routine.options( storageNameMapFrom, o );
  self._storageNameMapFromDefaults( o );

  _.fileProvider.storageProfileNameMapFrom( o );

  return o;
}

storageNameMapFrom.defaults =
{
  storageName : null,
  storagePath : null,
  storageDir : null,
  profileDir : null,
}

//

function storageRead( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( storageRead, o );

  self._storageNameMapFromDefaults( o );

  return _.fileProvider.storageRead( o );
}

storageRead.defaults =
{
  storageDir : null,
}

//

function storageDel( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( storageDel, o );

  self._storageNameMapFromDefaults( o );

  return _.fileProvider.storageDel( o );
}

storageDel.defaults =
{
  storageDir : null,
  verbosity : 0,
}

//

function storageLog( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( storageLog, o );
  self._storageNameMapFromDefaults( o );

  if( o.logger === null )
  o.logger = _global_.logger;

  let o2 = _.mapOnly_( null, o, _.censor.storageRead.defaults );
  let read = _.censor.storageRead( o2 );

  if( !o.verbosity )
  return;

  if( o.verbosity <= 1 )
  {
    o.logger.log( _.entity.exportJs( _.props.keys( read ) ) );
    return;
  }

  o.logger.log( _.entity.exportJs( read ) );

}

storageLog.defaults =
{
  storageDir : null,
  logger : null,
  verbosity : 3,
}

//

function _profileNameMapFromDefaults( o )
{

  if( o.storageDir === null )
  o.storageDir = _.censor.storageDir;
  if( o.profileDir === null )
  o.profileDir = _.censor.storageProfileDir;

  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
  _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );

  let storageName = _.path.join( o.storageDir, o.profileDir );

  return storageName;
}

//

function profileNameMapFrom( o )
{
  let self = this;

  o = _.routine.options( profileNameMapFrom, o );
  self._profileNameMapFromDefaults( o );

  _.fileProvider.storageProfileNameMapFrom( o );

  return o;
}

profileNameMapFrom.defaults =
{
  storageName : null,
  storagePath : null,
  storageDir : null,
  profileDir : null,
}

//

function profileRead( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( profileRead, o );

  self._profileNameMapFromDefaults( o );

  return _.fileProvider.storageProfileRead( o );
}

profileRead.defaults =
{
  ... profileNameMapFrom.defaults,
}

//

function profileDel( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { profileDir : arguments[ 0 ] };
  o = _.routine.options( profileDel, o );

  self._profileNameMapFromDefaults( o );

  return _.fileProvider.storageProfileDel( o );
}

profileDel.defaults =
{
  ... profileNameMapFrom.defaults,
  verbosity : 0,
}

//

function profileLog( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( profileLog, o );
  self._profileNameMapFromDefaults( o );

  if( o.logger === null )
  o.logger = _global_.logger;

  let o2 = _.mapOnly_( null, o, _.censor.profileRead.defaults );
  let read = _.censor.profileRead( o2 );

  if( !o.verbosity )
  return;

  if( o.verbosity <= 1 )
  {
    o.logger.log( _.entity.exportJs( _.props.keys( read ) ) );
    return;
  }

  o.logger.log( _.entity.exportJs( read ) );

}

profileLog.defaults =
{
  ... profileNameMapFrom.defaults,
  logger : null,
  verbosity : 3,
}

//

function _configNameMapFromDefaults( o )
{

  if( o.storageDir === null )
  o.storageDir = _.censor.storageDir;
  if( o.profileDir === null )
  o.profileDir = _.censor.storageProfileDir;
  if( o.storageTerminal === null )
  o.storageTerminal = _.censor.storageConfigTerminal;
  if( o.storageTerminalPrefix === null )
  o.storageTerminalPrefix = '';
  if( o.storageTerminalPostfix === null )
  o.storageTerminalPostfix = '';

  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
  _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );
  _.assert( _.strIs( o.storageTerminalPrefix ), 'Expects defined {- o.storageTerminalPrefix -}' );
  _.assert( _.strIs( o.storageTerminal ), 'Expects defined {- o.storageTerminal -}' );
  _.assert( _.strIs( o.storageTerminalPostfix ), 'Expects defined {- o.storageTerminalPostfix -}' );

  let storageName = _.path.join
  (
    o.storageDir,
    o.profileDir,
    o.storageTerminalPrefix + o.storageTerminal + o.storageTerminalPostfix,
  );

  return storageName;
}

//

function configNameMapFrom( o )
{
  let self = this;

  o = _.routine.options( configNameMapFrom, o );
  self._configNameMapFromDefaults( o );

  _.fileProvider.storageTerminalNameMapFrom( o );

  return o;
}

configNameMapFrom.defaults =
{
  storageName : null,
  storagePath : null,
  storageDir : null,
  profileDir : null,
  storageTerminalPrefix : null,
  storageTerminal : null,
  storageTerminalPostfix : null,
}

//

function configRead( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { profileDir : arguments[ 0 ] };
  o = _.routine.options( configRead, o || null );

  self._configNameMapFromDefaults( o );

  return _.fileProvider.storageTerminalRead( o );
}

configRead.defaults =
{
  ... configNameMapFrom.defaults,
}

//

function configOpen( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( configOpen, o );

  self._configNameMapFromDefaults( o );

  o.onStorageConstruct = onStorageConstruct;

  return _.fileProvider.storageTerminalOpen( o );

  function onStorageConstruct( o )
  {
    o.storage = _.censor.Config.make();
    return o.storage;
  }
}

configOpen.defaults =
{
  locking : 1,
  throwing : 1,
  ... configNameMapFrom.defaults,
}

//

function configClose( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( configClose, o );

  self._configNameMapFromDefaults( o );

  _.assert( _.mapIs( o.storage ) );

  return _.fileProvider.storageTerminalClose( o );
}

configClose.defaults =
{
  ... configOpen.defaults,
  storage : null,
  onStorageConstruct : null,
}

//

function configLog( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( configLog, o );
  self._configNameMapFromDefaults( o );

  if( o.logger === null )
  o.logger = _global_.logger;

  let o2 = _.mapOnly_( null, o, _.censor.configRead.defaults );
  let read = _.censor.configRead( o2 );

  o.logger.log( _.entity.exportJs( read ) );

}

configLog.defaults =
{
  ... configNameMapFrom.defaults,
  logger : null,
  verbosity : 3,
}

//

function configGet( o )
{
  let self = this;
  let result = [];

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] }; /* xxx : should be selector */
  o = _.routine.options( configGet, o );
  self._configNameMapFromDefaults( o );

  let o2 = _.mapOnly_( null, o, _.censor.configOpen.defaults );
  let opened = _.censor.configOpen( o2 );

  o.selector = _.array.as( o.selector );

  _.assert( _.strsAreAll( o.selector ) );

  if( o.selector.length )
  {
    for( let d = 0 ; d < o.selector.length ; d++ )
    result[ d ] = _.select
    ({
      src : opened.storage,
      selector : o.selector[ d ],
    });
  }
  else
  {
  }

  _.censor.configClose( opened );

  if( result.length === 1 )
  result = result[ 0 ];

  return result;
}

configGet.defaults =
{
  ... configNameMapFrom.defaults,
  locking : 1,
  selector : null,
}

//

function configSet( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( configSet, o );
  self._configNameMapFromDefaults( o );

  let o2 = _.mapOnly_( null, o, _.censor.configOpen.defaults );
  let opened = _.censor.configOpen( o2 );

  _.assert( _.mapIs( o.set ) );
  for( let key in o.set )
  _.selectSet
  ({
    src : opened.storage,
    selector : key,
    set : o.set[ key ],
  });

  _.censor.configClose( opened );

  return opened.storage;
}

configSet.defaults =
{
  ... configNameMapFrom.defaults,
  locking : 1,
  set : null,
}

//

function configDel( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( configDel, o );
  self._configNameMapFromDefaults( o );

  let o2 = _.mapOnly_( null, o, _.censor.configOpen.defaults );

  o.selector = _.array.as( o.selector );

  _.assert( _.strsAreAll( o.selector ) );

  if( o.selector.length )
  {
    let opened = _.censor.configOpen( o2 );
    for( let d = 0 ; d < o.selector.length ; d++ )
    _.select
    ({
      src : opened.storage,
      selector : o.selector[ d ],
      action : _.selector.Action.del,
      // set : undefined,
    });
    _.censor.configClose( opened );
    return opened.storage;
  }
  else
  {
    // if( opened.storage )
    // _.mapDelete( opened.storage );
    // else
    // opened.storage = Object.create( null );
    _.fileProvider.storageTerminalDel( _.mapOnly_( null, o, _.fileProvider.storageTerminalDel.defaults ) );
  }

}

configDel.defaults =
{
  ... configNameMapFrom.defaults,
  locking : 1,
  selector : null,
}

//

function _arrangementNameMapFromDefaults( o )
{

  if( o.storageDir === null )
  o.storageDir = _.censor.storageDir;
  if( o.profileDir === null )
  o.profileDir = _.censor.storageProfileDir;
  if( o.storageTerminalPrefix === null )
  o.storageTerminalPrefix = _.censor.storageArrangementPrefix;
  if( o.storageTerminal === null )
  o.storageTerminal = _.censor.storageArrangementTerminal;
  if( o.storageTerminalPostfix === null )
  o.storageTerminalPostfix = _.censor.storageArrangementPostfix;

  _.assert( _.mapIs( o ) );
  _.assert( _.strIs( o.storageDir ), 'Expects defined {- o.storageDir -}' );
  _.assert( _.strIs( o.profileDir ), 'Expects defined {- o.profileDir -}' );
  _.assert( _.strIs( o.storageTerminalPrefix ), 'Expects defined {- o.storageTerminalPrefix -}' );
  _.assert( _.strIs( o.storageTerminal ), 'Expects defined {- o.storageTerminal -}' );
  _.assert( _.strIs( o.storageTerminalPostfix ), 'Expects defined {- o.storageTerminalPostfix -}' );

  let storageName = _.path.join
  (
    o.storageDir,
    o.profileDir,
    o.storageTerminalPrefix + o.storageTerminal + o.storageTerminalPostfix,
  );

  return storageName;
}

//

function arrangementNameMapFrom( o )
{
  let self = this;

  o = _.routine.options( arrangementNameMapFrom, o );
  self._arrangementNameMapFromDefaults( o );

  _.fileProvider.storageTerminalNameMapFrom( o );

  return o;
}

arrangementNameMapFrom.defaults =
{
  storageName : null,
  storagePath : null,
  storageDir : null,
  profileDir : null,
  storageTerminalPrefix : null,
  storageTerminal : null,
  storageTerminalPostfix : null,
}

//

function arrangementRead( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( arrangementRead, o );

  self._arrangementNameMapFromDefaults( o );

  return _.fileProvider.storageTerminalRead( o );
}

arrangementRead.defaults =
{
  ... arrangementNameMapFrom.defaults,
}

//

function arrangementOpen( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.optionsWithoutUndefined( arrangementOpen, o );

  self._arrangementNameMapFromDefaults( o );

  o.onStorageConstruct = onStorageConstruct;

  return _.fileProvider.storageTerminalOpen( o );

  function onStorageConstruct( o )
  {
    o.storage = _.censor.Arrangement.make();
    return o.storage;
  }
}

arrangementOpen.defaults =
{
  ... arrangementNameMapFrom.defaults,
  locking : 1,
  throwing : 1,
}

//

function arrangementClose( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( arrangementClose, o );

  self._arrangementNameMapFromDefaults( o );

  _.assert( _.mapIs( o.storage ) );

  return _.fileProvider.storageTerminalClose( o );
}

arrangementClose.defaults =
{
  ... arrangementOpen.defaults,
  storage : null,
  onStorageConstruct : null,
}

//

function arrangementDel( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  if( !arguments.length )
  o = Object.create( null );
  o = _.routine.options( arrangementDel, o );

  self._arrangementNameMapFromDefaults( o );

  return _.fileProvider.storageTerminalDel( o );
}

arrangementDel.defaults =
{
  ... arrangementNameMapFrom.defaults,
  verbosity : 0,
  /* qqq xxx : add option logger */
}

//

function arrangementLog( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routine.options( arrangementLog, o );
  self._arrangementNameMapFromDefaults( o );

  if( o.logger === null )
  o.logger = _global_.logger;

  let o2 = _.mapOnly_( null, o, _.censor.arrangementRead.defaults );
  let read = _.censor.arrangementRead( o2 );

  o.logger.log( _.entity.exportJs( read ) );

}

arrangementLog.defaults =
{
  ... arrangementNameMapFrom.defaults,
  logger : null,
  verbosity : 3,
}

// --
// identity
// --

function identityCopy( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument.' );
  _.routine.options( identityCopy, o );
  _.assert( _.str.defined( o.identitySrcName ), 'Expects defined option {-o.identitySrcName-}.' );
  _.assert( _.str.defined( o.identityDstName ), 'Expects defined option {-o.identityDstName-}.' );
  _.assert( !_.path.isGlob( o.identityDstName ), 'Expects no globs' );

  self._configNameMapFromDefaults( o );

  const o2 = _.mapOnly_( null, o, self.identityGet.defaults );
  o2.selector = o.identitySrcName;
  const identity = self.identityGet( o2 );
  _.assert( _.map.is( identity ), `Selected no identity : ${ o.identitySrcName }. Please, improve selector.` );
  _.assert
  (
    'login' in identity && 'type' in identity,
    `Selected ${ _.props.keys( identity ).length } identity(s). Please, improve selector.`
  );

  const o3 = _.mapOnly_( null, o, self.identityNew.defaults );
  identity.name = o.identityDstName;
  o3.identity = identity;

  return self.identityNew( o3 );
}

identityCopy.defaults =
{
  ... configNameMapFrom.defaults,
  identitySrcName : null,
  identityDstName : null,
};

//

function identityGet( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( _.str.is( arguments[ 0 ] ) )
  o = { profileDir : arguments[ 0 ] };
  _.routine.options( identityGet, o );

  self._configNameMapFromDefaults( o );

  if( o.selector === null )
  o.selector = '';
  _.assert( _.str.is( o.selector ) );
  o.selector = `identity/${ o.selector }`;

  return self.configGet( o );
}

identityGet.defaults =
{
  ... configNameMapFrom.defaults,
  selector : null,
};

//

function identityList( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( _.str.is( arguments[ 0 ] ) )
  o = { profileDir : arguments[ 0 ] };
  _.map.assertHasOnly( o, identityList.defaults );

  const identities = self.identityGet( o );
  if( !_.map.is( identities ) )
  return [];
  return _.props.keys( identities );
}

identityList.defaults =
{
  ... configNameMapFrom.defaults,
};

//

function identitySet( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument.' );
  _.routine.options( identitySet, o );
  _.assert( _.str.defined( o.identityName ), 'Expects identity name {-o.identityName-}.' );
  _.assert( _.map.is( o.set ), 'Expects map {-o.set-}.' );

  const o2 = _.mapOnly_( null, o, self.configSet.defaults );
  _.each( o2.set, ( value, key ) =>
  {
    o2.set[ `identity/${ o.identityName }/${ key }` ] = value;
    delete o2.set[ key ];
  });

  return self.configSet( o2 );
}

identitySet.defaults =
{
  ... configNameMapFrom.defaults,
  set : null,
  identityName : null,
}

//

function identityNew( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly single options map {-o-}' );
  _.routine.options( identityNew, o );
  _.assert( _.map.is( o.identity ) );
  _.assert( _.str.defined( o.identity.name ), 'Expects field {-o.identity.name-}.' );
  _.assert( _.str.defined( o.identity.login ), 'Expects field {-o.identity.login-}.' );

  self._configNameMapFromDefaults( o );

  if( o.identity.type === undefined || o.identity.type === null )
  o.identity.type = 'general';
  _.assert( _.longHasAny( [ 'general', 'git', 'npm' ], o.identity.type ) );

  const o2 = _.mapOnly_( null, o, self.identityGet.defaults );
  o2.selector = o.identity.name;
  if( self.identityGet( o2 ) !== undefined )
  throw _.err( `Identity ${ name } already exists. Please, delete existed identity or create new identity with different name` );

  o.identityName = o.identity.name;
  delete o.identity.name;
  o.set = o.identity;
  delete o.identity;

  return self.identitySet( o );
}

identityNew.defaults =
{
  ... configNameMapFrom.defaults,
  identity : null,
};

//

function identityDel( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  if( _.str.is( arguments[ 0 ] ) )
  o = { profileDir : arguments[ 0 ] };
  _.routine.options( identityDel, o );

  self._configNameMapFromDefaults( o );

  if( o.selector === null )
  o.selector = '';
  _.assert( _.str.is( o.selector ) );
  o.selector = `identity/${ o.selector }`;

  return self.configDel( o );
}

identityDel.defaults =
{
  ... configNameMapFrom.defaults,
  selector : null,
};

//

function identityHookSet( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.routine.options( identityHookSet, o );

  self._configNameMapFromDefaults( o );

  const typesMap =
  {
    git : [ 'git' ],
    npm : [ 'npm' ],
    general : [ 'git', 'npm' ],
  };

  _.assert( o.type in typesMap );
  _.assert( !_.path.isGlob( o.selector ) );

  if( o.default )
  {
    _.assert( o.selector === '' );
  }
  else
  {
    const o2 = _.mapOnly_( null, o, self.identityGet.defaults );
    const identity = self.identityGet( o2 );
    _.assert( _.map.is( identity ), `Selected no identity : ${ o.selector }. Please, improve selector.` );
    _.assert
    (
      'login' in identity && 'type' in identity,
      `Selected ${ _.props.keys( identity ).length } identity(s). Please, improve selector.`
    );
    _.assert( identity.type === 'general' || identity.type === o.type );
  }

  _.each( typesMap[ o.type ], ( type ) => hookMake( o.hook, type ) );

  /* */

  function hookMake( data, type )
  {
    const baseName = `${ type.replace( /^\w/, type[ 0 ].toUpperCase() ) }Identity`;
    let name = `${ baseName }.${ o.selector }.js`;
    if( o.selector === '' )
    name = `${ baseName }.js`;
    const filePath = _.fileProvider.configUserPath( _.path.join( o.storageDir, o.profileDir, self.storageHookDir, type, name ) );
    _.fileProvider.fileWrite({ filePath, data });
    return filePath;
  }
}

identityHookSet.defaults =
{
  ... configNameMapFrom.defaults,
  hook : null,
  type : null,
  selector : null,
  default : false,
};

//

function identityHookCall( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.routine.options( identityHookCall, o );

  const typesMap =
  {
    git : [ 'git' ],
    npm : [ 'npm' ],
    general : [ 'git', 'npm' ],
  };

  _.assert( o.type in typesMap );
  _.assert( !_.path.isGlob( o.selector ) );

  self._configNameMapFromDefaults( o );

  const o2 = _.mapOnly_( null, o, self.identityGet.defaults );
  const identity = self.identityGet( o2 );
  _.assert( _.map.is( identity ), `Selected no identity : ${ o.identitySrcName }. Please, improve selector.` );
  _.assert
  (
    'login' in identity && 'type' in identity,
    `Selected ${ _.props.keys( identity ).length } identity(s). Please, improve selector.`
  );
  _.assert( identity.type === 'general' || identity.type === o.type );

  _.each( typesMap[ o.type ], ( type ) =>
  {
    const baseName = `${ type.replace( /^\w/, type[ 0 ].toUpperCase() ) }Identity`;
    const userHookPath = _.path.join( o.storageDir, o.profileDir, self.storageHookDir, type, `${ baseName }.${ o.selector }.js` );
    let filePath = _.fileProvider.configUserPath( userHookPath );

    if( !_.fileProvider.fileExists( filePath ) )
    {
      const userDefaultHookPath = _.path.join( o.storageDir, o.profileDir, self.storageHookDir, type, `${ baseName }.js` );
      filePath = _.fileProvider.configUserPath( userDefaultHookPath );
      if( !_.fileProvider.fileExists( filePath ) )
      defaultHookMake( type );
    }

    hookCall( filePath );
  });

  /* */

  function hookCall( filePath )
  {
    const routine = require( _.path.nativize( filePath ) );
    _.assert( _.routine.is( routine ) );

    let result = routine.call( _, identity );
    if( _.promiseIs( result ) )
    result = _.Consequence.From( result );
    if( _.consequenceIs( result ) )
    result = result.deasync().sync();
    return result;
  }

  /* */

  function defaultHookMake( type )
  {
    const o2 = _.mapOnly_( null, o, self.identityHookSet.defaults );
    o2.selector = '';
    o2.default = true;

    if( type === 'git' )
    o2.hook = gitHookCodeGet();
    else
    o2.hook = npmHookCodeGet();

    return self.identityHookSet( o2 );
  }

  /* */

  function gitHookCodeGet()
  {
    const code =
    `
function onIdentity( identity )
{
  const _ = this;
  const ready = _.take( null );
  const start = _.process.starter
  ({
    currentPath : __dirname,
    mode : 'shell',
    outputCollecting : 1,
    throwingExitCode : 0,
    inputMirroring : 0,
    sync : 1,
    ready,
  });

  _.assert( _.str.defined( identity.login ) );
  _.assert( _.str.defined( identity.email ) );
  const oldName = start( 'git config --global user.name' ).output.trim();
  if( oldName )
  {
    start
    ({
      execPath :
      [
        \`git config --global --unset url.https://\$\{ oldName \}@github.com.insteadof\`,
        \`git config --global --unset url.https://\$\{ oldName \}@bitbucket.org.insteadof\`,
      ],
    });
  }
  return start
  ({
    execPath :
    [
      \`git config --global user.name "\$\{ identity.login \}"\`,
      \`git config --global user.email "\$\{ identity.email \}"\`,
      \`git config --global url."https://\$\{ identity.login \}@github.com".insteadOf "https://github.com"\`,
      \`git config --global url."https://\$\{ identity.login \}@bitbucket.org".insteadOf "https://bitbucket.org"\`,
    ],
    throwingExitCode : 1,
  });
}
module.exports = onIdentity;
`;
    return code;
  }

  /* */

  function npmHookCodeGet()
  {
    const code =
    `
function onIdentity( identity )
{
  const _ = this;
  const start = _.process.starter
  ({
    currentPath : __dirname,
    mode : 'shell',
    outputCollecting : 1,
    throwingExitCode : 1,
    inputMirroring : 0,
    sync : 1,
  });

  _.assert( _.str.defined( identity.login ) );
  _.assert( _.str.defined( identity.npmPass ) );
  _.assert( _.str.defined( identity.email ) );
  start( 'npm i npm-cli-login' );

  const npmCli = _.path.nativize( './node_modules/.bin/npm-cli-login' );
  start
  ({
    execPath : \`\$\{ npmCli \} -u \$\{ identity.login \} -p \$\{ identity.npmPass \} -e \$\{ identity.email \} --quotes\`,
    outputPiping : 0,
  });
}
module.exports = onIdentity;
`;
    return code;
  }
}

identityHookCall.defaults =
{
  ... configNameMapFrom.defaults,
  selector : null,
  type : null,
};

//

function identityUse( o )
{
  const self = this;

  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.routine.options( identityUse, o );

  const typesMap =
  {
    git : [ 'git' ],
    npm : [ 'npm' ],
    general : [ 'git', 'npm' ],
  };

  _.assert( o.type in typesMap || o.type === null );
  _.assert( !_.path.isGlob( o.selector ) );

  self._configNameMapFromDefaults( o );

  const o2 = _.mapOnly_( null, o, self.identityGet.defaults );
  const identity = self.identityGet( o2 );
  _.assert( _.map.is( identity ), `Selected no identity : ${ o.identitySrcName }. Please, improve selector.` );
  _.assert
  (
    'login' in identity && 'type' in identity,
    `Selected ${ _.props.keys( identity ).length } identity(s). Please, improve selector.`
  );
  _.assert( identity.type === 'general' || identity.type === o.type || o.type === null );

  /* */

  self.identityDel({ profileDir : o.profileDir, selector : '_previous' });
  const o3 = _.mapOnly_( null, o, self.identityGet.defaults );
  o3.selector = '_current';
  const currentIdentity = self.identityGet( o3 );
  if( currentIdentity !== undefined )
  self.identitySet({ profileDir : o.profileDir, identityName : '_previous', set : currentIdentity });

  self.identityDel({ profileDir : o.profileDir, selector : '_current' });
  self.identitySet({ profileDir : o.profileDir, identityName : '_current', set : identity });

  self.identityHookCall({ profileDir : o.profileDir, selector : '_current', type : o.type || identity.type });
}

identityUse.defaults =
{
  ... configNameMapFrom.defaults,
  selector : null,
  type : null,
};

// --
// action
// --

function actionIs( src )
{
  if( !_.mapIs( src ) )
  return false;
  if( !src.status )
  return false;
  return true;
}

//

function actionStatus( o )
{
  let result;

  o = _.routine.options( actionStatus, o );

  _.assert( _.censor.actionIs( o.action ) );

  if( !o.verbosity )
  return '';

  if( o.action.status.error )
  {
    if( o.verbosity >= 2 )
    {
      result = String( o.action.status.error );
    }
    else
    {
      result = `Error in ${o.action.name}`;
    }
  }
  else
  {
    if( o.verbosity >= 2 )
    {
      if( o.action.status === 'redo' )
      result = o.action.undoDescription2;
      else
      result = o.action.redoDescription2;
    }
    else if( o.verbosity >= 1 )
    {
      if( o.action.status === 'redo' )
      result = o.action.undoDescription;
      else
      result = o.action.redoDescription;
    }
  }

  return result;
}

actionStatus.defaults =
{
  verbosity : 3,
  action : null,
}

//

function actionDo( o )
{
  let up;
  try
  {

    o = _.routine.options( actionDo, arguments );

    if( o.logger )
    {
      o.logger.up();
      up = true;
    }

    verify();

    if( o.mode.redo )
    if( o.action.status.error )
    throw _.err( o.action.status.error );

    if( o.mode === 'redo' )
    dataBeforeUpdate();

    let outdated = _.censor.hashMapOutdatedFiles
    ({
      hashMap : o.mode === 'redo' ? o.action.hashBefore : o.action.hashAfter,
      dataMap : o.dataMap,
    });

    if( outdated.length )
    {
      let err = _._err
      ({
        args : [ `Files are outdated:\n  ${ outdated.join( '  \n' ) }` ],
        reason : 'outdated'
      });
      debugger; /* eslint-disable-line no-debugger */
      throw _.errBrief( err );
    }

    if( o.action.status.outdated && o.action.status.error )
    o.action.status.error = null;
    o.action.status.outdated = false

    let act = o.action[ o.mode ];
    if( _.strIs( act ) )
    act = _.routineMake({ code : act, prependingReturn : 1 })();

    o.hashAfterUpdate = hashAfterUpdate;
    o.filesUndo = filesUndo;

    act( o );

    if( o.logger )
    {
      o.logger.down();
      up = false;
    }

    if( o.verbosity && o.log === undefined )
    {
      if( o.mode === 'redo' )
      {
        if( o.verbosity >= 2 )
        o.log = o.action.redoDescription2;
        else
        o.log = o.action.redoDescription;
      }
      else
      {
        if( o.verbosity >= 2 )
        o.log = o.action.undoDescription2;
        else
        o.log = o.action.undoDescription;
      }
    }

    if( o.verbosity && o.logger )
    if( o.mode === 'redo' )
    o.logger.log( o.action.redoDescription );
    else
    o.logger.log( o.action.undoDescription );

    if( o.mode === 'undo' )
    o.action.dataMapBefore = null;
    o.action.status.current = o.mode;
    storageUpdate();

  }
  catch( err )
  {

    err = _.err( err );

    let tab = '    ';
    err = _._err
    ({
      args : [ err ],
      message : ` ! failed to ${o.mode} ${o.action.name}\n` + tab + _.strLinesIndentation( err.message, tab ),
    });

    if( o.mode === 'redo' )
    o.action.dataMapBefore = null;
    o.action.status.error = String( err );

    if( err.reason === 'outdated' )
    o.action.status.outdated = true;

    if( up )
    {
      o.logger.down();
      up = false;
    }

    if( o.throwing )
    {
      _.errAttend( err, 0 );
      _.errLogged( err, 0 );
      throw err;
    }

    return null;
  }

  return true;

  /* */

  function verify()
  {
    if( !Config.debug )
    return;
    _.assert( _.mapIs( o.action.status ) );
    _.assert( _.longHas( [ 'redo', 'undo' ], o.mode ) );
    if( o.mode === 'redo' )
    {
      _.assert( o.action.status.current === null || o.action.status.current === 'undo', () => `${o.action.name} is already done` );
      _.assert( _.entity.lengthOf( o.action.hashBefore ) >= 1 );
    }
    else
    {
      _.assert( o.action.status.current === 'redo', () => `${o.action.name} is not yet done to undo` );
      _.assert( _.entity.lengthOf( o.action.hashAfter ) >= 1 );
    }
  }

  /* */

  function storageUpdate()
  {
    if( o.storage )
    {
      if( o.mode === 'redo' )
      {
        _.arrayRemoveOnceStrictly( o.storage.redo, o.action );
        _.arrayPrepend( o.storage.undo, o.action );
      }
      else
      {
        _.arrayRemoveOnceStrictly( o.storage.undo, o.action );
        _.arrayPrepend( o.storage.redo, o.action );
      }
    }
  }

  /* */

  function filesUndo()
  {
    _.assert( _.mapIs( o.action.dataMapBefore ) );
    for( let filePath in o.action.dataMapBefore )
    {
      _.fileProvider.fileWrite({ filePath, data : o.action.dataMapBefore[ filePath ] });
    }
  }

  /* */

  function dataBeforeUpdate()
  {

    _.assert( o.action.dataMapBefore === null );

    if( !o.dataMap )
    o.dataMap = _.fileProvider.filesRead({ filePath : _.props.keys( o.action.hashBefore ), encoding : 'utf8' }).dataMap;

    // _.assert( _.entity.lengthOf( o.dataMap ) >= 1 );

    o.action.dataMapBefore = o.dataMap;

  }

  /* */

  function hashAfterUpdate()
  {
    let dataMap = _.fileProvider.filesRead({ filePath : _.props.keys( o.action.hashBefore ), encoding : 'buffer.raw' }).dataMap;

    o.action.hashAfter = o.action.hashAfter || Object.create( null );

    for( let filePath in dataMap )
    {
      o.action.hashAfter[ filePath ] = _.files.hashSzFrom( dataMap[ filePath ] );
    }

    return dataMap;
  }

  /* */

}

actionDo.defaults =
{
  mode : 'redo',
  action : null,
  dry : 0,
  storage : null,
  logger : null,
  verbosity : 2,
  throwing : 1,
}

// --
// operations
// --

function replace_head( routine, args )
{
  let o = args[ 0 ];

  if( args.length > 1 )
  {
    if( args.length === 3 )
    o = { filePath : args[ 0 ], ins : args[ 1 ], sub : args[ 2 ] }
    else
    o = { filePath : args[ 0 ] }
  }

  _.routine.options( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 3 );
  _.assert( _.strDefined( o.filePath ) );
  _.assert( _.strDefined( o.ins ) || _.regexpIs( o.ins ) );
  _.assert( _.strIs( o.sub ) );

  o.logger = _.logger.maybe( o.logger );

  return o;
}

//

function fileReplace_body( o )
{
  let opened;

  _.routine.assertOptions( fileReplace_body, arguments );
  _.assert( _.strDefined( o.filePath ) );
  _.assert( !!o.arranging, 'not implemented' );

  try
  {

    let size = _.fileProvider.statRead( o.filePath ).size;
    let hash = _.fileProvider.hashSzRead({ filePath : o.filePath, hashFileSizeLimit : o.fileSizeLimit });
    o.src = _.fileProvider.fileRead( o.filePath );

    {
      let o2 = _.mapOnly_( null, o, _.strSearchLog.defaults );
      let searched = _.strSearchLog( o2 );
      _.props.extend( o, searched );
      o.searchLog = o.log;
      delete o.log;
      delete o.src;
      o.parcels.forEach( ( parcel ) =>
      {
        _.assert( _.strIs( parcel.input ) );
        delete parcel.input;
      });
    }

    if( !o.parcels.length )
    return o;

    opened = _.censor.arrangementOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminalPrefix : o.storageTerminalPrefix,
      storageTerminal : o.storageTerminal,
      storageTerminalPostfix : o.storageTerminalPostfix,
    });

    if( o.resetting )
    opened.storage.redo = [];

    let tab = '     ';
    let action = this.Action.make();
    action.status = this.ActionStatus.make();
    action.filePath = o.filePath;
    action.hashBefore = { [ action.filePath ] : hash };

    action.name = `action::replace ${o.parcels.length} in ${o.filePath}`;

    if( o.gray )
    action.redoDescription = ` + replace ${o.parcels.length} in ${o.filePath}`;
    else
    action.redoDescription = ` + replace ${o.parcels.length} in ${_.ct.format( o.filePath, 'path' )}`;
    action.redoDescription2 = action.redoDescription + `\n`;
    action.redoDescription2 += tab + _.strLinesIndentation( o.searchLog, tab );

    if( o.gray )
    action.undoDescription = ` + undo replace ${o.parcels.length} in ${o.filePath}`;
    else
    action.undoDescription = ` + undo replace ${o.parcels.length} in ${_.ct.format( o.filePath, 'path' )}`;
    action.undoDescription2 = action.undoDescription + `\n`;
    action.undoDescription2 += tab + _.strLinesIndentation( o.searchLog, tab );

    action.redo = _.routineSourceGet( redo );
    action.undo = _.routineSourceGet( undo );
    action.parameters = _.props.extend( null, o );

    delete action.parameters.arranging;
    delete action.parameters.determiningLineNumber;
    delete action.parameters.dry;
    delete action.parameters.logger;
    delete action.parameters.onTokenize;
    delete action.parameters.resetting;

    if( o.verbosity >= 2 )
    o.log = action.redoDescription2;
    else if( o.verbosity )
    o.log = action.redoDescription;

    opened.storage.redo.push( action );

    _.censor.arrangementClose( opened );

    if( o.logger )
    o.logger.log( o.log );

  }
  catch( err )
  {
    err = _.err( err );

    if( opened )
    _.censor.arrangementClose( opened );

    throw err;
  }

  return o;

  /* */

  function redo( op )
  {
    const _ = _global_.wTools;

    let o2 =
    {
      src : _.strFrom( op.dataMap[ op.action.filePath ] ),
      parcels : op.action.parameters.parcels,
      logger : op.logger,
      verbosity : op.verbosity,
    }
    op.dst = _.strSearchReplace( o2 );
    op.log = o2.log;

    _.fileProvider.fileWrite( op.action.filePath, op.dst );

    op.hashAfterUpdate();

  }

  function undo( op )
  {
    const _ = _global_.wTools;
    op.filesUndo();
  }

}

fileReplace_body.defaults =
{
  ... arrangementNameMapFrom.defaults,

  filePath : null,
  ins : null,
  sub : null,
  nearestLines : 3,
  arranging : 1, /* qqq : implement and cover for routine filesReplace */
  resetting : 0, /* qqq : cover for routine filesReplace */
  gray : 0,
  verbosity : 0, /* qqq : repalce with logger */
  logger : 0,
  fileSizeLimit : null,
  session : null,
  usingTextLink : 0,

}

let fileReplace = _.routine.unite( replace_head, fileReplace_body );

//

function filesReplace_body( o )
{
  o =_.routine.options( filesReplace, arguments );

  if( o.session )
  o.storageTerminal = o.session;

  if( o.resetting )
  {
    let opened = _.censor.arrangementOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminalPrefix : o.storageTerminalPrefix,
      storageTerminal : o.storageTerminal,
      storageTerminalPostfix : o.storageTerminalPostfix,
    });
    opened.storage.redo = [];
    _.censor.arrangementClose( opened );
  }

  o.nparcels = 0;
  o.nfiles = 0;
  o.files = [];

  if( o.verbosity )
  o.log = '';

  if( o.v !== undefined )
  {
    o.verbosity = o.v;
    delete o.v;
  }

  if( o.basePath === null )
  o.basePath = _.path.current();

  if( o.usingTextLink )
  {
    _.fileProvider.fieldPush( 'resolvingTextLink', 1 );
    _.fileProvider.fieldPush( 'usingTextLink', 1 );
  }

  let filter = { filePath : o.filePath, basePath : o.basePath };
  let files = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
    withDirs : 0,
    withDefunct : 0,
    revisitingHardLinked : 0,
    resolvingSoftLink : 1,
    revisiting : 0,
    allowingCycled : 1,
    allowingMissed : 1,
  });

  for( let f = 0 ; f < files.length ; f++ )
  {
    let o2 = _.mapOnly_( null, o, _.censor.fileReplace.defaults );
    o2.verbosity = o2.verbosity - 1 >= 0 ? o2.verbosity - 1 : 0;
    o2.filePath = files[ f ].absolute;
    o2.resetting = 0;
    _.censor.fileReplace( o2 );
    _.assert( _.intIs( o2.parcels.length ) );
    o.files.push( o2 );
    o.nparcels += o2.parcels.length;
    if( o2.parcels.length )
    o.nfiles += 1;
    if( o.verbosity >= 2 && o2.log )
    o.log += o2.log;
  }

  if( o.verbosity )
  {
    let log = ` . Found ${files.length} file(s). Arranged ${o.nparcels} replacement(s) in ${o.nfiles} file(s).`;
    o.log += log;
    if( o.logger )
    o.logger.log( log );
  }

  return o;
}

filesReplace_body.defaults =
{
  ... fileReplace.defaults,
  verbosity : 3, /* qqq : repalce with logger */
  basePath : null,
  filePath : null,
}

let filesReplace = _.routine.unite( replace_head, filesReplace_body );

_.assert( filesReplace_body.defaults.resetting === 0 );
_.assert( filesReplace.defaults.resetting === 0 );

//

function _link_head( routine, args )
{
  let o = args[ 0 ];

  if( args.length > 1 )
  {
    o = { dstPath : args[ 0 ], srcPath : args[ 1 ] }
  }

  _.routine.options( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.assert( _.strDefined( o.srcPath ) );
  _.assert( _.strDefined( o.dstPath ) );

  o.logger = _.logger.maybe( o.logger );

  return o;
}

//

function _link_body( o )
{
  let arrangement;

  _.routine.assertOptions( _link_body, arguments );
  _.assert( _.strDefined( o.srcPath ) );
  _.assert( _.strDefined( o.dstPath ) );
  _.assert( !!o.arranging, 'not implemented' );
  _.assert( o.linkingAction === 'fileRename' );

  try
  {

    let srcStat = _.fileProvider.statRead( o.srcPath );
    let dstStat = _.fileProvider.statRead( o.dstPath );

    arrangement = _.censor.arrangementOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminalPrefix : o.storageTerminalPrefix,
      storageTerminal : o.storageTerminal,
      storageTerminalPostfix : o.storageTerminalPostfix,
    });

    if( o.resetting )
    arrangement.storage.redo = [];

    let tab = '     ';
    let action = this.Action.make();
    action.status = this.ActionStatus.make();
    action.filePath = [ o.dstPath, o.srcPath ];
    action.hashBefore = {};
    action.hashAfter = {};

    let mtr = _.path.moveTextualReport( o.dstPath, o.srcPath );
    action.name = `action::${o.linkingAction}`;

    action.redoDescription = ` + ${mtr}`;
    action.redoDescription2 = action.redoDescription;

    action.undoDescription = ` + undo ${o.linkingAction} ${mtr}`;
    action.undoDescription2 = action.undoDescription;

    action.redo = _.routineSourceGet( renameRedo );
    action.undo = _.routineSourceGet( renameUndo );

    action.parameters = _.props.extend( null, o );
    delete action.parameters.arranging;
    delete action.parameters.resetting;
    delete action.parameters.logger;

    if( o.verbosity >= 2 )
    o.log = action.redoDescription2;
    else if( o.verbosity )
    o.log = action.redoDescription;

    arrangement.storage.redo.push( action );

    _.censor.arrangementClose( arrangement );

    if( o.logger )
    o.logger.log( o.log );

  }
  catch( err )
  {
    err = _.err( err );
    if( arrangement )
    _.censor.arrangementClose( arrangement );
    throw err;
  }

  return o;

  /* */

  function renameRedo( op )
  {
    const _ = _global_.wTools;
    let dstPath = op.action.filePath[ 0 ];
    let srcPath = op.action.filePath[ 1 ];

    if( srcPath === dstPath )
    return;

    if( !_.fileProvider.fileExists( srcPath ) )
    throw _.err( `File ${srcPath} does not exist!` );

    if( srcPath === dstPath )
    return;

    if( _.fileProvider.fileExists( dstPath ) )
    throw _.err( `File ${dstPath} already exists!` );

    _.fileProvider[ op.action.parameters.linkingAction ]( dstPath, srcPath );
  }

  /* */

  function renameUndo( op )
  {
    const _ = _global_.wTools;
    let dstPath = op.action.filePath[ 1 ];
    let srcPath = op.action.filePath[ 0 ];

    if( !_.fileProvider.fileExists( srcPath ) )
    throw _.err( `File ${srcPath} does not exist!` );

    if( srcPath === dstPath )
    return;

    if( _.fileProvider.fileExists( dstPath ) )
    throw _.err( `File ${dstPath} already exists!` );

    _.fileProvider[ op.action.parameters.linkingAction ]( dstPath, srcPath );
  }

  /* */

}

_link_body.defaults =
{
  ... arrangementNameMapFrom.defaults,

  dstPath : null,
  srcPath : null,

  arranging : 1, /* qqq : implement and cover */
  resetting : 0, /* qqq : cover for routine filesReplace */

  logger : 0,
  session : null,
  linkingAction : 'fileRename',

}

let fileRename = _.routine.uniteCloning( _link_head, _link_body );
fileRename.defaults.linkingAction = 'fileRename';
_.assert( fileRename.defaults === fileRename.body.defaults );
_.assert( fileRename.defaults !== _link_body.defaults );

//

function listingReorder_body( o )
{

  let regexp = /^(\d+)_(.+)$/;
  let names = _.fileProvider.dirRead( o.dirPath );
  let listing = [];

  names.forEach( ( name ) =>
  {
    let parsed = regexp.exec( name );
    if( !parsed )
    return;
    let cardinal = _.number.from( parsed[ 1 ] );
    if( _.number.defined( cardinal ) )
    listing.push({ name, cardinal, right : parsed[ 2 ] });
  });

  listing.sort( ( a, b ) => a.cardinal - b.cardinal );

  let cardinal = o.first;
  listing.forEach( ( e ) =>
  {
    let srcPath = _.path.join( o.dirPath, e.name );
    let dstPath = _.path.join( o.dirPath, nameFor( cardinal, e ) );
    if( srcPath === dstPath )
    {
      cardinal += o.step;
      return;
    }
    let o2 = _.mapOnly_( null, o, this.fileRename.defaults );
    o2.srcPath = srcPath;
    o2.dstPath = dstPath;
    _.censor.fileRename( o2 );
    cardinal += o.step;
  });

  function nameFor( cardina, e )
  {
    return cardinal + '_' + e.right;
  }

}

listingReorder_body.defaults =
{
  ... arrangementNameMapFrom.defaults,
  verbosity : null,
  dirPath : null,
  first : 10,
  step : 10,
}

let listingReorder = _.routine.unite( null, listingReorder_body );

//

let listingSqueeze = _.routine.uniteCloning( null, listingReorder_body );
listingSqueeze.defaults.first = 1;
listingSqueeze.defaults.step = 1;

_.assert( listingSqueeze.defaults !== listingReorder.defaults )

// --
// instant operation
// --

function filesHardLink( o )
{

  o = _.routine.options( filesHardLink, arguments );

  o.logger = _.logger.maybe( o.logger );

  let path = _.fileProvider.path;
  let archive = new _.FilesArchive({ fileProvider : _.fileProvider })

  /* basePath */

  o.basePath = _.array.as( o.basePath );

  if( o.withShared )
  {
    let storageName = this._configNameMapFromDefaults( o );
    let config = _.fileProvider.configUserRead( storageName ); /* xxx : replace? */
    if( config && config.path && config.path.hlink )
    _.arrayAppendArrayOnce( o.basePath, _.array.as( config.path.hlink ) );
  }

  _.assert( o.basePath.length >= 1 );

  /* mask */

  let excludeAny =
  [
    /(\W|^)node_modules(\W|$)/,
    /\.unique$/,
    /\.git$/,
    /\.svn$/,
    /\.hg$/,
    /\.tmp($|\/)/,
    /\.DS_Store$/,
  ]

  if( o.excludingHyphened )
  excludeAny.push( /(^|\/)-/ );

  let maskAll = _.RegexpObject( excludeAny, 'excludeAny' );
  let counter = 0;

  if( !o.dry )
  {

    /* run */

    if( o.verbosity < 2 )
    archive.logger.verbosity = 0;
    else if( o.verbosity === 2 )
    archive.logger.verbosity = 2;
    else
    archive.logger.verbosity = o.verbosity - 1;
    archive.allowingMissed = 0;
    archive.allowingCycled = 0;
    archive.basePath = o.basePath;
    archive.includingPath = o.includingPath;
    archive.excludingPath = o.excludingPath;
    archive.mask = maskAll;
    archive.fileMapAutosaving = 1;
    archive.filesUpdate();
    counter = archive.filesLinkSame();

  }

  /* log */

  if( o.verbosity )
  {
    let log = `Linked ${ counter } file(s) at ${_.ct.format( path.commonTextualReport( o.basePath ), 'path' )}`;
    if( o.log )
    o.log += '\n' + log;
    else
    o.log += log;
    if( o.logger )
    o.logger.log( log );
  }

}

filesHardLink.defaults =
{
  ... arrangementNameMapFrom.defaults,
  arranging : 0,
  verbosity : 3,
  log : null,
  logger : 1,
  withShared : 1,
  basePath : null,
  includingPath : null,
  excludingPath : null,
  excludingHyphened : 1
}

//

function systemEntryAdd( o )
{

  if( !_.mapIs( o ) )
  o = { appPath : arguments[ 0 ] }

  _.routine.options( systemEntryAdd, o );

  if( o.entryDirPath === null )
  {
    this._configNameMapFromDefaults( o );
    let o2 = _.mapOnly_( null, o, this.configOpen.defaults );
    o2.locking = 0;
    let opened = this.configOpen( o2 );
    if( opened.storage && opened.storage.path && opened.storage.path.entry )
    o.entryDirPath = opened.storage.path.entry;
  }


  let o3 = _.mapOnly_( null, o, _.process.systemEntryAdd.defaults );
  let result = _.process.systemEntryAdd( o3 );
  _.props.extend( o, o3 );

  return result;
}

systemEntryAdd.defaults =
{
  ... arrangementNameMapFrom.defaults,
  ... _.process.systemEntryAdd.defaults,
}

// --
// do
// --

function status( o )
{

  if( o.session )
  o.storageTerminal = o.session;

  let opened = _.censor.arrangementOpen
  ({
    storageDir : o.storageDir,
    profileDir : o.profileDir,
    storageTerminalPrefix : o.storageTerminalPrefix,
    storageTerminal : o.storageTerminal,
    storageTerminalPostfix : o.storageTerminalPostfix,
  });

  let result = Object.create( null );
  let errors;

  o = _.routine.options( status, o );

  if( o.withErrors )
  {
    errors = [];
    opened.storage.undo.forEach( ( action ) =>
    {
      if( action.status.errror )
      errors.push( action );
    });
  }

  if( o.verbosity >= 2 )
  {

    result.redo = _.filter_( null, opened.storage.redo, ( action ) =>
    {
      let o2 = _.mapOnly_( null, o, _.censor.actionStatus.defaults );
      o2.action = action;
      o2.verbosity = o2.verbosity - 1;
      return _.censor.actionStatus( o2 );
    });

    result.undo = _.filter_( null, opened.storage.undo, ( action ) =>
    {
      let o2 = _.mapOnly_( null, o, _.censor.actionStatus.defaults );
      o2.action = action;
      o2.verbosity = o2.verbosity - 1;
      return _.censor.actionStatus( o2 );
    });

  }
  else if( o.verbosity === 1 )
  {
    result.redo = opened.storage.redo.length + errorsOf( opened.storage.redo );
    result.undo = opened.storage.undo.length + errorsOf( opened.storage.undo );
  }

  _.censor.arrangementClose( opened );

  return result;

  function errorsOf( actions )
  {
    let n = 0;
    for( let i = 0 ; i < actions.length ; i++ )
    {
      let action = actions[ i ];
      if( action.status.error )
      n += 1;
    }
    if( !n )
    return ``;
    return ` -- ${n} error(s)`;
  }

}

status.defaults =
{
  storageDir : null,
  profileDir : null,
  storageTerminalPrefix : null,
  storageTerminal : null,
  storageTerminalPostfix : null,

  session : null,

  verbosity : 3,
  withUndo : 1,
  withRedo : 1,
  withErrors : 1,
}

//

function do_head( routine, args )
{
  let o = _.routine.options( routine, args );
  _.assert( _.longHas( [ 'redo', 'undo' ], o.mode ) );

  // if( _.boolLikeTrue( o.logger ) )
  // o.logger = _.LoggerPrime();

  o.logger = _.logger.maybe( o.logger );

  return o;
}

//

function do_body( o )
{
  let self = this;
  let up, error, opened;
  try
  {

    if( o.logger )
    {
      o.logger.up();
      up = true;
    }

    self._arrangementNameMapFromDefaults( o );

    let opened = _.censor.arrangementOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminalPrefix : o.storageTerminalPrefix,
      storageTerminal : o.storageTerminal,
      storageTerminalPostfix : o.storageTerminalPostfix,
    });

    if( !opened.storage || !opened.storage[ o.mode ].length )
    {
      let log = `Nothing to ${o.mode}.`;
      if( o.verbosity )
      o.log = log;
      if( o.logger )
      o.logger.log( o.log );
      return o;
    }

    if( o.depth === 0 )
    o.depth = Infinity;
    o.depth = Math.min( o.depth, opened.storage[ o.mode ].length );

    let ndone = 0;
    let nerrors = 0;
    let doArray = opened.storage[ o.mode ].slice();
    for( let i = 0 ; i < o.depth; i++ )
    try
    {

      let o2 = _.mapOnly_( null, o, _.censor.actionDo.defaults );
      o2.action = doArray[ i ];
      o2.verbosity = o2.verbosity - 1 >= 0 ? o2.verbosity - 1 : 0;
      o2.storage = opened.storage;
      _.censor.actionDo( o2 );
      if( o.verbosity > 1 )
      if( o.log )
      o.log += '\n' + o2.log;
      else
      o.log = o2.log;
      if( o2.action.status.current )
      ndone += 1;
      if( o2.action.status.error )
      nerrors += 1;

    }
    catch( err )
    {
      nerrors += 1;
      err = _.err( err );
      logger.error( err );
      if( !error )
      error = err;
    }

    if( up )
    {
      o.logger.down();
      up = false;
    }

    if( o.verbosity )
    {
      let log = ``;
      if( o.mode === 'undo' )
      log += ` - Undone ${ndone} action(s). Thrown ${nerrors} error(s).`;
      else
      log += ` + Done ${ndone} action(s). Thrown ${nerrors} error(s).`;
      if( o.logger )
      o.logger.log( log );
      if( o.log )
      o.log += '\n' + log;
      else
      o.log = log;
    }

    _.censor.arrangementClose( opened );

    if( error )
    throw error;

  }
  catch( err )
  {
    if( up )
    {
      o.logger.down();
      up = false;
    }
    if( opened )
    {
      opened.throwing = 0;
      _.censor.arrangementClose( opened )
    }
    throw _.err( err );
  }
}

do_body.defaults =
{

  ... _.mapBut_( null, actionDo.defaults, [ 'action' ] ),

  depth : 0,
  verbosity : 3,
  logger : 1,

  storageDir : null,
  profileDir : null,
  storageTerminalPrefix : null,
  storageTerminal : null,
  storageTerminalPostfix : null,
  usingTextLink : 0

}

//

let _do = _.routine.uniteCloning( do_head, do_body );
_do.defaults.depth = 0;
_do.defaults.mode = 'redo';

let redo = _.routine.uniteCloning( do_head, do_body );
redo.defaults.depth = 0;
redo.defaults.mode = 'redo';

let undo = _.routine.uniteCloning( do_head, do_body );
undo.defaults.depth = 0;
undo.defaults.mode = 'undo';

// --
// etc
// --

function hashMapOutdatedFiles( o )
{
  let result = [];

  _.assert( _.mapIs( o.hashMap ) );

  o.dataMap = o.dataMap || Object.create( null );

  for( let filePath in o.hashMap )
  {
    let hash = o.hashMap[ filePath ];

    if( !o.dataMap[ filePath ] === undefined )
    o.dataMap[ filePath ] = _.fileProvider.fileRead( filePath, 'buffer.raw' );

    if( !_.fileProvider.hashSzIsUpToDate({ filePath, data : o.dataMap[ filePath ], hash }) )
    {
      result.push( filePath );
    }
  }

  return result;
}

hashMapOutdatedFiles.defaults =
{
  hashMap : null,
  dataMap : null,
}

// --
// meta
// --

function Init()
{

  this.storagePath = _.path.normalize( this.storageDir );
  this.storageProfilePath = _.path.join( this.storageDir, this.storageProfileDir );
  this.storageConfigPath = _.path.join( this.storageDir, this.storageProfileDir, this.storageConfigTerminal );
  this.storageArrangementPath = _.path.join
  (
    this.storageDir,
    this.storageProfileDir,
    this.storageArrangementPrefix + this.storageArrangementTerminal + this.storageArrangementPostfix,
  );

}

// --
// relation
// --

let Action = _.Blueprint
({
  name : null,
  redoDescription : null,
  redoDescription2 : null,
  undoDescription : null,
  undoDescription2 : null,
  filePath : null,
  hashBefore : null,
  hashAfter : null,
  dataMapBefore : null,
  status : null, /* xxx : use ActionStatus immediately */
  parameters : null,
  redo : null,
  undo : null,
});

let ActionStatus = _.Blueprint
({
  current : null,
  error : null,
  outdated : null,
});

let Arrangement = _.Blueprint
({
  redo : _.define.shallow([]),
  undo : _.define.shallow([]),
});

let Config = _.Blueprint
({
  about : _.define.shallow({}),
  path : _.define.shallow({}),
  extendable : _.trait.extendable(),
});

// --
// declare
// --

let Extension =
{

  // storage

  _storageNameMapFromDefaults,
  storageNameMapFrom,
  storageRead,
  storageDel,
  storageLog,

  _profileNameMapFromDefaults,
  profileNameMapFrom,
  profileRead,
  profileDel,
  profileLog,

  _configNameMapFromDefaults,
  configNameMapFrom,
  configRead,
  configOpen,
  configClose,
  configLog,
  configGet,
  configSet,
  configDel,

  _arrangementNameMapFromDefaults,
  arrangementNameMapFrom,
  arrangementRead,
  arrangementOpen,
  arrangementClose,
  arrangementDel,
  arrangementLog,

  identityCopy,
  identityGet,
  identityList,
  identitySet,
  identityNew,
  identityDel,
  identityHookSet,
  identityHookCall,
  identityUse,

  // action

  actionIs,
  actionStatus,
  actionDo,

  // operation

  fileReplace,
  filesReplace,
  fileRename,
  listingReorder,
  listingSqueeze,

  // instant operation

  filesHardLink,
  systemEntryAdd,

  // do

  status,
  do : _do,
  redo,
  undo,

  // etc

  hashMapOutdatedFiles,

  //

  Init,

  // fields

  Action,
  ActionStatus,
  Arrangement,
  Config,

  storageDir : '.censor',
  storagePath : null,
  storageProfileDir : 'default',
  storageProfilePath : null,
  storageConfigTerminal : 'config.yaml',
  storageConfigPath : null,
  storageArrangementPrefix : 'arrangement.',
  storageArrangementTerminal : 'default',
  storageArrangementPostfix : '.json',
  storageArrangementPath : null,
  storageHookDir : 'hook',

}

Object.assign( _.censor, Extension );
_.censor.Init();

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
