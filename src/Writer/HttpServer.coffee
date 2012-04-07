express = require( "express" )
faye    = require( "faye" )

# HttpServer Writer implementation
#
# The HttpServerWriter will open up an HttpServer on a random port. This server
# provides a simple application for the Browser, which connects back to the
# server in order to have all segments pushed to it as soon as they get
# available.
class HttpServerWriter
    # Construct a new HttpServerWriter, which may listen on any interface/host
    #
    # If no listening host is specified localhost only is assumed
    constructor: ( host = 'localhost' ) ->
        @segmentsQueue_ = []
        @subscribedFayeClients_ = 0

        # Initialize the express application
        @expressApp_ = express.createServer()
        @expressApp_.configure =>
            @expressApp_.use express.static "#{__dirname}/HttpServer/public"

        # Attach a faye pubsub interface to our express server
        @bayeux_ = new faye.NodeAdapter({
            mount: "/faye"
            timeout: 45
        })
        @bayeux_.attach @expressApp_
        @bayeux_.bind "subscribe", @onFayeClientSubscribed_
        @bayeux_.bind "unsubscribe", @onFayeClientUnsubscribed_
        @fayeClient_ = @bayeux_.getClient()

        # Start the server on a random port and make sure we are informed about
        # the port it is running on as soon as it has been started
        @expressApp_.listen 0, host, @onServerListening_

    # Called by the OutputStream as soon as a new segment gets available.
    #
    # The segments are queued as long as at least one client is subscribed to
    # the `/segment` channel. If clients are available the data is directly
    # published.
    write: ( buffer ) ->
        if @subscribedFayeClients_ > 0
            @publish_ buffer
        else
            @segmentsQueue_.push buffer
    
    # Publish the contents of the given buffer as message on the `/segment`
    # channel
    publish_: ( buffer ) ->
        @fayeClient_.publish "/segment", buffer.toString 'utf8'

    # Process the segment queue, by publishing all queued segments
    processSegmentQueue_: ->
        while @segmentsQueue_.length > 0
            segment = @segmentsQueue_.shift()
            @publish_ segment

    # This callback is called as soon as the webserver is running.
    #
    # After the server is running the browser needs to be started loading up
    # the correct page.
    onServerListening_: =>
        address = @expressApp_.address()
        process.stderr.write "Server running at http://#{address.address}:#{address.port}\n"

    # Callback fired as soon as a FayeClient subscribes to a channel
    onFayeClientSubscribed_: ( clientId, channel ) =>
        return unless channel is "/segment"
        @subscribedFayeClients_ += 1

        # Send out queued information if first client connects
        if @subscribedFayeClients_ is 1
            @processSegmentQueue_()

    # Callback fired as soon as a faye client unsubscribes from a channel,
    # either by explicitely sending a unsubscribe message, or by timing
    # out
    onFayeClientUnsubscribed_: ( clientId, channel ) =>
        return unless channel is "/segment"
        @subscribedFayeClients_ -= 1

module.exports = HttpServerWriter
