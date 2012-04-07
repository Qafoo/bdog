Stream = require( 'stream' )

# Stream which uses an arbitrary segmenter implementation to segment given
# input data for sending to the OutputStream
#
# The SegmentStream reads from an InputStream and emits data in appropriate
# chunks, which will be determined by the given associated segmenter based on
# the read data.
#
# For example a JSONStreamSegmenter could emit a chunk of data after every
# completed JSON object. This allows the receiving client to visualize the
# received data in some meaningful way.
#
# The SegmentStream is a read/write Stream and therefore an EventEmitter as well
class SegmentStream extends Stream
    # The buffer used to internally store the segment before it is flushed is
    # always allocated as a multiple of this value
    @BUFFER_ALLOCATION_MULTIPLE = 4096

    # Create a new SegmentStream using the given SegmentStream.
    #
    # The supplied Segmenter is used to cut the received data into pieces
    constructor: ( @segmenter )->
        # Segmenter can be written to from a Reader as well as read from by the
        # Transmitter
        @readable = true
        @writable = true
        
        @encoding = null
        @segmentsQueue_ = []
        @clearSegmentBuffer_()

        @isPaused_ = false
        @shouldBeDestroyed_ = false

    # Pause the stream ceasing all emits of data.
    #
    # As long as a stream is paused no new data will be emitted from it.
    #
    # New data may be written to the stream however. The stream needs to take
    # care of queueing up the data while the stream is paused
    pause: ->
        @isPaused_ = true

    # Resume a string after it has been paused.
    #
    # If data has been queued up ready to be sent out, a call to this method
    # will immediately fire the needed events to publish the queued data.
    resume: ->
        @isPaused_ = false
        return if @segmentsQueue_.length is 0

        @processQueuedSegments_()
        @destroy if @shouldBeDestroyed_

    # Destroy the underlying stream. No further reading as well as writing will
    # be possible from this point on.
    #
    # All stored data is eliminated from memory and not being sent.
    destroy: ->
        # Set proper flags
        @isPaused_ = false
        # Set writable and readable flags to false as required by Stream
        # specification
        @writable = false
        @readable = false
        # Remove all data, which may still reside in memory
        @clearSegmentBuffer_()
        @segmentsQueue_ = []
        @emit "end"

    # Destroy the stream, but first write out the stored data
    destroySoon: ->
        @shouldBeDestroyed_ = true
        
        # The contents of the internal buffer is not considered in this check.
        # If there is still a non finished segment inside the buffer it will be
        # LOST.
        return if @isPaused and @segmentsQueue_.length > 0
        @destroy()

    # Set the encoding of this stream
    #
    # If an encoding is set the data event will not be emitted as Buffer, but
    # as decoded string
    setEncoding: ( encoding ) ->
        @encoding = encoding
    
    # Write the given string or buffer to the stream
    #
    # If a string is supplied instead of a raw buffer the second argument is
    # assumed the encoding the string is in
    #
    # If no encoding is given utf8 is assumed
    write: ( stringOrBuffer, encoding = "utf8" ) ->
        # A string with the given encoding or a raw buffer might have been
        # supplied. Simply convert whatever we got into an appropriate buffer.
        # This eases later handling a lot
        if typeof stringOrBuffer is "string"
            buffer = new Buffer( stringOrBuffer, encoding )
        else
            buffer = stringOrBuffer

        @appendToSegmentBuffer_ buffer
        @applySegmenter_()
        @processQueuedSegments_()

    # End the writing capabilities of the stream
    #
    # Optionally taking a string or a buffer to be written out, before ending
    # the Stream
    end: ( stringOrBuffer = null, encoding = "utf8" ) ->
        if stringOrBuffer?
            @write( stringOrBuffer, encoding )
        @writable = false
        @emit 'end'

    # Apply the associated segmenter against the currently stored buffer and
    # finalize possibly available segemnts
    applySegmenter_: ->
        croppedBuffer = @segmentBuffer_.slice 0, @segmentLength_
        ranges = @segmenter.segment croppedBuffer
        
        # If nothing is to be done simply return and wait for more data
        return if ranges?.length == 0
        @finalizeSegments_ ranges

    # Clear the internal segment buffer and reinitialize a new one.
    #
    # All data stored before is lost, if it is not stored elsewhere
    clearSegmentBuffer_: ->
        delete @segmentBuffer_
        @segmentBuffer_ = new Buffer( @constructor.BUFFER_ALLOCATION_MULTIPLE )
        @segmentBuffer_.fill 0
        @segmentLength_ = 0

    # Grow the internal segment buffer by the given amount of iterations
    #
    # One iteration is the size of @constructor.BUFFER_ALLOCATION_MULTIPLE. The
    # iteration count defaults to 1
    growSegmentBuffer_: ( iterations = 1 ) ->
        growBy = iterations * @constructor.BUFFER_ALLOCATION_MULTIPLE
        currentSize = @segmentBuffer_ .length

        newSegmentBuffer = new Buffer( currentSize + growBy )
        newSegmentBuffer.fill 0
        @segmentBuffer_.copy newSegmentBuffer
        delete @segmentBuffer_
        @segmentBuffer_ = newSegmentBuffer

    # Append the contents of another buffer to the current segment buffer
    #
    # The segment buffer will be grown if neccessary to hold the new
    # information
    appendToSegmentBuffer_: ( buffer ) ->
        if @segmentBuffer_.length <= buffer.length + @segmentLength_
            iterations = Math.ceil(
                @buffer.length / @constructor.BUFFER_ALLOCATION_MULTIPLE
            )
            @growSegmentBuffer_ iterations
        buffer.copy @segmentBuffer_, @segmentLength_
        @segmentLength_ += buffer.length
    
    # Finalize segments from the current buffer, by putting them into the
    # segments queue and removing processed data from the buffer
    #
    # The provided array of ranges is considered to be a list of start and end
    # offsets inside the buffer to be used as segments. Everything after the
    # last end offset is left inside the buffer after processing. Everything
    # before this offset is removed.
    #
    # A call to this method does emit a 'data' event, nor does it execute the
    # processing of the current segment queue. This has to be done using
    # `processQueuedSegments_`.
    finalizeSegments_: ( ranges ) ->
        end = -1
        for range in ranges
            [start, end] = range
            length       = end - start
            segment = new Buffer( length )
            @segmentBuffer_.copy segment, 0, start, end
            @segmentsQueue_.push segment

        leftOverLength = @segmentLength_ - end + 1
        if leftOverLength == 0
            @clearSegmentBuffer_()
        else
            @segmentBuffer_ = @segmentBuffer_.slice end + 1
            @segmentLength_ = leftOverLength
    
    # Process all segments which have been queued and therefore are ready to be
    # read from the stream.
    processQueuedSegments_: ->
        return if @segmentsQueue_.length == 0
        for segment in @segmentsQueue_
            emission = if @encoding? then segment.toString @encoding else segment
            @emit "data", emission
        @segmentsQueue_ = []

module.exports = SegmentStream
