---
layout: "/_layout.html.haml"
title: Running babushka
---


## Commandline Syntax

Babushka's commandline syntax is a subcommand & options style, similar to `git` and `gem`. To see the subcommands available, you can run

    $ babushka help

To run deps, use the "meet" subcommand, passing the dep names you're after as arguments. But "meet" is also the default subcommand, so the best way to run deps is to just pass them as arguments, straight up. For example, to run the "rubygems" dep:

    $ babushka rubygems

There are several useful options to use when running deps. The one you'll be after most regularly is `--debug`, which makes babushka much more verbose. In particular, output from long-running shell commands will be printed in realtime.

    $ babushka rubygems --debug

Two other commonly used options for "meet" are `--dry-run`, to check whether deps are met without meeting them, and `--defaults`, to run babushka non-interactively so it doesn't prompt for input at runtime.

For more details on options and arguments, see the "help" output for a specific subcommand:

    $ babushka help meet

You can abberviate subcommands as long as they remain unique. All the subcommands except 'sources' and 'search' can be abbreviated to a single letter without any ambiguity.


## The babushka console

Although babushka is predominantly a commandline app, it's not implemented that way. All the commandline functionality is available at a ruby console too:

    $ babushka console


## Using babushka as a library

All that does is start an irb session, requiring 'lib/babushka'. Everything will work as expected if you require 'lib/babushka' in a program of your own and then use babushka programatically.

The top-level methods like `dep` and `meta` won't be included by default; you can `include Babushka::DSL` to add them to whatever scope you like.

The only caveat to be aware of is that babushka does monkey-patch some convenience methods onto core classes, like `Array#collapse` and `String#p`. If babushka's primary use was as a library then I wouldn't be patching in this way, but I think it's a worthwhile tradeoff for the concise deps that the patches allow you to write.


## Source Loading

To load the source, babushka requires every `.rb` file (in an indeterminate order; `Dir.glob` is in filesystem order on Linux, not alphabetical), and stores the names and blocks for each dep. The deps themselves are defined lazily, though -- the outer block of each dep is only run as the dep itself is run. (Run with `--debug` and watch for the 'defining dep against template' messages to see for yourself.)

Meta deps are defined eagerly, but the template within a meta dep is only run when a dep is (lazily) defined against it.

So, you don't need to require any of the `.rb` files from each other in line with dep requires -- lazy dep defining always happens after source loading is complete. At that point all the files have been parsed and required, so babushka has already located all the deps in the source.


## Logs

As was mentioned above, the `--debug` option causes babushka to print more verbose information as it runs. Shell commands will print their full output as they run, and babushka will print details about its own operation -- for example, it will print a message as it lazily defines each dep.

If an exception is raised, then by default, babushka prints the exception message, and the step in the backtrace that occurred within your dep, if any. When `--debug` is passed, though, babushka prints the full backtrace.

All this information is too verbose to print all the time, so you'll probably only want to use `--debug` when you're troubleshooting a dep, or hacking on babushka itself. But sometimes it's useful to look at debugging information after the fact, and so babushka always writes the full debug log to `~/.babushka/logs/<dep name>` -- whether `--debug` was passed or not.

You can start viewing the debugging information for a run that's already in progress too, since babushka writes to the log in realtime. If you've started a babushka run, or would like to troubleshoot a long-running process or similar, just follow its debug log with `tail`:

    $ tail -f ~/.babushka/logs/<dep name>

You'll see the full debug log echoed to the terminal as babushka writes it -- just as if you'd originally run babushka with `--debug`.
