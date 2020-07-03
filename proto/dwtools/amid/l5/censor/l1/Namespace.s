( function _Namespace_s_( )
{

'use strict';

let _ = _global_.wTools;
let Self = _.censor = _.censor || Object.create( null );

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

  o = _.routineOptions( actionStatus, o );

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

    o = _.routineOptions( actionDo, arguments );

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
      _.errLogEnd( err, 0 );
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
      _.assert( _.lengthOf( o.action.hashBefore ) >= 1 );
    }
    else
    {
      _.assert( o.action.status.current === 'redo', () => `${o.action.name} is not yet done to undo` );
      _.assert( _.lengthOf( o.action.hashAfter ) >= 1 );
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
    o.dataMap = _.fileProvider.filesRead({ filePath : _.mapKeys( o.action.hashBefore ), encoding : 'utf8' }).dataMap;

    _.assert( _.lengthOf( o.dataMap ) >= 1 );

    o.action.dataMapBefore = o.dataMap;

  }

  /* */

  function hashAfterUpdate()
  {
    let dataMap = _.fileProvider.filesRead({ filePath : _.mapKeys( o.action.hashBefore ), encoding : 'buffer.raw' }).dataMap;

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

function replace_pre( routine, args )
{
  let o = args[ 0 ];

  if( args.length > 1 )
  o = { filePath : args[ 0 ], ins : args[ 1 ], sub : args[ 2 ] }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 3 );
  _.assert( _.strDefined( o.filePath ) );
  _.assert( _.strDefined( o.ins ) );
  _.assert( _.strDefined( o.sub ) );

  if( _.boolLikeTrue( o.logger ) )
  o.logger = _.LoggerPrime();

  return o;
}

//

function fileReplace_body( o )
{
  let opened;

  _.assertRoutineOptions( fileReplace_body, arguments );
  _.assert( _.strDefined( o.filePath ) );
  _.assert( !!o.arranging, 'not implemented' );

  try
  {

    let size = _.fileProvider.statRead( o.filePath ).size;
    let hash = _.fileProvider.hashSzRead( o.filePath );
    o.src = _.fileProvider.fileRead( o.filePath );

    {
      let o2 = _.mapOnly( o, _.strSearchLog.defaults );
      let searched = _.strSearchLog( o2 );
      _.mapExtend( o, searched );
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

    opened = _.censor.storageOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminal : o.storageTerminal,
    });

    if( o.redoReseting )
    opened.storage.redo = [];

    let tab = '     ';
    let action = this.Action.construct();
    action.status = this.ActionStatus.construct();
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
    action.parameters = _.mapExtend( null, o );

    delete action.parameters.arranging;
    delete action.parameters.determiningLineNumber;
    delete action.parameters.dry;
    delete action.parameters.logger;
    delete action.parameters.onTokenize;
    delete action.parameters.redoReseting;

    if( o.verbosity >= 2 )
    o.log = action.redoDescription2;
    else if( o.verbosity )
    o.log = action.redoDescription;

    opened.storage.redo.push( action );

    _.censor.storageClose( opened );

    if( o.logger )
    o.logger.log( o.log );

  }
  catch( err )
  {
    err = _.err( err );

    if( opened )
    _.censor.storageClose( opened );

    throw err;
  }

  return o;

  /* */

  function redo( op )
  {
    let _ = _global_.wTools;

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
    let _ = _global_.wTools;
    op.filesUndo();
  }

}

fileReplace_body.defaults =
{
  filePath : null,
  ins : null,
  sub : null,
  nearestLines : 3,
  arranging : 1, /* qqq : implement and cover for routine filesReplace */
  redoReseting : 1, /* qqq : cover for routine filesReplace */
  gray : 0,
  verbosity : 0,
  logger : 0,
  storageDir : null,
  profileDir : null,
  storageTerminal : null,
}

let fileReplace = _.routineFromPreAndBody( replace_pre, fileReplace_body );

//

function filesReplace_body( o )
{

  o  =_.routineOptions( filesReplace, arguments );

  if( o.redoReseting )
  {
    let opened = _.censor.storageOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminal : o.storageTerminal,
    });
    opened.storage.redo = [];
    _.censor.storageClose( opened );
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
  });

  for( let f = 0 ; f < files.length ; f++ )
  {
    let o2 = _.mapOnly( o, _.censor.fileReplace.defaults );
    o2.verbosity = o2.verbosity - 1 >= 0 ? o2.verbosity - 1 : 0;
    o2.filePath = files[ f ].absolute;
    o2.redoReseting = 0;
    _.censor.fileReplace( o2 );
    _.assert( _.intIs( o2.parcels.length ) );
    o.files.push( o2 );
    o.nparcels += o2.parcels.length;
    if( o2.parcels.length )
    o.nfiles += 1;
    if( o.verbosity >= 2 && o2.log )
    o.log += o2.log;
  }

  if( o.verbosity >= 1 )
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
  verbosity : 3,
  basePath : null,
  filePath : null,
}

let filesReplace = _.routineFromPreAndBody( replace_pre, filesReplace_body );

//

function filesHardLink( o )
{

  o = _.routineOptions( filesHardLink, arguments );

  if( _.boolLikeTrue( o.logger ) )
  o.logger = _.LoggerPrime();

  let path = _.fileProvider.path;
  let archive = new _.FilesArchive({ fileProvider : _.fileProvider })

  /* basePath */

  o.basePath = _.arrayAs( o.basePath );

  if( o.withHlink )
  {
    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.configStorageTerminal;
    let storageName = _.path.join( o.storageDir, o.profileDir, o.storageTerminal );
    let config = _.fileProvider.configUserRead( storageName );
    if( config && config.path && config.path.hlink )
    _.arrayAppendArrayOnce( o.basePath, _.arrayAs( config.path.hlink ) );
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
    /(^|\/)-/,
  ]

  let maskAll = _.RegexpObject( excludeAny, 'excludeAny' );
  let counter = 0;

  if( !o.dry )
  {

    /* run */

    if( o.verbosity < 2 )
    archive.verbosity = 0;
    else if( o.verbosity === 2 )
    archive.verbosity = 2;
    else
    archive.verbosity = o.verbosity - 1;
    archive.allowingMissed = 0;
    archive.allowingCycled = 0;
    archive.basePath = o.basePath;
    archive.includingPath = o.includingPath;
    archive.excludingPath = o.excludingPath;
    archive.mask = maskAll;
    archive.fileMapAutosaving = 1;
    archive.filesUpdate();
    debugger;
    counter = archive.filesLinkSame();
    debugger;

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

  // if( o.beeping )
  // _.diagnosticBeep();

}

filesHardLink.defaults =
{
  storageTerminal : null,
  profileDir : null,
  storageDir : null,
  arranging : 0,
  verbosity : 3,
  log : null,
  logger : 1,
  withHlink : 1,
  basePath : null,
  includingPath : null,
  excludingPath : null
}

// --
// do
// --

function status( o )
{

  let opened = _.censor.storageOpen
  ({
    storageDir : o.storageDir,
    profileDir : o.profileDir,
    storageTerminal : o.storageTerminal,
  });

  let result = Object.create( null );
  let errors;

  o = _.routineOptions( status, o );

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
      let o2 = _.mapOnly( o, _.censor.actionStatus.defaults );
      o2.action = action;
      o2.verbosity = o2.verbosity - 1;
      return _.censor.actionStatus( o2 );
    });

    result.undo = _.filter_( null, opened.storage.undo, ( action ) =>
    {
      let o2 = _.mapOnly( o, _.censor.actionStatus.defaults );
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

  _.censor.storageClose( opened );

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
  storageTerminal : null,
  profileDir : null,
  storageDir : null,
  verbosity : 3,
  withUndo : 1,
  withRedo : 1,
  withErrors : 1,
}

//

function do_pre( routine, args )
{
  let o = _.routineOptions( routine, args );
  _.assert( _.longHas( [ 'redo', 'undo' ], o.mode ) );

  if( _.boolLikeTrue( o.logger ) )
  o.logger = _.LoggerPrime();

  return o;
}

//

function do_body( o )
{
  let up;
  let error;
  let opened;
  try
  {

    if( o.logger )
    {
      o.logger.up();
      up = true;
    }

    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.arrangedStorageTerminal;
    let storageName = _.path.join( o.storageDir, o.profileDir, o.storageTerminal );

    let opened = _.censor.storageOpen
    ({
      storageDir : o.storageDir,
      profileDir : o.profileDir,
      storageTerminal : o.storageTerminal,
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

      let o2 = _.mapOnly( o, _.censor.actionDo.defaults );
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

    _.censor.storageClose( opened );

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
      debugger;
      opened.throwing = 0;
      _.censor.storageClose( opened )
    }
    debugger;
    throw _.err( err );
  }
}

do_body.defaults =
{
  ... _.mapBut( actionDo.defaults, [ 'action' ] ),
  // storageName : null,
  storageDir : null,
  profileDir : null,
  storageTerminal : null,
  depth : 0,
  verbosity : 3,
  logger : 1,
}

//

let _do = _.routineFromPreAndBody( do_pre, do_body );
_do.defaults.depth = 0;
_do.defaults.mode = 'redo';

let redo = _.routineFromPreAndBody( do_pre, do_body );
redo.defaults.depth = 0;
redo.defaults.mode = 'redo';

let undo = _.routineFromPreAndBody( do_pre, do_body );
undo.defaults.depth = 0;
undo.defaults.mode = 'undo';

// --
// storage
// --

function storageRead( o )
{
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageDir : arguments[ 0 ] };
    o = _.routineOptions( storageRead, o );

    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.arrangedStorageTerminal;
    let storageName = _.path.join( o.storageDir, o.profileDir, o.storageTerminal );

    let storagePath = _.fileProvider.configUserPath( storageName );

    if( !_.fileProvider.fileExists( storagePath ) )
    return '';

    return _.fileProvider.fileRead( storagePath );
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to read storage::${storageName}` );
  }
}

storageRead.defaults =
{
  storageDir : null,
  profileDir : null,
  storageTerminal : null,
}

//

function storageOpen( o )
{
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageName : arguments[ 0 ] };
    o = _.routineOptions( storageOpen, o );

    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.arrangedStorageTerminal;
    let storageName = _.path.join( o.storageDir, o.profileDir, o.storageTerminal );

    o.storage = _.fileProvider.configUserRead
    ({
      name : storageName,
      locking : o.locking,
    });

    if( !o.storage )
    {
      o.storage = _.censor.Storage.construct();
      _.fileProvider.configUserWrite( storageName, o.storage );
      _.fileProvider.configUserLock( storageName );
    }

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to open storage::${storageName}` );
  }
}

storageOpen.defaults =
{
  // storageDir : null,
  // storageName : null,
  storageDir : null,
  profileDir : null,
  storageTerminal : null,
  locking : 1,
  throwing : 1,
}

//

function storageClose( o )
{

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routineOptions( storageClose, o );

  try
  {

    _.assert( _.mapIs( o.storage ) );

    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.arrangedStorageTerminal;

    let storageName = _.path.join( o.storageDir, o.profileDir, o.storageTerminal );

    o.storage = _.fileProvider.configUserWrite
    ({
      name : storageName,
      structure : o.storage,
      unlocking : o.locking,
    });

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to close storage::${storageName}` );
  }
}

storageClose.defaults =
{
  ... storageOpen.defaults,
  storage : null,
}

//

function storageReset( o )
{

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageDir : arguments[ 0 ] };
  o = _.routineOptions( storageReset, o );

  try
  {

    if( o.storageDir === null )
    o.storageDir = _.censor.storageDir;
    if( o.profileDir === null )
    o.profileDir = _.censor.profileDir;
    if( o.storageTerminal === null )
    o.storageTerminal = _.censor.arrangedStorageTerminal;
    let storageName = _.path.join( o.storageDir, o.storageTerminal );

    let storagePath = _.fileProvider.configUserPath( storageName );

    if( _.fileProvider.fileExists( storagePath ) )
    _.fileProvider.fileDelete
    ({
      filePath : storagePath,
      verbosity : o.verbosity ? 3 : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to delete storage::${storageName}` );
  }

}

storageReset.defaults =
{
  storageDir : null,
  profileDir : null,
  storageTerminal : null,
  verbosity : 0,
}

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

  this.configStoragePath = _.path.join( this.storageDir, this.profileDir, this.configStorageTerminal );
  this.arrangedStoragePath = _.path.join( this.storageDir, this.profileDir, this.arrangedStorageTerminal );

}

// --
// relation
// --

let Action = _.blueprint.define
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

let ActionStatus = _.blueprint.define
({
  current : null,
  error : null,
  outdated : null,
});

let Storage = _.blueprint.define
({
  redo : _.define.shallow([]),
  undo : _.define.shallow([]),
});

// --
// declare
// --

let Extension =
{

  // action

  actionIs,
  actionStatus,
  actionDo,

  // operation

  fileReplace,
  filesReplace,

  filesHardLink,

  // do

  status,
  do : _do,
  redo,
  undo,

  // storage

  storageRead,
  storageOpen,
  storageClose,
  storageReset,

  // etc

  hashMapOutdatedFiles,

  //

  Init,

  // fields

  Action,
  ActionStatus,
  Storage,
  storageDir : '.censor',
  configStorageTerminal : 'config.yaml',
  profileDir : 'default',
  arrangedStorageTerminal : 'arranged.json',
  configStoragePath : null,
  arrangedStoragePath : null,

}

_.mapExtend( Self, Extension );
_.censor.Init();

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
