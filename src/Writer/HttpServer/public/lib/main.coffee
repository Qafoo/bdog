define(
  ["jquery", "cs!lib/SegmentReader", "cs!lib/ViewManager"],
  (jQuery, SegmentReader, ViewManager) ->
    # Retrieve the configuration from the server to know which Views to
    # initialize
    jQuery.get '/configuration', (configuration) ->
      manager = new ViewManager()
      body = jQuery("body")

      # Initialize each view the configuration requests
      manager.loadViews(
        configuration.views
      ).then (views) ->
        instantiatedViews = for View in views
          new View(body)

        # Initialize the streaming by creating a segment reader with all the
        # configured views
        reader = new SegmentReader(instantiatedViews)
)