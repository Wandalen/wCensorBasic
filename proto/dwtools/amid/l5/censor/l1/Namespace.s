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
  return;

  if( o.action.status.error )
  {
    if( o.verbosity >= 2 )
    {
      result = String( o.action.error );
    }
    else if( o.verbosity >= 1 )
    {
      result = `Error in ${o.action.naem}`;
    }
  }
  else
  {
    if( o.verbosity >= 2 )
    {
      result = o.action.description2;
    }
    else if( o.verbosity >= 1 )
    {
      result = o.action.description;
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

function actionRedo( o )
{
  try
  {

    o = _.routineOptions( actionRedo, arguments );
    _.assert( _.mapIs( o.action.status ) );
    _.assert( o.action.status.done === false, () => `${o.action.name} is alread done` );
    if( o.action.status.error )
    throw _.err( o.action.status.error );

    let redo = o.action.redo;
    if( _.strIs( redo ) )
    redo = _.routineMake({ code : redo, prependingReturn : 1 })();

    let outdated = _.censor.actionOutdatedFiles( o.action );
    if( outdated.length )
    throw _.errBrief( `Files are outdated:\n  ${ outdated.join( '  \n' ) }` );

    redo( o );

    if( o.verbosity && !o.log )
    {
      if( o.verbosity >= 2 )
      o.log = o.action.description2;
      else
      o.log = o.action.description;
    }

    debugger;
    if( o.logging )
    logger.log( o.log );

    o.action.status.done = true;
    if( o.storage )
    {
      _.arrayRemoveOnceStrictly( o.storage.redo, o.action );
      _.arrayPrepend( o.storage.undo, o.action );
    }

  }
  catch( err )
  {
    debugger;
    err = _.err( err, `\nFailed to redo ${o.action.name}` );
    o.action.status.error = String( err );
    _.errAttend( err, 0 );
    _.errLogEnd( err, 0 );
    throw err;
  }
}

actionRedo.defaults =
{
  action : null,
  dry : 0,
  storage : null,
  logging : 0,
  verbosity : 2,
}

//

function actionOutdatedFiles( action )
{
  let result = [];

  _.assert( _.mapIs( action.hash ) );

  for( let filePath in action.hash )
  {
    let hash = action.hash[ filePath ];

    if( !_.fileProvider.hashSzIsUpToDate( filePath, hash ) )
    {
      debugger;
      result.push( filePath );
    }

  }

  return result;
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
    o.found.forEach( ( it ) =>
    {
      _.assert( _.strIs( it.input ) );
      delete it.input;
    });
  }

  if( !o.found.length )
  return o;

  let opened = _.censor.storageOpen();
  if( o.redoReseting )
  opened.storage.redo = [];

  let tab = '     ';
  let action = this.Action.construct();
  action.status = this.ActionStatus.construct();
  action.filePath = o.filePath;
  action.hash = { [ action.filePath ] : hash };

  action.name = `action::replace ${o.found.length} in ${o.filePath}`;
  if( o.gray )
  action.description = ` + replace ${o.found.length} in ${o.filePath}`;
  else
  action.description = ` + replace ${o.found.length} in ${_.ct.format( o.filePath, 'path' )}`;
  action.description2 = action.description + `\n`;
  action.description2 += tab + _.strLinesIndentation( o.searchLog, tab );
  action.redo = _.routineSourceGet( redo );
  action.undo = _.routineSourceGet( undo );
  action.parameters = _.mapExtend( null, o );
  debugger;
  delete action.parameters.arranging;
  delete action.parameters.determiningLineNumber;
  delete action.parameters.dry;
  delete action.parameters.logging;
  delete action.parameters.onTokenize;
  delete action.parameters.redoReseting;

  if( o.verbosity >= 2 )
  o.log = action.description2;
  else if( o.verbosity )
  o.log = action.description;

  opened.storage.redo.push( action );

  _.censor.storageClose( opened );

  if( o.logging )
  logger.log( o.log );

  return o;

  /* */

  function redo( op )
  {
    let _ = _global_.wTools;
    debugger;

    for( let i = 0 ; i < op.action.parameters.found.length ; i++ )
    {
      let it = op.action.parameters.found[ i ];

      debugger;

    }

    debugger;
    // console.log( `redo ${op.action.name}` );
  }

  function undo( op )
  {
    // console.log( `undo ${op.action.name}` );
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

  o.nreplacements = 0;
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
  });

  for( let f = 0 ; f < files.length ; f++ )
  {
    let o2 = _.mapOnly( o, _.censor.fileReplace.defaults );
    o2.verbosity = o2.verbosity - 1 >= 0 ? o2.verbosity - 1 : 0;
    o2.filePath = files[ f ].absolute;
    o2.redoReseting = 0;
    _.censor.fileReplace( o2 );
    _.assert( _.intIs( o2.found.length ) );
    o.files.push( o2 );
    o.nreplacements += o2.found.length;
    if( o2.found.length )
    o.nfiles += 1;
    if( o.verbosity >= 2 && o2.log )
    o.log += o2.log;
  }

  if( o.verbosity >= 1 )
  {
    let log = `\n . Found ${files.length} file(s). Arranged ${o.nreplacements} replacement(s) in ${o.nfiles} file(s).`;
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
  let log = Object.create( null );
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

    log.redo = _.filter_( null, opened.storage.redo, ( action ) =>
    {
      let o2 = _.mapOnly( o, _.censor.actionStatus.defaults );
      o2.action = action;
      o2.verbosity = o2.verbosity - 1;
      return _.censor.actionStatus( o2 );
    });

    log.undo = _.filter_( null, opened.storage.undo, ( action ) =>
    {
      let o2 = _.mapOnly( o, _.censor.actionStatus.defaults );
      o2.action = action;
      o2.verbosity = o2.verbosity - 1;
      return _.censor.actionStatus( o2 );
    });

  }
  else if( o.verbosity === 1 )
  {
    log.redo = opened.storage.redo.length;
    log.undo = opened.storage.undo.length;
  }

  _.censor.storageClose( opened );

  return log;
}

status.defaults =
{
  verbosity : 3,
  withUndo : 1,
  withRedo : 1,
  withErrors : 1,
}

//

function redo( o )
{
  let opened;
  try
  {

    o = _.routineOptions( redo, arguments );

    opened = _.censor.storageOpen({ storageName : o.storageName });

    if( !opened.storage || !opened.storage.redo.length )
    {
      if( o.verbosity )
      o.log = 'Nothing to redo.';
      if( o.logging )
      logger.log( o.log );
      return o;
    }

    if( o.depth === 0 )
    o.depth = Infinity;
    o.depth = Math.min( o.depth, opened.storage.redo.length );

    let ndone = 0;
    let nerrors = 0;
    let redoArray = opened.storage.redo.slice();
    for( let i = 0 ; i < o.depth; i++ )
    {
      let o2 = _.mapOnly( o, _.censor.actionRedo.defaults );
      o2.action = redoArray[ i ];
      o2.verbosity = o2.verbosity - 1 >= 0 ? o2.verbosity - 1 : 0;
      o2.storage = opened.storage;
      _.censor.actionRedo( o2 );
      if( o.verbosity > 1 )
      if( o.log )
      o.log += '\n' + o2.log;
      else
      o.log = o2.log;
      if( o2.action.status.done )
      ndone += 1;
      if( o2.action.status.error )
      nerrors += 1;
    }

    if( o.verbosity ) /* xxx */
    {
      let log = `Did ${ndone} action(s). Thrown ${nerrors} error(s).`;
      if( o.log ) /* xxx : rename */
      o.log += '\n' + log;
      else
      o.log = log;
      if( o.logging ) /* xxx : logging -> logger */
      logger.log( log );
    }

    _.censor.storageClose( opened );

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

redo.defaults =
{
  ... _.mapBut( actionRedo.defaults, [ 'action' ] ),
  storageName : null,
  dry : 0,
  depth : 1,
  verbosity : 3,
}

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
  description : null,
  description2 : null,
  filePath : null,
  hash : null,
  status : null, /* xxx : use ActionStatus immediately */
  parameters : null,
  redo : null,
  undo : null,
});

let ActionStatus = _.blueprint.define
({
  done : false,
  error : null,
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
  actionRedo,
  actionOutdatedFiles,

  // operation

  fileReplace,
  filesReplace,
  status,
  redo,

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
