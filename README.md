# Installer
Installation wizard for the c4ev3 on Windows

## How to generate an Installer
[Download Innosetup](http://www.jrsoftware.org/isdl.php). Install it together with the bundled preprocessor. Double click the script and compile from the Menu _Build_. By default, the Installer fetches the files from `D:\ev3\` directory. Specifics are in the ini-category `[Files]`.

Depending on whether you want the toolchain included, comment or uncomment the
`#define TOOLCHAIN_INCLUDED`
line. Uncommenting is done, as usual for `.ini`s with the `;` character.

A fully Makefile would be neat though.. (The fork button is to the upper right!)
