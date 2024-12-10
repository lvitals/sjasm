# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Z80 Assembly syntax

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) Z80 Assembly syntax [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Z80 Assembly syntax

[Undocumented instructions](#undocumented-instructions)  
[R800 CPU](#r800-cpu)  
[Extended instructions](#extended-instructions)  
[Z80 instruction set](#z80-instruction-set)

In general, Sjasm follows the original Zilog notation for the instructions.

Differences with Z80 mnemonics:

*   You can use S and NS (sign/no sign) instead of the M and P conditions.
*   You can use JP HL, JP IX and JP IY instead of JP (HL) and so on.
*   You can use square brackets instead of parentheses for indirection. So LD A,[HL] is the same as LD A,(HL). You can enforce the use of brackets with a command line option.
*   The A register is optional as operand with some instructions. ADD 3 and ADD A,3 are the same.

#### Undocumented instructions

As you probably know the Z80 recognizes more instructions than just the official ones. Sjasm recognizes all undocumented instructions, so you can use:

*   ixl, ixh, iyl and iyh registers
*   sll or sli
*   out (c),0
*   in (c) or in f,(c)
*   rlc (ix+0),b and friends

#### R800 CPU

For some reason the designers of the R800 did not implement all of the Z80 instructions. Because of this none of the undocumented instructions of the Z80 work on the R800, except the use of the ixl, ixh, iyl and iyh registers.

Sjasm does not understand the official R800 mnemonics, so you should use the corresponding Z80 ones. MULUB and MULUW are of course recognized.

#### Extended instructions

In the best Sjasm tradition, in addition to the real undocumented instructions some fake extended instructions have been added.

In all places where a 16 bit register pair is used as an indirection, you can add a ++ increment or a -- decrement operator. There should be no space between the register and the operator. Both pre and post increment and decrement are supported.

Examples:
```
  ld a,(hl++)     ; ld a,(hl)\ inc hl
  ld a,(++bc)     ; inc bc\ ld a,(bc)
  ld (iy++ +5),b  ; ld (iy+5),b\ inc iy
  add a,(--ix)    ; dec ix\ add a,(ix+0)
  bit 1,(hl--)    ; bit 1,(hl)\ dec hl
```
This does not work with the stack pointer, so EX (SP++),HL does not work.

The jump instructions have also been 'improved'. If you use DJNZ. (with dot) instead of DJNZ, Sjasm will use DEC B\ JP NZ,x if the jump target is out of range. Similarly, JP. and JR. use JR where possible, and JP if not.

You can inverse the condition used by conditional jumps and calls with the exclamation mark (!):
```
  call !c, DoTheWork   ; call nc, DoTheWork
  jp !pe, Oops         ; jp po, Oops
  jr !nc, .loop        ; jr c, .loop
```
This makes it easier to create conditional macros:
```
  macro addc cond, reg, this
  jr !cond,.skip
  add reg, this
.skip
  endmacro
```
with this macro
```
  addc nc, hl, de
```
expands to:
```
  jr c,.skip
  add hl,de
.skip
```
#### Z80 instruction set

Add more information - like all recognized instructions - here :)

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) Z80 Assembly syntax [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment