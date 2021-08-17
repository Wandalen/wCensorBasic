( function _Basic_s_()
{

'use strict';

/* censor */

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  _.include( 'wBlueprint' );
  _.include( 'wStringsExtra' );
  _.include( 'wStringer' );
  _.include( 'wProcess' );
  _.include( 'wResolver' );
  _.include( 'wFilesBasic' );
  _.include( 'wFilesArchive' );
  module[ 'exports' ] = _global_.wTools;
}

})();
