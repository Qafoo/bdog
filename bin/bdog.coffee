#!/usr/bin/env node

path = require "path"

ProfileManager   = require "../src/ProfileManager"
UsagePrinter     = require "../src/UsagePrinter"
SegmentStream    = require "../src/SegmentStream"
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
    i:
        alias : "include"
        type  : "string"
).argv

# Instantiate needed processing handlers for profile and usage information
manager      = new ProfileManager()
usagePrinter = new UsagePrinter( argv, manager )

# Add the secondary include path to the profileManager if given
if argv.include? && typeof argv.include is "string"
    manager.addIncludePath path.resolve argv.include

# Print help text and exit if requested by -h|--help argument
if argv.help?
    usagePrinter.perform()
    process.exit 1

# Ensure if options have been supplied they have been supplied as strings
# Otherwise bail out
if (
    ( argv.profile? && typeof argv.profile isnt "string" ) ||
    ( argv.segmenter? && typeof argv.segmenter isnt "string" ) ||
    ( argv.browser? && typeof argv.browser isnt "string" ) ||
    ( argv.include? && typeof argv.include isnt "string" )
)
    usagePrinter.perform( "Error: Supplied options must be followed by a string." )
    process.exit( 2 )

# Try to load the requested profile
activeProfile = manager.locateProfileByName( argv.profile )
if not activeProfile?
    usagePrinter.perform "Error: The given profile #{argv.profile} is invalid."
    process.exit 2

# If there are overwrites for browser or segmenter defined apply them ontop of
# the profile
if argv.segmenter?
    activeProfile.Segmenter = manager.locateSegmenterByName argv.segmenter
    if not activeProfile.Segmenter?
        usagePrinter.perform "Error: The specified segmenter '#{argv.segmenter}' is invalid."
        process.exit 3

if argv.browser?
    activeProfile.browser = manager.locateBrowserByName argv.browser
    if not activeProfile.browser?
        usagePrinter.perform "Error: The specified browser '#{argv.browser}' is invalid."
        process.exit 3

stream = new SegmentStream(
    new activeProfile.Segmenter()
)

output = new OutputStream(
    new activeProfile.Writer(
        new BrowserRunner(
            activeProfile.browser
        ),
        manager.getIncludePaths(),
        activeProfile.configuration
    )
)

process.stdin.pipe(stream).pipe(output)
