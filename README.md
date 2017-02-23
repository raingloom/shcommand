# shcommand
A "pure" Lua module that lets call external executables and build process pipelines like you do in good old `/bin/sh`.

# System Requirements
Despite being "pure" Lua, it is not very portable.
It requires an `sh` compatible shell, some standard POSIX commands on `$PATH` and Unix-y files.
It is also not very well tested, but kept as simple as possible.
With that, it should work on any reasonable Linux system and probably on Windows with Cygwin/MSYS.
Compatibility with older Lua versions is not an explicit goal, see below.

# Goals
Help in making `initcpio` scripts for Arch Linux. That requires being small, so it's easy to embedd into `initramfs` without it blowing in size like it would with Python. Arch ships 5.3 by default, so that is what I'm targeting, so far it doesn't seem like it needs anything only available above 5.1, but that may change. Go upgrade your systems, guys, 5.1 is old, it's time to move on. Let it go. Shhhh. Let the silence _ENVelope you.
