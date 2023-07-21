# Printf

This is a simplified printf subroutine that takes a variable amount of arguments. The first
argument for your subroutine is the format string. The rest of the arguments are printed instead
of the placeholders (also called format specifiers) in the format string. How those arguments are
printed depends on the corresponding format specifiers. The supported formats specifiers are:

  - %d Print a signed integer in decimal. The corresponding parameter is a 64 bit signed integer.
  - %u Print an unsigned integer in decimal. The corresponding parameter is a 64 bit unsigned
integer.
  - %s Print a null terminated string. No format specifiers should be parsed in this string. The
corresponding parameter is the address of first character of the string.
  - %% Print a percent sign. This format specifier takes no argument.

For example, suppose you have the following format string:
My name is %s. I think I’ll get a %u for my exam. I know what %r does, as well as %%.
Also suppose you have the additional arguments “Piet” and 10. Then your subroutine should
output:
My name is Piet. I think I’ll get a 10 for my exam. I know what %r does, as well as %%.

To run the code you need to execute:
```
./my_printf.s
```
