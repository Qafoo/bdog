ProfileManager   = require "../src/ProfileManager"
UsagePrinter     = require "../src/UsagePrinter"
OutputStream     = require "../src/OutputStream"
HttpServerWriter = require "../src/Writer/HttpServer"
BrowserRunner    = require "../src/BrowserRunner"

# Configure long and short option aliases, as well as default configuration
# values.
Optimist = require( 'optimist' )
argv = Optimist.options(
    h:
        alias: "help"
    p:
        alias: "profile"
        default: "Default"
    s:
        alias: "segmenter"
    b:
        alias: "browser"
).argv

manager = new ProfileManager()

usagePrinter = new UsagePrinter( argv, manager )

if argv.h?
    usagePrinter.perform()
    process.exit 1

ConfiguredSegmenter = null
ConfiguredBrowser = null
WriterConfiguration = null

stream = new SegmenterStream(
    new ConfiguredSegmenter()
)

output = new OutputStream(
    new HttpServerWriter(
        new BrowserRunner(
            ConfiguredBrowser
        ),
        WriterConfiguration
    )
)

process.stdin.pipe stream
stream.pipe output
process.stdin.resume()
