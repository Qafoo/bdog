define ( require, module, exports ) ->
    # Really simple view interface, which simply appends each provided segment
    # to a <pre> element it creates in the given container.
    class SimpleView
        constructor: ( @container ) ->
            @pre = jQuery "<pre>"
            @pre.appendTo @container

        # Handle the segment by simply appending it to the <pre> tags content
        handleSegment: ( segment ) ->
            oldContent = @pre.text()
            @pre.text oldContent + segment.data

    module.exports = SimpleView
