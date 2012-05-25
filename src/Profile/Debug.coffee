NoopSegmenter     = require( '../Segmenter/Noop' )
StdOutDebugWriter = require( '../Writer/StdOutDebug' )


# Debug profile using a writer to dump everything to stdout
DebugProfile =
    Segmenter: NoopSegmenter
    browser: null
    Writer: StdOutDebugWriter
    configuration: {}

module.exports = DebugProfile
