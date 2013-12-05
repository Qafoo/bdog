define(
  ["jquery", "ansi-to-html"],
  (jQuery, AnsiConverter) ->
    # Quite Simple View interface, which displays everything exactly as on the console,
    # but transforms ansi color codes to html color codes
    #
    # In the future it might be useful to reimplement the ansi-to-html functionality to be
    # really streaming aware in order to need less memory and processing time for big data streams
    class AnsiView
      constructor: (@container) ->
        @segmentCache = []

        @pseudoPre = jQuery "<div>", {
          css:
            'white-space': 'pre'
            'font-family': 'monospace'
            'margin': '1em 0px'
        }
        @pseudoPre.appendTo @container

        @ansi = new AnsiConverter();

      # Handle the segment by simply appending it to the <pre> tags content
      handleSegment: (segment) ->
        @segmentCache.push segment.data
        @pseudoPre.html @colorize @segmentCache
        $(document).scrollTop @pseudoPre.position().top + @pseudoPre.height()

      # Colorize an input of ansi encoded chunks
      colorize: (ansiChunks) ->
        @ansi.toHtml ansiChunks.join("")
)
