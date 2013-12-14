NewLineSegmenter     = require( '../Segmenter/NewLine' )
SystemDefaultBrowser = require( '../Browser/SystemDefault' )
HttpServerWriter     = require( '../Writer/HttpServer' )


# Default profile used if nothing else is specified.
# 
# This profile represents the most simple bdog application:
# Streaming data from stdin to the system browser without interfering with it
# in any way.
DefaultProfile =
    # Segmenter to be used by this profile
    Segmenter: NewLineSegmenter

    # Browser configuration to be used by this profile
    browser: SystemDefaultBrowser

    # Writer to be used by default. Most likely no other writer than the
    # HttpServerWriter will ever be created, but, you never know.
    Writer: HttpServerWriter

    # Arbitrary further configuration information, which can be used by the
    # writer to adapt to sepcial situations
    #
    # The default configuration does only include the necessary entrypoint html
    # page to be loaded
    configuration:
        site: 'index.html'
        views: [
          {type: "Json"}
        ]

module.exports = DefaultProfile
