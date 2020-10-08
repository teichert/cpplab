# C++ Makefile Project

The [Makefile](Makefile) in this directory can be used to build and
run C++ projects that include a main-driver program as well as
doctests that should be run.  It also defines recipes for running,
testing, and debugging. This document describes how to use the
makefile as well as pointers to other relevant development tools.
(Feel free to report any issues you find with the instructions in this
file.)

## Project Structure

The Makefile will expect your `.cpp` and `.h` files to be in certain
places so that it can figure out file dependencies, and compile and
link files as efficiently as possible.  Source `.cpp` files will be
compiled into `.o` files and then linked together as appropriate.
Including `.h` files introduces dependencies which will be automatically
detected. The subdirectories of the project are explained below:

- `bin/`: generated executables will be put here (i.e. the executable
  main program and the test runner)
- `build/`: intermediate compiled object files will go here (one for each
  `.cpp` file)
- `drivers/`: source code for the test driver, `test-driver.cpp` (which
  doesn't change from project to project), and your main program,
  `main-driver.cpp`, should go here.
- `include/`: any non-standard header files, including your own `.h`
  files should go here
- `src/`: all of your `.cpp` files (other than your test case files and
  your two driver files) should go here
- `test/`: all of your test case `.cpp` files should go here

## Coding Environment

### Windows Subsystem for Linux (WSL)

If you are using Windows 10, you can easily get an linux environment called the [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

### CS50 IDE

An alternative linux environment is freely available [online](https://ide.cs50.io).  In order to login, you need to first get a (free) [GitHub](https://github.com) account (you don't actually need to create any repositories yet, however).

### Required Commandline Tools

From the linux terminal, make sure you have `make`, `g++`, and `gdb` by installing the `build-essential` package from the commandline as follows:

```{bash}
sudo apt update
sudo apt install build-essential
```

### Visual Studio Code

If you want to develop locally, [VS
Code](https://code.visualstudio.com/download) is a nice, lightweight,
open-source, programming environment that is available on Windows,
Linux, and Mac.  Once you have installed it, open a linux commandline
and run the program by typing `code`. From the `File` menu, select
"Open Folder" and navigate to the folder containing this `README.md`
file.  This folder also has a hidden folder called `.vscode` which
tells VSCode what to do when you hit the green play button to run
project.  In particular, it defines that if you want to run the main
driver, it should first run `make` to build the executable, and then
run it with the debugger.  It also tells VSCode to run `make` before
debugging the test driver.

## Using the Makefile

As mentioned above, if you use VSCode, then using the built-in run
mechanism will make use of the makefile indirectly.  In addition, the
makefile defines several targets that you can run.

Run `make` from the linux commandline while in the same directory as
this `README.md` file (which is also where the `Makefile` is).  For
example, to run the recipe for `test` you would enter `make test` from
the commandline.  **Note:** the online `ide.cs50.io` shell by default
recompiles from scratch, so to make compilation faster, use **`command make`** in place of `make` when using the CS50 IDE. The `Makefile` defines recipes
for the following targets:

- `all` (this is the default is you just type `make`): build the main
  driver and test driver
- `test`: build and run tests
- `run`: build and run main driver program
- `clean`: remove all generated files
- `zip`: remove generated files and add everything else to a .zip file
- `run-debug50`: prepare and run the debugger on the main driver for the cs50 ide
- `test-debug50`: prepare and run the debugger on the test driver for the cs50 ide
- `run-debug`: run the main driver in a command-line debugger called `gdb`
- `run-debug`: run the test driver in `gdb`

