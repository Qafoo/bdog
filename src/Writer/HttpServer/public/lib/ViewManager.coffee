define(
  ["require", "q"],
  (require, Q) ->
    # Simple manager to retrieve, load and initialize Views.
    class ViewManager
      # Initialize the given views using the given container
      #
      # A promise will be returned, which provides an array of all view
      # objects after their initialization is finished.
      loadViews: (viewNames) ->
        promises = for viewName in viewNames
          @loadView viewName
        return Q.all(promises)

      # Load a view by name returning a promise, which will be resolved with
      # the view object once it is ready
      # The given viewName is either a simple string or a configuration object
      loadView: (viewName) ->
        if viewName.type?
          configuration = viewName
          viewName = viewName.type
        else
          configuration = {
            type: viewName
          }

        @requireWithPromise_ "lib/View/#{viewName}", configuration

      # Use requirejs to load a certain module, but instead of providing
      # a callback after it has been loaded return a promise, which is
      # resolved once the data has arrived.
      requireWithPromise_: (name, configuration) ->
        deferred = Q.defer()

        require [name], (object) ->
          deferred.resolve(
            class: object
            configuration: configuration
          )
        return deferred.promise
)