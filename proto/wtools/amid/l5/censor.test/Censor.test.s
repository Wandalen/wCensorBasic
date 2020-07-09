( function _Censor_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../censor/entry/CensorBasic.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function basic( test )
{

}

// --
// test suite definition
// --

var Self =
{

  name : 'Tools.mid.Censor',
  silencing : 1,
  enabled : 1,

  tests :
  {

    basic,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
