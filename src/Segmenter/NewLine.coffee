# Simple segmenter, which segments by newlines
class NewlineSegmenter
    # Segment the given buffer into ranges
    #
    # The range start is inclusive the range end exclusive^^
    segment: ( buffer ) ->
        ranges = []
        string = buffer.toString 'utf8'
        start = 0
        end = -1

        while ( end = string.indexOf "\n", start ) != -1
            ranges.push [start, end]
            start = end + 1
        return ranges

module.exports = NewlineSegmenter
