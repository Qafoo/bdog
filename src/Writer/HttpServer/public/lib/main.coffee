define (require, module, exports) ->
    SegmentReader = require( 'cs!lib/SegmentReader' )
    SimpleView = require( 'cs!lib/View/Simple' )
    
    reader = new SegmentReader(
        [
            new SimpleView(
                jQuery( "body" )
            )
        ]
    )
