fs   = require 'fs'
path = require 'path'

DefaultProfile = require './Profile/Default'

# Managament facillity for different preconfigured profiles, which may
# influence used Segmenters, segmenterRunners, and Views.
class ProfileManager
    # Path to profiles used to scan during name lookup relative to the include
    # path
    @profilePath = "Profile"
    
    # Path to segmetners used to scan during name lookup relative to the
    # include path
    @segmenterPath = "Segmenter"
    
    # Path to browsers used to scan during name lookup relative to the include
    # path
    @browserPath = "Browser"

    # Construct a new ProfileManager, which may be utilized to locate, load and
    # access all different kinds of needed profile information.
    constructor: ->
        @includePaths = [
            __dirname
        ]
        @availableProfiles_ = null
        @availableSegmenters_ = null
        @availablesegmenters_ = null

    # Add another include path to find an load all Profile related information
    addIncludePath: ( path ) ->
        @includePaths.push path

    # Return a list of registered include paths
    getIncludePaths: ->
        @includePaths
    
    # Try to locate a certain profile by its name.
    #
    # If a profile with the given name exists within the `Profile` directory it
    # will be loaded and returned. If no profile with the given name could be
    # located `undefined` will be returned.
    locateProfileByName: ( profileName ) ->
        @readAvailableProfiles_() if not @availableProfiles_?
        return @availableProfiles_[profileName.toLowerCase()]?.object

    # Retrieve a list of all available profiles
    getAvailableProfiles: ->
        @readAvailableProfiles_() if not @availableProfiles_?
        for name, profileInfo of @availableProfiles_
            profileInfo.name

    # Try to locate a certain Segmenter by its name
    #
    # If a segmenter with the given name exists within the `Segmenter` directory
    # it will be returned. If no such `Segmenter` defintion could be located
    # `undefined` will be returned.
    locateSegmenterByName: ( segmenterName ) ->
        @readAvailableSegmenters_() if not @availableSegmenters_?
        return @availableSegmenters_[segmenterName.toLowerCase()]?.object
    
    # Retrieve a list of all available segmenters
    getAvailableSegmenters: ->
        @readAvailableSegmenters_() if not @availableSegmenters_?
        for name, segmenterInfo of @availableSegmenters_
            segmenterInfo.name
    
    # Try to locate a certain Browser by its name
    #
    # If a browser with the given name exists within the `Browser` directory it
    # will be returned. If no such `Browser` defintion could be located
    # `undefined` will be returned.
    locateBrowserByName: ( browserName ) ->
        @readAvailableBrowsers_() if not @availableBrowsers_?
        return @availableBrowsers_[browserName.toLowerCase()]?.object
    
    # Retrieve a list of all available browsers
    getAvailableBrowsers: ->
        @readAvailableBrowsers_() if not @availableBrowsers_?
        for name, browserInfo of @availableBrowsers_
            browserInfo.name

    # Read all the available profiles from the defined `profilePath` and store
    # them as `filename => Profile` association for later lookup.
    #
    # The retrieval is synchronous at is is only called once during the startup
    # sequence.
    readAvailableProfiles_: ->
        @availableProfiles_ = @readDirectoryObjects_ @constructor.profilePath

    # Read all the available segmenter from the defined `segmenterPath` and
    # store them as `filename => Segmenter` association for later lookup.
    #
    # The retrieval is synchronous at is is only called once during the startup
    # sequence.
    readAvailableSegmenters_: ->
        @availableSegmenters_ = @readDirectoryObjects_ @constructor.segmenterPath

    # Read all the available browsers from the defined `browserPath` and store
    # them as `filename => browser` association for later lookup.
    #
    # The retrieval is synchronous at is is only called once during the startup
    # sequence.
    readAvailableBrowsers_: ->
        @availableBrowsers_ = @readDirectoryObjects_ @constructor.browserPath

    # Scan the provided relativePath in relation to all includePath and return
    # found objects.
    readDirectoryObjects_: ( relativePath ) ->
        mergedObjects = {}
        for includePath in @includePaths
            foundObjects = @readDirectoryObjectsFromAbsolutePath_(
                "#{includePath}/#{relativePath}"
            )
            for name, data of foundObjects
                continue if mergedObjects[name] isnt undefined
                mergedObjects[name] = data

        return mergedObjects

    # Read the contents of a given directory and isolate all coffee/js files in
    # it. Require them and return an easily accessible name => information
    # mapping between the filenames and their contents.
    readDirectoryObjectsFromAbsolutePath_: ( absolutePath ) ->
        return {} if path.existsSync( absolutePath ) isnt true

        filterExpression = /^(.+?)\.(coffee|js)$/
        foundObjects = {}
        for filename in fs.readdirSync absolutePath
            match = filterExpression.exec filename
            if match is null then continue

            foundObjects[match[1].toLowerCase()] =
                name: match[1]
                type: match[2]
                "filename": filename
                filepath: "#{absolutePath}/#{filename}"
                object: require "#{absolutePath}/#{match[1]}"
        return foundObjects

module.exports = ProfileManager
