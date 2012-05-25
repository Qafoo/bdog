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
        alias   : "profile"
        default : "Default"
        type    : "string"
    s:
        alias : "segmenter"
        type  : "string"
    b:
        alias : "browser"
        type  : "string"
).argv

# Instantiate needed processing handlers for profile and usage information
manager      = new ProfileManager()
usagePrinter = new UsagePrinter( argv, manager )

# Print help text and exit if requested by -h|--help argument
if argv.h?
    usagePrinter.perform()
    process.exit 1

# Ensure if options have been supplied they have been supplied as strings
# Otherwise bail out
if (
    ( argv.profile? && typeof argv.profile isnt "string" ) ||
    ( argv.segmenter? && typeof argv.segmenter isnt "string" ) ||
    ( argv.browser? && typeof argv.browser isnt "string" )
)
    usagePrinter.perform( "Error: Supplied options must be followed by a string." )
    process.exit( 2 )

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
