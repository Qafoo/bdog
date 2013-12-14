define(
  ["jquery", "prettyPrint"],
  (jQuery, prettyPrint) ->
    # Visitor, which uses James Padolsey's prettyprint.js to format the JSON
    # output
    class PrettyPrintJSVisitor
      constructor: (@configuration) ->

      # Visit a JSON document root
      visit: (document) ->
        jQuery(
          prettyPrint(document, {
            maxDepth: @configuration.maxDepth
            expanded: @configuration.expanded
          })
        )
)
