# Installer [![https://ci.appveyor.com/api/projects/status/github/c4ev3/Windows-Installer?svg=true](https://ci.appveyor.com/api/projects/status/github/c4ev3/Windows-Installer?svg=true)](https://ci.appveyor.com/project/c4ev3/Windows-Installer)

Installation wizard for c4ev3 on Windows

## How to generate an Installer
Checkout the repository including all submodules:
```
git checkout --recursive https://github.com/c4ev3/Windows-Installer.git
```

[Download Innosetup](http://www.jrsoftware.org/isdl.php) and Install it together with the bundled preprocessor.

Build the installer using the `Makefile`:

```
make c4ev3-setup.exe
make c4ev3-withGCC-setup.exe # for building with toolchain
```
