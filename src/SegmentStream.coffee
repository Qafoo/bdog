stream = require( 'stream' )

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
class SegmentStream extends stream.Duplex
    # The buffer used to internally store the segment before it is flushed is
    # always allocated as a multiple of this value
    @BUFFER_ALLOCATION_MULTIPLE = 4096

    # Create a new SegmentStream using the given SegmentStream.
    #
    # The supplied Segmenter is used to cut the received data into pieces
    constructor: ( @segmenter )->
        @encoding = null
        @segmentsQueue_ = []
        @clearSegmentBuffer_()
        super()

    # Write the given string or buffer to the stream
    _write: (chunk, encoding, done) ->
      @appendToSegmentBuffer_ chunk
      @applySegmenter_()
      @processQueuedSegements_()
      done()

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
                buffer.length / @constructor.BUFFER_ALLOCATION_MULTIPLE
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
    # processing of the current segment queue.
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

    processQueuedSegements_: () ->
      return if @segmentsQueue_.length == 0
      # Push all currently available segments into the read queue, until
      # there are no more segments, or the queue is full
      while true
        segment = @segmentsQueue_.shift()
        break if !segment
        retVal = @push(segment)
        break if !retVal

    _read: () ->
      @processQueuedSegements_()

module.exports = SegmentStream
