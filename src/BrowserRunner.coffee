SystemDefaultBrowser = require( './Browser/SystemDefault' )
ChildProcess = require( 'child_process' )

# The BrowserRunner is an abstraction layer to run a browser window with
# a certain URL.
#
# Its main purpose is to abstract the operation system specific execution rules
# from its interface
class BrowserRunner
    # Construct a new BrowserRunner using the supplied Browser
    #
    # By default the systems default browser will be used instead of
    # a specific Browser. If a Browser is specified it is supposed to be
    # an Object with the following properties:
    #   
    #   name: Textual representation of the Browsers name
    #   executables: A key value mapping of platforms to their specific browser
    #       executable. The platform mappings are a regular expression in
    #       string representation, to allow matching of multiple systems like
    #       linux[0-9]. The expression is automatically anchored during
    #       execution.
    #   args: Array of arguments appended after the executable. The special
    #   part `%url%` will be replaced with the url to open.  If the commandline
    #   is not specified only the url will be used after the browser
    #   executable.
    constructor: ( @browser = SystemDefaultBrowser ) ->
        @executable = @extractPlatformExecutable_ @browser
        @args = if @browser.args? then @browser.args else ['%url%']

    # Open the given url inside the browser specified by the given browser
    # definition
    open: ( url ) ->
        args = for argument in @args
            argument.replace( /%url%/, url )
        child = ChildProcess.spawn @executable, args

    # Return the executable for the current platform from the given Browser
    # definition
    #
    # If no executions match the current platform an Error will be thrown
    extractPlatformExecutable_: ( browser ) ->
        for expression, executable of browser.executables
            anchoredExpression = "^#{expression}$"
            matcher = new RegExp( anchoredExpression )
            if matcher.test( process.platform )
                return executable
        throw new Error "No Browser executable was defined for your System: #{process.platform}"

module.exports = BrowserRunner
