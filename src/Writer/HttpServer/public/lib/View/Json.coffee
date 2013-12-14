define(
  ["jquery", "lib/View/Json/DefinitionListVisitor", "lib/View/Json/PrettyPrintJSVisitor"],
  (jQuery, DefinitionListVisitor, PrettyPrintJSVisitor) ->
    # View interface, which is capable of displaying JSON in a formatted and
    # interactive way
    class JsonView
      constructor: (@container, @configuration) ->
        # Default view configuration. Used if nothing else is specified
        @defaultConfiguration_= {
          visitor: "DefinitionList"
          maxDepth: -1
          expanded: true
        }
        @configuration = jQuery.extend {}, @defaultConfiguration_, @configuration

        # Initialize the configured Visitor
        visitorMapping = {
          "DefinitionList": DefinitionListVisitor
          "prettyprint.js": PrettyPrintJSVisitor
        }

        if !visitorMapping[@configuration.visitor]?
          throw new Error("Selected Visitor #{configuration.visitor} is not known by the JSON view.");

        @visitor_ = new visitorMapping[@configuration.visitor](@configuration);

        # Load the proper css ;)
        @loadCss_ "Json"

      # Handle each incoming segment
      # It is assumed each segment is valid JSON document.
      # The chosen segmenter has to take care of this.
      handleSegment: (segment) ->
        console.log(segment.data)
        document = JSON.parse(segment.data);
        @container.append(
          item = @visitor_.visit document
        )

        @scrollToObject_(item)

      # Scroll to the end of the display container
      # Essentially to where the new output has been added to
      scrollToObject_: (object) ->
        $(document).scrollTop object.position().top

      # Load a css file from the views css folder
      loadCss_: (css) ->
        jQuery("<link />",
          href: "css/Views/Json/#{css}.css"
          type: "text/css"
          rel: "stylesheet"
        ).appendTo jQuery("head")
)
