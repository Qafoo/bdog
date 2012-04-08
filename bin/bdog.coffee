SegmenterStream   = require "../src/SegmentStream"
NoopSegmenter     = require "../src/Segmenter/Noop"
OutputStream      = require "../src/OutputStream"
HttpServerWriter  = require "../src/Writer/HttpServer"
BrowserRunner     = require "../src/BrowserRunner"

stream = new SegmenterStream(
    new NoopSegmenter()
)

output = new OutputStream(
    new HttpServerWriter(
        new BrowserRunner()
    )
)

process.stdin.pipe stream
stream.pipe output
process.stdin.resume()
