stream = require( 'stream' )

# Writable Stream, which takes each segment and delegates its handling down to
# writer implementation
class OutputStream extends stream.Writable
    constructor: ( @writer ) ->
      super();

    # Write a segment to the stream
    #
    # Encoding is not used, the chunk is supposed to always be a Buffer
    _write: (chunk, encoding, done) ->
      @writer.write chunk
      done()


module.exports = OutputStream
