# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Loops

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) Loops [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Loops

[Repeat](#repeat)  
[While](#while)  
[Nested loops](#nested-loops)  
[Exit and continue](#exit-and-continue)

Sjasm supports two loop statements: REPEAT and WHILE. You can use the REPEAT and WHILE statements to repeat a block of statements a number of times.

#### Repeat

REPEAT repeats the block of statements between REPEAT and ENDREPEAT the given number of times. @# Will contain the number of iterations, starting with 0.
```
  repeat 3
  byte @#
  endrepeat
```
expands to:
```
  byte 0
  byte 1
  byte 2
```
#### While

WHILE repeats the block as long as its argument is not zero. Again, @# contains the number of iterations and the block should end with ENDWHILE.
```
counter:=3
  while counter
  byte counter,@#
counter:=counter-1
  endwhile
```
expands to:
```
  byte 3,0
  byte 2,1
  byte 1,2
```
#### Nested loops

Loops can be nested and you can use @@#, @@@# and so on the access the number of iterations of the outer loops:
```
  repeat 2
  repeat 3
  byte @#,@@#
  endrepeat
  endrepeat
```
expands to:
```
  byte 0,0
  byte 1,0
  byte 2,0
  byte 0,1
  byte 1,1
  byte 2,1
```
#### Exit and continue

To exit a loop, use BREAK. You could use this to exit an endless loop:
```
  while 1
l:=l+1
  if l=3
    break
  endif
  endwhile
```
To continue with the next iteration, use CONTINUE:
```
  repeat 5
  if @#<3
    continue
  endif
  byte @#
  endrepeat
```
this outputs:
```
  byte 3
  byte 4
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) Loops [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment