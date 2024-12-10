# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Output; paging and code parts

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) Output; paging and code parts [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Output; paging and code parts

[Output](#output)  
[Pages](#pages)  
[Code parts](#code-parts)  
[Overlapping code parts](#overlapping-code-parts)  
[File updating](#file-updating)  
[Dos .COM file example](#dos-com-file-example)  
[Basic .BIN file example](#basic-bin-file-example)  
[.ROM file example](#rom-file-example)

Sjasm can output multiple files from one source file. Every output has one or more pages, and every page has one or more code parts.

#### Output

With OUTPUT it is possible to create multiple files from one source. All following instructions will be assembled to this file.

The syntax is:
```
OUTPUT filename
```
If the filename contains spaces, you'd better use some quotes.

Example:
```
  output file1.dat
  byte "first file"

  output file2.dat
  byte "second file"
```
This will create two files: file1.dat and file2.dat.

#### Pages

To use a page, it has to be defined first with DEFPAGE:
```
DEFPAGE page [, origin [, size]]
```
The first argument specifies a page or a page range. There can be only 256 pages, numbered from 0 to 255. The second argument is optional and specifies the origin address of the page. You can use * as origin if you want the page to start where the previous one ended. The last argument is also optional and specifies the size. You can use \* as size to make the page just big enough to fit all code. When the optional arguments are omitted, the arguments from the previous page definition are used.
```
  defpage 0, 0, *        ; page 0, org 0, any size
  defpage 1, 4000h,4000h ; page 1, org 4000h, size: 16384 bytes
  defpage 2..7           ; page 2 until (including) 7, org 4000h, s: 16384
```
To select a page, use the PAGE command; all following code and data will be put into the selected page.
```
  page 1
  nop
  page 2
  nop
```
It is also possible to specify more pages, or page ranges. If you specify more than one page, Sjasm will try the specified pages until the part fits.
```
 page 1,3,4    ; put the following code in page 1,3 or 4
 page 4..6     ; put the following code in page 4,5 or 6
 page 1,3..5,7 ; put the following code in page 1,3,4,5 or 7
```
#### Code parts

You can define the parts to fill the pages with, with the CODE command:
```
CODE [?], [@ address], [# alignment], [PAGE page]
```
Just CODE without parameters will put the following code and data somewhere in the current page.

The ? indicates that the following part can be omitted when none of the labels in it are referenced. So, if in the following example HaveFun is never called, the part is not assembled:
```
  code ?
HaveFun
  xor a
  ret
```
Normally the code parts are sorted by size and then put into the page, the biggest part first. When you give an address, the part will be put at that address. When you give an address range, the first byte of the part will be put into that range.
```
  code               ; part sorted by size
  code @ 100h        ; part will be put at 100h
  code @ 100h..1000h ; part will be put in the given range
```
Because of the pre-processor it is a good idea to always keep a space between the @ and the following address.

With the #, the start address of the part can be aligned.
```
  code # 2           ; word align
```
When you specify ## as alignment, the part will not cross a 256 bytes border. You can use this to make sure you can use 8 bit address calculations because the high byte will not change.

The part will be put into the current page, as specified with the PAGE command. To override this default you can specify pages, or page ranges, to put the part in. If you specify more than one page, Sjasm will try the specified pages until the part fits.
```
  code                ; put into the last specified page
  code page 1         ; put part into page 1
  code page 1..2      ; put part into page 1 or page 2
  code page 4,6..8,2  ; put part into page 4, 6, 7, 8 or 2.
```
To find out in which page the code has been put, you can use the :<label> operator, which returns the page of the label:
```
  code page 1..3
hop
  dz "Hop!"

  code
printhop
  ld a,:hop
  call selectpage
  ld hl,hop
  jp print
```
Of course you can combine these parameters by separating them with commas:
```
  code @ 8000h, page 2
  code @ 100h..300h, # 64, page 0
```
When you want to know how much room the parts take in the page, you use the ::<page number> operator. The :: operator gives the highest address subtracted by the origin of the page.

#### Overlapping code parts

Normally, code parts cannot overlap. However, there are code parts that can overlap other parts, but not each other:
```
CODE ! address
```
So in the following example, the output will contain 'KIP':
```
  defpage 0
  page 0

  code @ 0
  byte "KOP"

  code ! 1
  byte "I"
```
#### File updating

Sjasm can also be used to update existing files. To do this, open the file with UPDATE instead of OUTPUT. After that you can use code parts to specify which parts of the file should be updated:
```
  defpage 0
  page 0

  update kip.txt

  code @ 1
  byte "O"
```
If the file kip.txt contained "KIP", it will contain "KOP" afterwards.

You can also include a file with INCBIN, and overwrite parts of it with CODE! parts:
```
  defpage 0
  page 0

  code @ 0
  incbin kip.txt

  code ! 1
  byte "O"
```
If the file kip.txt contained "KIP", the output will contain "KOP". This way the file kip.txt will stay intact.

#### Dos .COM file example

It is necessary to use 'code @ 100h' to make sure the entry code is assembled to the right place.
```
  output test.com

  defpage 0,100h

  page 0

  code @ 100h
entry
  ld de,txthelloworld
  ld c,9h
  call 5
  ret

  code
txthelloworld
  byte "Hello world!$"

  end
```
#### Basic .BIN file example

Here we put the header in a separate page. Since that page has only one code part, it is not necessary to specify where to put it. Note how we use the :: operator to calculate the end address.
```
  output test.bin

  defpage 0
  defpage 1,9000h

  page 0

  code
binheader
  byte 0feh
  word 9000h
  word 9000h+(::1)-1
  word entry

  page 1

  code
entry
  ld hl,txthelloworld
  call print
  ret

  code
print
  ld a,(hl)
  inc hl
  or a
  ret z
  out (152),a
  jr print

  code
txthelloworld
  dz "Hello world!"

  end
```
#### .ROM file example

Of course Sjasm does not generate any code by itself, so you still have to select the right slots and map the right pages and so on yourself. Which this example does not do :)
```
  output test.rom

  defpage 0,4000h,16384
  defpage 1,8000h

  page 0

  code @ 4000h
romheader
  byte "AB"
  word init
  word 0,0,0,0,0,0

  code
init
  ld hl,txthelloworld
  call print
  ret

  code
print
  ld a,(hl)
  inc hl
  or a
  ret z
  out (152),a
  jr print

  code
txthelloworld
  dz "Hello world!"

  end
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) Output; paging and code parts [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment