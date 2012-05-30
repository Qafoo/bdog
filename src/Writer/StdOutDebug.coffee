# Really simple StdOut based writer, which simply writes out every segment on
# StdOut. It can be used for debugging Segmenters more easily.
class StdOutDebugWriter
    constructor: ( runner, includePaths, configuration ) ->
        console.log "IncludePaths -> #{JSON.stringify includePaths}"
        console.log "Configuration -> #{JSON.stringify configuration}"
        @segmentCount = 0

    write: ( segment ) ->
        console.log "[#{@segmentCount++}] Segment ->"
        console.log segment.toString( 'utf8' )

module.exports = StdOutDebugWriter
