# Segmenter, which does not apply any special segmenter logic
#
# The NoopSegmenter will simply create a new segment for every incoming chunk
# of information.
class NoopSegmenter
    # Output every incoming data as soon as it flys in as a new segment
    segment: ( buffer ) ->
        [[0, buffer.length]]

module.exports = NoopSegmenter
