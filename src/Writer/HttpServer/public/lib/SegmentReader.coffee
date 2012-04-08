define ( require, module, exports ) ->
    # The SegmentReader uses Faye to connect to the `/segment` channel of the
    # server. It recieves every new segment and dispatches those information to
    # an arbitrary amount of Views, which might use the gathered information to
    # update their visual representation
    class SegmentReader
        # Construct a segment reader taking an array of views to dispatch new
        # segments to
        constructor: ( @views ) ->
            @fayeClient = new Faye.Client( '/faye' )
            @fayeClient.subscribe "/segment", @onNewSegment
            @segmentId = 0

        # Called by the Faye message bus as soon as a new segment has arrived.
        #
        # The new segment is provided as argument
        onNewSegment: ( segment ) =>
            # Each relayed segment is assigned a unique id. This allows for
            # more complex views or the possibility to update already displayed
            # segments in the future.
            @segmentId += 1
            for view in @views
                @relayNewSegmentToView segment, view

        # Relay the given segment to a stored specific view
        relayNewSegmentToView: ( segment, view ) ->
            view.handleSegment
                id: @segmentId
                data: segment

    module.exports = SegmentReader
