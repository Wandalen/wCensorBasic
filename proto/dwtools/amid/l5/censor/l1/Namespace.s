( function _Namespace_s_( )
{

'use strict';

let _ = _global_.wTools;
let Self = _.censor = _.censor || Object.create( null );

// --
// implement
// --

function replace_pre( routine, args )
{
  let o = args[ 0 ];

  if( args.length > 1 )
  o = { src : args[ 0 ], ins : args[ 1 ], sub : args[ 2 ] }

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 3 );
  _.assert( _.strDefined( o.src ) );
  _.assert( _.strDefined( o.ins ) );
  _.assert( _.strDefined( o.sub ) );

  return o;
}

function replace_body( o )
{

  _.assertRoutineOptions( replace_body, arguments );

  {
    let o2 = _.mapOnly( o, _.strSearchReport.defaults );
    o.found = _.strSearchReport( o2 );
  }

  let storage = _.fileProvider.configUserRead( _.censor.storageName ); debugger;

  if( !storage )
  {
    storage = _.censor._storageMake();
    _.fileProvider.configUserWrite( _.censor.storageName, storage );
  }

  // _.fileProvider.configUserLock( _.censor.storageName );

  storage.redo = [];

  let action = this._actionMake();
  action.parameters = o;
  action.redo = _.routineSourceGet( redo );
  action.undo = _.routineSourceGet( undo );
  storage.redo.push( action );

  debugger;
  _.fileProvider.configUserWrite( _.censor.storageName, storage );
  debugger;

  return o;

  /* */

  function redo( action )
  {
    console.log( 'redo' );
  }

  function undo( action )
  {
    console.log( 'undo' );
  }

}

replace_body.defaults =
{
  src : null,
  ins : null,
  sub : null,
  nearestLines : 3,
  arranging : 1,
  dry : 1,
  gray : 0,
}

let replace = _.routineFromPreAndBody( replace_pre, replace_body );

//

function _actionMake()
{
  let result = Object.create( null );

  result.redo = null;
  result.undo = null;
  result.parameters = null;

  Object.preventExtensions( result );
  return result;
}

//

function _storageMake()
{
  let result = Object.create( null );

  result.redo = [];
  result.undo = [];

  return result;
}

// --
// declare
// --

let Extension =
{

  replace,

  _actionMake,
  _storageMake,

  //

  storageName : 'censor.json',

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
