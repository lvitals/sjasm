# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Expressions

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) Expressions [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Expressions

[Numeric constants](#numeric-constants)  
[Character constants](#character-constants)  
[String constants](#string-constants)  
[Operators](#operators)

Expressions consist of labels, constants and operators.

#### Numeric constants

Numeric constants should always start with a digit or $, # or %. The following formats are supported:
```
12     decimal
12d    decimal
0ch    hexadecimal
0xc    hexadecimal
$c     hexadecimal
#c     hexadecimal
1100b  binary
%1100  binary
14q    octal
14o    octal
```
All these constants can have underscores in them to group bits, nibbles, thousands or bytes and so on:
```
1100\_001\_1b  ; same as 11000011b
1\_200        ; same as 1200
```
#### Character constants

Character constants are single characters surrounded by single or double quotes. When double quotes are used, the following escape sequences are recognized:
```
\\ 92
\? 63
\' 39
\" 34
\A 7
\B 8
\D 127
\E 27
\F 12
\N 10
\R 13
\T 9
\V 11
```
Character constants can be used in expressions. Examples would be: 'p', "\\v" and '"'.

#### String constants

String constants are two or more characters surrounded by single or double quotes and cannot be used in expressions. When double quotes are used the same escape sequences are recognized as with character constants surrounded by double quotes. Some examples:
```
"it's fun to be here"
'how much "fun" do you want?'
"hoppa\n"
```
#### Operators

The following operators may be used in expressions:
```
()    (x)      change the operator precedence

$     $        current program location
#     #        current page
%     %        current repeat iteration
:     :label   page of label
::    ::page   highest address in page

!     !x       logical not
~     ~x       complement
+     +x       does nothing
-     -x       minus
low   low x    low 8 bits of 16 bit value
high  high x   high 8 bits of 16 bit value
not   not x    logical not

**    x**y     power

*     x*y      multiplication
/     x/y      division
%     x%y      modulo
mod   x mod y  modulo

+     x+y      addition
-     x-y      subtraction

<<    x<<y     shift left
>>    x>>y     shift right signed
>>>   x>>>y    shift right unsigned
shl   x shl y  shift left
shr   x shr y  shift right signed

<?    x<?y     minimum
>?    x>?y     maximum

<     x<y      less than
>     x>y      greater than
<=    x<=y     equal or less than
>=    x>=y     equal or greater than

=     x=y      equal
==    x==y     equal
!=    x!=y     not equal

&     x&y      bitwise and
and   x and y  bitwise and

^     x^y      bitwise xor
xor   x xor y  bitwise xor

|     x|y      bitwise or
or    x or y   bitwise or

:     x:y      x*256+y
```
Here are some examples of valid expressions:
```
  3<<2                 ; 12
  1+1                  ; 2
  high (8000h+(3&1))   ; 80h
  3>?5                 ; 5
```
Sjasm ignores overflow.

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) Expressions [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment