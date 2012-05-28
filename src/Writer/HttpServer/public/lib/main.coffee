define (require, module, exports) ->
    SegmentReader = require( 'cs!lib/SegmentReader' )
    ViewManager = require( 'cs!lib/ViewManager' )
    
    # Retrieve the configuration from the server to know which Views to
    # initialize
    jQuery.get '/configuration', ( configuration ) ->
        manager = new ViewManager()
        body = jQuery( "body" )
        views = []

        # Initialize each view the configuration requests
        for viewName in configuration.views
            View = manager.locateViewByName viewName
            if View?
                instance = new View( body )
                views.push instance

        # Initialize the streaming by creating a segment reader with all the
        # configured views
        reader = new SegmentReader( views )
