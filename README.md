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

## Current status

The basic implementation currently ready mimics most of bcats basic behaviour.
Therefore it can be used as a drop in replacement in most situations currently.
The application architecture allows for easy integration of advanced views and
all the graphical stuff I would like in the future. Currently none of those are
implemented. They will follow as soon as I got some more spare time.

## Installation

### Using npm

You may install a running version of **bdog** using *npm*:

	npm install bdog -g
	
The above command will install the `bdog` command globally for your current system.

### Cloning the repository

An alternative to using `npm` for installing is to simply clone the git repository. After that a certain amount of preparation needs to be done in order to install all needed dependencies:

	npm install

The `npm install` task should automatically run `grunt` to create a build of the software inside the `dist` folder. Every time you change the code `grunt` is needed to be run in order to compile the coffee-script code into javascript code
