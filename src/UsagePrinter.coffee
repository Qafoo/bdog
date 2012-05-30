# Simple encapsulation of the usage information and their printing logic.
class UsagePrinter
    # Construct a new UsagePrinter taking the optmist parsed argv object as
    # well as a ProfileManager instance as arguments.
    #
    # The provided information is needed to gather meaningful configuration
    # options for the usage output.
    constructor: ( @argv, @manager ) ->

    # Output the usage information to the console.
    # 
    # Optionally a message may be specified, with is appended to the output
    perform: ( message = null )->
        console.log @getUsage()
        console.log( "\n#{message}" ) if message?
    
    # Create and return the usage information as a string
    getUsage: ->
        """
        Bdog - A better browser cat
        Usage: #{process.argv[0]} [[--profile=|-p] <profile>] [[--segmenter=|-s] <segmenter>] [[--browser=|-b] <browser>]

        Possible configuration options are:

          --profile|-p <profile>
            Specify a certain preconfigured display and proccessing profile. (Default: 'Default')
            The following profiles are available:
              
              #{@manager.getAvailableProfiles().join( "\n      " )}


          --segmenter|-s <segmenter>
            Specify a certain segmenter to be used.
            The following segmenters are available:

              #{@manager.getAvailableSegmenters().join( "\n      " )}


          --browser|-b <browser>
            Specify a certain browser to be executed.
            The following browsers are available:
              
              #{@manager.getAvailableBrowsers().join( "\n      " )}
              
          --include|-i <path>
            Specify a secondary include path. This path will be used in case a resource
            (Profile/Segmenter/...) can not be found at the default position. This might be
            useful if you want to create bdog extensions inside your own project folders


        All arguments are optional. The specified profile is used as a base on which
        the provided segmenter as well as browser will be applied as an override.
        """

module.exports = UsagePrinter
