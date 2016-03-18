# bdog - A better bcat

`bdog` is a commandline utillity written in nodejs. Its functionality is
inspired by [bcat](https://github.com/rtomayko/bcat) by [Ryan
Tomayko](http://tomayko.com/about), which is a `cat` utillity for the browser.

I always liked the ability to stream logfiles, json responses or whatever
output I came accross inside a terminal to my browser window. The only thing
I was always missing was a more sophisticated view inside the browser (eg.
Syntax highlighting, JSON data as an unfoldable tree structure, animation
highlights if new lines are recieved.). That's why I decided to hack together
`bdog`. As with `cat` and `dog`, `bdog` is supposed to be a better `bcat`.

## Installation

### Using npm

You may install a running version of **bdog** using *npm*:

	npm install bdog -g
	
The above command will install the `bdog` command globally for your current
system.

### Cloning the repository

An alternative to using `npm` for installing is to simply clone the git
repository. After that a certain amount of preparation needs to be done in
order to install all needed dependencies:

	npm install

The `npm install` task should automatically run `grunt` to create a build of
the software inside the `dist` folder. Every time you change the code `grunt`
is needed to be run in order to compile the coffee-script code into javascript
code

## Usage

`bdog` can be used mostly like you would use `cat` (or `dog`). Simply pipe any
content to the command:

    echo 'Yeah!! Piped to Browser!' | bdog

After issuing this command a browser will automatically opened and the data
will be streamed to it.

If ANSI colored content is piped to bdog it will be automatically transformed
into the correct HTML to display it colorful there as well.

### Advanced options

Executing `bdog --help` provides a quite complete usage information listing:

    Bdog - A better browser cat
    Usage: node [[--profile=|-p] <profile>] [[--segmenter=|-s] <segmenter>] [[--browser=|-b] <browser>]

    Possible configuration options are:

      --profile|-p <profile>
        Specify a certain preconfigured display and proccessing profile. (Default: 'Default')
        The following profiles are available:
          
          Debug
          Default


      --segmenter|-s <segmenter>
        Specify a certain segmenter to be used.
        The following segmenters are available:

          NewLine
          Noop


      --browser|-b <browser>
        Specify a certain browser to be executed.
        The following browsers are available:
          
          SystemDefault
          chromium
          
      --include|-i <path>
        Specify a secondary include path. This path will be used in case a resource
        (Profile/Segmenter/...) can not be found at the default position. This might be
        useful if you want to create bdog extensions inside your own project folders


    All arguments are optional. The specified profile is used as a base on which
    the provided segmenter as well as browser will be applied as an override.

#### Profile

**bdog** allows for the definition of profiles. Profiles always consist of
a Browser, a Segmenter and a certain information about which views are supposed
to be loaded.

After you created your own view on data you may create such a profile to easily
change the look&feel of bdog completely.

Take a look at the Default profile at `src/Profile/Default.coffee`. It is
heavily documented and can provide a starting point for creating your own.

#### Segmenter

To ease the processing of data send to the browser the stdin stream needs to be
devided into chunks, which are then transfered to the browser for processing.
`Segmenter` implementations allow to configure how this splitting is done
exactly. By default the `NoopSegmenter` is used. It transmits the data as soon
as they are provided using stdin.

An example for another Segmenter is a JSONSegmenter, which for example buffers
the stream until a full JSON object is available. Once this is the case the
object can be transferred in one chunk. This eases the processing on the
browser side.

#### Browser

Each browser, which should be started by `bdog` needs a `BrowserProfile`.
Those definitions are easy to write. They mostly define the executable and
arguments to be passed to it in order to execute the correct browser.
BrowserProfiles allow the configuration to support multipe operating systems.

Take a look at `src/Browser/SystemDefault.coffee` for an example of such a profile.

## Development

During development the `grunt watch` task can help you. Due to the fact that
a lot of different tasks need to be executed each time you change
a CoffeeScript file. Opening a console and issueing the following command will
monitor for all kinds of changes and triggers a rebuild once any file changes:

    grunt watch

## Current status

The basic implementation currently ready mimics most of bcats basic behaviour.
Therefore it can be used as a drop in replacement in most situations currently.
The application architecture allows for easy integration of advanced views and
all the graphical stuff I would like in the future. Currently none of those are
implemented. They will follow as soon as I got some more spare time.
