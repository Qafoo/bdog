define ( require, module, exports ) ->
    # Simple manager to load and retrieve Views.
    class ViewManager
        # Fetch all available views here statically, as dynamic requirement can
        # be quite tricky.
        @availableViews_ =
            'simple': require 'cs!lib/View/Simple'
            
        # Locate a View by name.
        #
        # If the View can not be found undefined will be returned
        locateViewByName: ( name ) ->
            if @.constructor.availableViews_[name]?
                return @.constructor.availableViews_[name]
