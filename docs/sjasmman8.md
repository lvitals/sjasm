# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > File handling

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) File handling [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### File handling

[Binary include](#binary-include)  
[Source include](#source-include)

Sjasm can include files as text or as binary. If you include the file as text it will be processed as if it was part of the source file. If you include the file as binary it will be put in to the output without any processing.

#### Binary include

With INCBIN you can include any file. The file is not processed in any way, and directly put into the output as-is. You can specify the offset and the length, if you don't the whole file will be included.
```
  incbin gfx.plet6    ; include the whole file
  incbin boe.bin,7    ; include boe.bin but skip the first 7 bytes
  incbin rantab,,1024 ; include the first 1024 bytes
  incbin a.bat,1,2    ; include the second and the third byte
```
You can use INCBIN.LIST instead of just INCBIN to list the included data in the list file.

#### Source include

You can use INCLUDE to include another source file into the current.
```
  include more.i
  include "more.i"
```
If the file cannot be found in the current directory (the current directory is the directory the current file comes from), the file will be searched for in the directories specified at the command line or specified with INCDIR. When angle brackets are used, the command line directories are searched before the current directory:
```
  include <vdp.i>
```
you can specify the directories to look in at the command line, or with the INCDIR command:
```
  incdir sourcedir
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) File handling [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment