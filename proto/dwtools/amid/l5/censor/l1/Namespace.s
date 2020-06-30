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
  try
  {

    o = _.routineOptions( actionDo, arguments );

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

    if( o.verbosity && o.logging )
    if( o.mode === 'redo' )
    logger.log( o.action.redoDescription );
    else
    logger.log( o.action.undoDescription );

    if( o.mode === 'undo' )
    o.action.dataMapBefore = null;
    o.action.status.current = o.mode;
    storageUpdate();

  }
  catch( err )
  {

    // err = _.err( err, `\nFailed to redo ${o.action.name}` );
    err = _.err( err );

    debugger;
    let tab = '    ';
    err = _._err
    ({
      args : [ err ],
      message : ` ! failed to ${o.mode} ${o.action.name}\n` + tab + _.strLinesIndentation( err.message, tab ),
    });
    debugger;

    if( o.mode === 'redo' )
    o.action.dataMapBefore = null;
    o.action.status.error = String( err );

    if( err.reason === 'outdated' )
    o.action.status.outdated = true;

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
  logging : 0,
  verbosity : 2,
  throwing : 1,
}

//

function hashMapOutdatedFiles( o )
{
  let result = [];

  _.assert( _.mapIs( o.hashMap ) );

  o.dataMap = o.dataMap || Object.create( null );

  for( let filePath in o.hashMap )
  {
    let hash = o.hashMap[ filePath ];

    if( !o.dataMap[ filePath ] === undefined )
    o.dataMap[ filePath ] = _.fileProvider.read( filePath, 'buffer.raw' );

    if( !_.fileProvider.hashSzIsUpToDate({ filePath, data : o.dataMap[ filePath ], hash }) )
    {
      debugger;
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

  return o;
}

//

function fileReplace_body( o )
{

  _.assertRoutineOptions( fileReplace_body, arguments );
  _.assert( _.strDefined( o.filePath ) );
  _.assert( !!o.arranging );

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

  let opened = _.censor.storageOpen();
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
  delete action.parameters.logging;
  delete action.parameters.onTokenize;
  delete action.parameters.redoReseting;

  if( o.verbosity >= 2 )
  o.log = action.redoDescription2;
  else if( o.verbosity )
  o.log = action.redoDescription;

  opened.storage.redo.push( action );

  _.censor.storageClose( opened );

  if( o.logging )
  logger.log( o.log );

  return o;

  /* */

  function redo( op )
  {
    let _ = _global_.wTools;

    let o2 =
    {
      src : _.strFrom( op.dataMap[ op.action.filePath ] ),
      parcels : op.action.parameters.parcels,
      logging : op.logging,
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
  arranging : 1,
  redoReseting : 1,
  dry : 1,
  gray : 0,
  verbosity : 0,
  logging : 0,
}

let fileReplace = _.routineFromPreAndBody( replace_pre, fileReplace_body );

//

function filesReplace_body( o )
{

  o  =_.routineOptions( filesReplace, arguments );

  if( o.redoReseting )
  {
    let opened = _.censor.storageOpen();
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
  debugger;
  let files = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
    withDirs : 0,
    withDefunct : 0,
    revisitingHardLinked : 0,
  });
  debugger;

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
    let log = `\n . Found ${files.length} file(s). Arranged ${o.nparcels} replacement(s) in ${o.nfiles} file(s).`;
    o.log += log;
    if( o.logging )
    logger.log( log );
  }

  return o;
}

filesReplace_body.defaults =
{
  ... fileReplace.defaults,
  logging : 0,
  verbosity : 3,
  basePath : null,
  filePath : null,
}

let filesReplace = _.routineFromPreAndBody( replace_pre, filesReplace_body );

//

function status( o )
{
  let opened = _.censor.storageOpen();
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

    debugger;

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
  return o;
}

//

function do_body( o )
{
  let error;
  let opened;
  try
  {

    opened = _.censor.storageOpen({ storageName : o.storageName });

    if( !opened.storage || !opened.storage[ o.mode ].length )
    {
      if( o.verbosity )
      o.log = `Nothing to ${o.mode}.`;
      if( o.logging )
      logger.log( o.log );
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
      // let tab = '    ';
      // logger.error( ` ! failed to ${o.mode} ${doArray[ i ].name}\n` + tab + _.strLinesIndentation( String( err ), tab ) );
      debugger;
      // if( err.reason !== 'outdated' )
      if( !error )
      error = err;
    }

    if( o.verbosity ) /* xxx */
    {
      let log = ``;
      if( o.mode === 'undo' )
      log += `Undone ${ndone} action(s). Thrown ${nerrors} error(s).`;
      else
      log += `Done ${ndone} action(s). Thrown ${nerrors} error(s).`;
      if( o.logging ) /* xxx : logging -> logger */
      logger.log( log );
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
  storageName : null,
  dry : 0,
  depth : 0,
  verbosity : 3,
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
    o = { storageName : arguments[ 0 ] };
    o = _.routineOptions( storageRead, o );

    if( o.storageName === null )
    o.storageName = _.censor.storageName;

    let storagePath = _.fileProvider.configUserPath( o.storageName );

    if( !_.fileProvider.fileExists( storagePath ) )
    return '';

    return _.fileProvider.fileRead( storagePath );
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to read storage::${o.storageName}` );
  }
}

storageRead.defaults =
{
  storageName : null,
}

//

function storageOpen( o )
{
  try
  {

    if( _.strIs( arguments[ 0 ] ) )
    o = { storageName : arguments[ 0 ] };
    o = _.routineOptions( storageOpen, o );

    if( o.storageName === null )
    o.storageName = _.censor.storageName;

    o.storage = _.fileProvider.configUserRead( o.storageName );
    if( !o.storage )
    {
      o.storage = _.censor.Storage.construct();
      _.fileProvider.configUserWrite( o.storageName, o.storage );
    }

    // if( o.locking )
    // _.fileProvider.configUserLock( _.censor.storageName ); /* xxx */

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to open storage::${o.storageName}` );
  }
}

storageOpen.defaults =
{
  storageName : null,
  locking : 0,
  throwing : 1,
}

//

function storageClose( o )
{

  if( _.strIs( arguments[ 0 ] ) )
  o = { storageName : arguments[ 0 ] };
  o = _.routineOptions( storageClose, o );

  try
  {

    _.assert( _.mapIs( o.storage ) );

    if( o.storageName === null )
    o.storageName = _.censor.storageName;
    o.storage = _.fileProvider.configUserWrite( o.storageName, o.storage );

    // if( o.locking ) /* xxx */
    // _.fileProvider.configUserUnlock( _.censor.storageName );

    return o;
  }
  catch( err )
  {
    if( !o.throwing )
    return null;
    throw _.err( err, `\nFailed to close storage::${o.storageName}` );
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
  o = { storageName : arguments[ 0 ] };
  o = _.routineOptions( storageReset, o );

  try
  {

    if( o.storageName === null )
    o.storageName = _.censor.storageName;

    let storagePath = _.fileProvider.configUserPath( o.storageName );

    if( _.fileProvider.fileExists( storagePath ) )
    _.fileProvider.fileDelete
    ({
      filePath : storagePath,
      verbosity : o.verbosity ? 3 : 0,
    });

  }
  catch( err )
  {
    throw _.err( err, `\nFailed to delete storage::${o.storageName}` );
  }

}

storageReset.defaults =
{
  storageName : null,
  verbosity : 0,
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
  hashMapOutdatedFiles,

  // operation

  fileReplace,
  filesReplace,
  status,
  do : _do,
  redo,
  undo,

  // storage

  storageRead,
  storageOpen,
  storageClose,
  storageReset,

  //

  Action,
  ActionStatus,
  Storage,
  storageName : 'censor.json',

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
