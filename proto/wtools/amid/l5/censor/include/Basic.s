( function _Basic_s_( )
{

'use strict';

/* censor */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../wtools/Tools.s' );
  _.include( 'wFiles' );
  _.include( 'wFilesArchive' );
  _.include( 'wStringsExtra' );
  _.include( 'wStringer' );
  _.include( 'wBlueprint' );
  _.include( 'wProcess' );
  module[ 'exports' ] = _global_.wTools;
}

} )();
