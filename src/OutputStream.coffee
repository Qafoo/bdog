Stream = require( 'stream' )

# Writable Stream, which takes each segment and delegates its handling down to
# writer implementation
class OutputStream extends Stream
    constructor: ( @writer ) ->
        @readable = false
        @writable = true
        
    # Destroy the stream
    #
    # No further writing will be possible after this method has been executed
    destroy: ->
        @writable = false

    # Destroy the stream after the queued information has been written
    #
    # As we synchronously send the data to the associated writer directly after
    # receiving it a call to this method is identical to calling destroy
    destroySoon: ->
        @destroy()

    # End the stream writing
    #
    # A buffer or a string may be supplied to be written out before the stream
    # is ended. If a string is provided you may provide an encoding as well. If
    # no encoding is specified utf8 will be assumed
    end: ( stringOrBuffer, encoding = 'utf8' ) ->
        if stringOrBuffer?
            @write stringOrBuffer, encoding
        @writable = false

    # Write a segment to the stream
    #
    # The segment may be provided either as buffer or as string.
    # If a string with no encoding is specified utf8 is assumed
    write: ( stringOrBuffer, encoding = 'utf8' ) ->
        if typeof stringOrBuffer is "string"
            buffer = new Buffer( stringOrBuffer, encoding )
        else
            buffer = stringOrBuffer

        @writer.write buffer

module.exports = OutputStream
