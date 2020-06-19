( function _Basic_s_( )
{

'use strict';

/* censor */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../dwtools/Tools.s' );
  _.include( 'wFiles' );
  _.include( 'wStringsExtra' );
  _.include( 'wStringer' );
  _.include( 'wBlueprint' );
  module[ 'exports' ] = _global_.wTools;
}

} )();
