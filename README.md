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
