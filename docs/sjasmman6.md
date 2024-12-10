# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Data definition

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) Data definition [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Data definition

[Define space](#define-space)  
[Definition with offset](#definition-with-offset)  
[Character mapping](#character-mapping)  
[Structures](#structures) 

These commands define initialized data:
```
DB    8-bit constants and strings
DC    strings; every last character of a string will have bit 7 set
DD    32-bit constants
DT    24-bit constants
DW    16-bit constants
DZ    strings; each string will be zero terminated
BYTE  8-bit constants and strings
WORD  16-bit constants
DWORD 32-bit constants
DEFB  8-bit constants and strings
DEFM  8-bit constants and strings
DEFW  16-bit constants
DEFD  32-bit constants
```
The syntax is:
```
[label] [[repeatcount]] COMMAND [expr][,expr]... [comment]
```
where expr is an expression, constant or label where constants are allowed, or a string where strings are allowed.

Examples:
```
  db 0x55
  db 'a'-2, "hoppa!"
  db 2*7
  dc "kip","abc"
  dw "a"
  dz "kip","abc"
```
#### Define space

To define a space you can use DS (or BLOCK or |DEFS, there is no difference). The first argument specifies the number of bytes to fill with the second argument. When the second argument is omitted, zero is used:
```
  ds 10     ; byte 0,0,0,0,0,0,0,0,0,0
  ds 5,3    ; byte 3,3,3,3,3
  block 2   ; byte 0,0
```
#### Definition with offset

The following commands add an offset to the specified bytes or string: ABYTE, ABYTEC and ABYTEZ. ABYTEC and ABYTEZ work similar to DC and DZ, and allow only strings. The syntax is:
```
[label] [repeatcount] ABYTE [offset] [expr][,expr]... [comment]
```
Examples:
```
  abyte 1 0,1,2,3  ; byte 1,2,3,4
  abytez 3 "abc"   ; byte "def",0
```
#### Character mapping

It is also possible to define a mapping table with ASCMAP and use that to translate the strings using the ASC command. This way it is possible to map any character to any other. The first argument to ASCMAP defines a character or a character range; the second argument defines an expression telling how to translate the characters. In this expression $ specifies the character currently being translated.
```
  ascmap 'a'..'z', $+1         ; a=>b, b=>c, c=>d, ...
  ascmap 'a'..'z', $+'A'-'a'   ; make uppercase
  ascmap '*', 'a'              ; translate * to a
```
Another, less flexible, way is to specify the range of characters to translate, the first character to translate to and optionally a step increment. The increment is one if the step increment is omitted.
```
  ascmap '0'..'9', => 0        ; 48 ('0') =>0, 49=>1, ...
  ascmap 'a'..'z', => 'A'      ; make uppercase
  ascmap 'a'..'z', => 65,2     ; a=>A, b=>C, c=>E, ...
  ascmap 'a'..'z', => 'z',-1   ; a=>z, b=>y, c=>x, d=>w, ...
```
Instead of ascmap 0..255, $ you can use ASCMAP.RESET to get the default 1:1 mapping back. You can use ASCMAP.CLEAR to get all characters translate to 0.

To use the defined mapping table, use the ASC command instead of DB:
```
  asc "de kip",13,"a"+12
```
Likewise ASCC and ASCZ work like DC and DZ:
```
  ascz "de kip"       ; only strings allowed
```
#### Structures

Structures can be used to define data structures in memory more easily. A structure is a group of fields that can have different sizes. When you declare a structure, Sjasm will create labels with the offsets of the fields, so you could use a structure instead of a storage map. The name of the structure will be used to create a label with the total size of the structure.

You declare a structure with the STRUCT and the ENDSTRUCT commands:
```
  STRUCT name [, initial offset, alignment]
  <fields>
  ENDSTRUCT
```
You could use ENDS instead of ENDSTRUCT.

When you declare the structure in a module, the module name will be part of the name, just like labels. If you do not want this, put an @ before the name.

The initial offset and the alignment are both optional. Normally this offset is 0, but it can be set to any value. You can specify a default alignment that is used for all the fields.

The syntax for defining the structure fields is as follows:
```
label type operands
```
All fields are optional, and not all types have operands. Sjasm recognises the following types:
```
DB [<defaultvalue>]           ; define a 1 byte field
DW [<defaultvalue>]           ; define a 2 byte field
DT [<defaultvalue>]           ; define a 3 byte field
DD [<defaultvalue>]           ; define a 4 byte field
DS length [,<defaultvalue>]   ; define a field of the given length
## alignment value            ; align the following field
#  length                     ; define a field of the given length
```
BYTE can be used instead of DB, WORD instead of DW, DWORD instead of DD and ALIGN instead of ##.

The default value is used when no initialisation value is given when the structure is defined. The default of a DS field can contain more than one expression or string, as long the length of the field is not exceeded.

The default alignment and the alignment field only align the structure offsets, and not the actual addresses where the structure is used.

Some examples of structure declarations:
```
  struct scolor
red   db 4
green db 5
blue  db 6
  endstruct
```
This will create the following labels:
```
scolor.red   ; 0   offsets
scolor.green ; 1
scolor.blue  ; 2
scolor       ; 3   length of the structure
```
In the following example we will use a default alignment:
```
  struct spul,,2
x    db 0
y    db 0
name ds 8, "noname",1
  endstruct
```
This will create the following labels:
```
spul.x     ; 0   offsets
spul.y     ; 2
spul.name  ; 4
spul       ; 12   length
```
When a structure is declared, you can define labels with it:
```
color1  scolor
color2  scolor 12,,14
```
This is identical to:
```
color1
.red   db 4
.green db 5
.blue  db 6
color2
.red   db 12
.green db 5
.blue  db 14
```
As you see, the default values are overwritten when you specify new values. Fields declared as # will always be initialized with zero and cannot be overwritten.

When you use a structure without a preceding label, no labels are generated, but of course, the data will be defined as expected:
```
  spul
```
wil generate the following data:
```
  db 0            ; x
  ds 1            ; align
  db 0            ; y
  ds 1            ; align
  db "noname",1   ; name
  ds 1            ; padding
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) Data definition [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment