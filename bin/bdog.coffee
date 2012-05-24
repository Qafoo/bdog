ProfileManager = require "../src/ProfileManager"
OutputStream      = require "../src/OutputStream"
HttpServerWriter  = require "../src/Writer/HttpServer"
BrowserRunner     = require "../src/BrowserRunner"

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

if argv.h?
    console.log """
                Bdog - A better browser cat
                Usage: #{process.argv[0]} [[--profile|-p] <profile>] [[--segmenter|-s] <segmenter>] [[--browser|-b] <browser>]

                Possible configuration options are:

                  --profile|-p <profile>
                    Specify a certain preconfigured display and proccessing profile. (Default: 'Default')
                    The following profiles are available:
                      
                      #{manager.getAvailableProfiles().join( "\n      " )}


                  --segmenter|-s <segmenter>
                    Specify a certain segmenter to be used.
                    The following segmenters are available:

                      #{manager.getAvailableSegmenters().join( "\n      " )}


                  --browser|-b <browser>
                    Specify a certain browser to be executed.
                    The following browsers are available:
                      
                      #{manager.getAvailableBrowsers().join( "\n      " )}


                All arguments are optional. The specified profile is used as a base on which
                the provided segmenter as well as browser will be applied as an override.
                """
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
