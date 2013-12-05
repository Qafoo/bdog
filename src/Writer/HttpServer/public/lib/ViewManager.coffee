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
      loadView: (viewName) ->
        @requireWithPromise_ "lib/View/#{viewName}"

      # Use requirejs to load a certain module, but instead of providing
      # a callback after it has been loaded return a promise, which is
      # resolved once the data has arrived.
      requireWithPromise_: (name) ->
        deferred = Q.defer()

        require [name], (object) ->
          deferred.resolve(object)
        return deferred.promise
)