# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Labels

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) Labels [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Labels

[Modules](#modules)  
[Local labels](#local-labels)  
[Reusable labels](#reusable-labels)  
[Value assignment](#value-assignment)  
[Storage maps](#storage-maps)  

Labels are case-sensitive and may be of any reasonable length. Label definitions should start on the beginning of a line, and do not have to be followed by a : (colon). Labels should start with a letter or an _ (underscore). The following characters may be chosen from letters, numbers and the _ (underscore) and . (dot). The '.' is also used to separate module names, labels and local labels, and will be inserted as needed.

#### Modules

Labels are local to the current module if there is a module defined. You can define a module with the MODULE command.
```
  module main
label         ; main.label
  module vdp
label         ; vdp.label
```
The ENDMODULE command without arguments ends the current module and restores the previous one:
```
  module main
label1         ; main.label1
  module vdp
label2         ; vdp.label2
  endmodule
label3         ; main.label3
```
ENDMODULE with an argument ends the named module and all nested ones:
```
  module main
label1         ; main.label1
  module vdp
label2         ; vdp.label2
  module sound
label3         ; sound.label3
  endmodule vdp
label4         ; main.label4
```
#### Local labels

When a label does not start with a . (dot), it is a non-local label. When a label does start with a . (dot), it is local to the previous non-local label. The following example defines two labels: label and label.local:
```
label
.local
```
All labels are local to the current module:
```
  module main
label
.local
```
Here the following labels are defined: main.label and main.label.local.

If you start the label with an ! (exclamation mark) the non-local label will not be used as such in the local label system:
```
label1
!label2
.local
```
This defines label1, label2 and label1.local as labels, and not label2.local. Use a @ to by-pass the label processor, and use the label as is:
```
  module main
label1
@label2
.local
```
This defines main.label1, label2 and main.label2.local. As you see, label2 will still be used as non-local label. To prevent this you could use !@label2:
```
  module main
label1       ; main.label1
!@label2     ; label2
.local       ; main.label1.local
```
When you use a label in an expression the . (dot) and @ operators work the same: . will use the label as local, and @ will use the label as-is:
```
chicken
  ld a,(.hop)        ; chicken.hop
.hop
  ld a,(@..go)       ; ..go
```
When used inside macros or loops, labels behave somewhat different. See the chapter about macros for more information.

#### Reusable labels

It is possible to use numbers as labels, which can be reused as many times as desired. They may only consist of decimal digits (0-9). These temporary labels can only be used as code locations, and can only be used as operands of jump or call instructions.

To jump to a numbered label, use the number followed by an F for forward branches or a B for backward branches:
```
1		; define label 1
	jp 1b	; jump to label 1, searching backward
1	jp 2f	; jump to label 2, searching forward
	jp 1b	; jump to the line with 'jp 2f'.
2		; define label 2
```
#### Value assignment

A defined label will get the value of the current code location, unless one of the following commands is used: =, EQU, := or #.

EQU gives the label a permanent value:
```
label equ 13
```
Instead of EQU = (equal) can be used:
```
label = 13
```
When you give the label a value with :=, this value can be overwritten later.
```
label := 13
label := label+1
```
This is useful when programming loops.

#### Storage maps

As said before, normally the code location counter is used to assign a value to a label. With the # command it is possible to assign the current map location to a label. Afterwards the map counter is incremented by the given amount.
```
  map 13
label3 # 10
label4 # 5
label5 # 10
```
label3 will get 13 as value, label4 23, label5 28, and the map location will be 38. You could also use the following to get the same result, but storage maps are easier to read and to update.
```
label3 = 13
label4 = label3+10
label5 = label4+5
```
The MAP command stores the current map location and puts a new value in the map location counter. The stored map location can be restored with ENDMAP.
```
  map 100h
label1 #|  map 200h
label2 #
  endmap
label3 #
```
Here, label1 and label3 will be 100h and label2 200h.

It is possible to align the map counter with the MAPALIGN command. When the alignment value is omitted, 4 is assumed. Instead of MAPALIGN ## can be used:
```
  map 100h
label1 # 3  ; 100h
      ## 2
label2 # 2  ; 104h
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) Labels [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment