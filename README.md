<div align="center">
  <br/>
  <img src="https://raw.githubusercontent.com/ShinyTrinkets/overseer/master/logo.png" alt="Overseer logo">
  <br/>
</div>

# Overseer

[![Project name][project-img]][project-url]
[![Build status][build-img]][build-url]
[![Coverage report][cover-img]][cover-url]
[![Go Report Card][goreport-img]][goreport-url]

> Simple process manager library.

At the core of this library is the [os/exec.Cmd](https://golang.org/pkg/os/exec/#Cmd) from Go-lang and the first wrapper for that is the **Cmd struct**.<br/>
The **Overseer struct** can supervise one or more Cmds running at the same time.<br/>
You can safely run multiple Overseer instances at the same time.

It's recommended to use Overseer, instead of Cmd directly.<br/>
If you use Cmd directly, keep in mind that it is *one use only*. After starting a instance, it cannot be started again. However, you can Clone your instance and start the clone.<br/>
The Supervise method from the Overseer does all of that for you.

There are 3 states in the normal lifecycle of a proc: starting, running, finished.<br/>
If the process is killed prematurely, the states are: starting, running, interrupted.<br/>
If the process cannot start, the states are: starting, fatal.


The useful methods are:

* `NewOverseer()` - Returns a new instance of a process manager.
* `Add(id string, args ...string)` - Register a proc, without starting it. The `id` must be unique.
* `Remove(id string)` - Unregister a proc, only if it's not running. The `id` must be unique.
* `SuperviseAll()` - This is *the main function*. Supervise all processes and block until they finish. This includes killing all the processes when the main program exits. The status of the running processes can be watched live with the `Watch()` function.
* `Supervise(id string)` - Supervise one registered process and block until it finishes. This includes checking if the process was killed from the outside, delaying the start and restarting in case of failure (failure means the program has an exit code != 0 or it ran with errors).
* `Watch(outputChan chan *ProcessJSON)` - Subscribe to all state changes via the provided output channel. The channel will receive status changes for all the added procs, but you can easily identify the one your are interested in from the ID, Group, etc. Note that for each proc you will receive only 2 or 3 messages that represent all the possible states (eg: starting, running, finished).
* `Unwatch(outputChan chan *ProcessJSON)` - Un-subscribe from the state changes, by un-registering the channel.
* `Stop(id string)` - Stops the process by sending its process group a SIGTERM signal.
* `Signal(id string, sig syscall.Signal)` - Sends an OS signal to the process group.
* `StopAll()` - Cycles and stops all processes by sending SIGTERM.


Highlights:

* real-time status
* real-time stdout and stderr
* complete and consolidated return
* easy to track process state
* proper process termination on program exit
* portable command line binary for managing procs
* heavily tested, very good test coverage
* no race conditions


For examples of usage, please check the [Examples](examples/) folder, the [manager tests](manager_test.go), or the [command line app](cmd/cmd.go).


## Similar libraries

* https://github.com/go-cmd/cmd - os/exec.Cmd with concurrent-safe access, real-time streaming output and complete runtime/return status. Overseer is based off this one.
* https://github.com/immortal/immortal - A *nix cross-platform (OS agnostic) supervisor. The real deal.
* https://github.com/ochinchina/supervisord - A Golang supervisor implementation, inspired by Python supervisord.
* https://github.com/DarthSim/hivemind - Process manager for Procfile-based applications.


Icon is made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> and licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a>.

-----

## License

[MIT](LICENSE) © Cristi Constantin.

[project-img]: https://badgen.net/badge/%E2%AD%90/Trinkets/4B0082
[project-url]: https://github.com/ShinyTrinkets
[build-img]: https://badgen.net/travis/ShinyTrinkets/overseer
[build-url]: https://travis-ci.org/ShinyTrinkets/overseer
[cover-img]: https://codecov.io/gh/ShinyTrinkets/overseer/branch/master/graph/badge.svg
[cover-url]: https://codecov.io/gh/ShinyTrinkets/overseer
[goreport-img]: https://goreportcard.com/badge/github.com/ShinyTrinkets/overseer
[goreport-url]: https://goreportcard.com/report/github.com/ShinyTrinkets/overseer
