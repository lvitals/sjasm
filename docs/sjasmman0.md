# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Introduction

Introduction [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Introduction

[New in Sjasm 0.42c](#new-in-sjasm-042c)  
[Differences with SjASM version 0.3](#differences-with-sjasm-version-03)  
[Known bugs](#known-bugs)  
[To do](#to-do)  
[The assembling process](#the-assembling-process)  

Sjasm 0.4 is still not quite finished yet, and neither is this manual. Although Sjasm can do more than described here, everything that is in here should work as advertised.

#### New in Sjasm 0.42c

*   Changed the format of the error messages to be compatible with Microsoft Visual Studio.
*   Changed some error messages.
*   Probably some small improvements here and there.

New in Sjasm 0.42b8

*   Nothing is new, just removed some comments ~8^)

New in Sjasm 0.4 BETA 7

*   Fixed XOR HL,HL. This should generate an error message.
*   Hacked EX AF,AF'.
*   Added DEFB, DEFW and friends.

New in Sjasm 0.4 BETA 6

*   Fixed 'unexpected' ascmap error.
*   Fixed error reports without list file.
*   Fixed more small bugs.
*   Added page range to PAGE command.
*   Added incbin.list, jr., djnz. and jp.

New in Sjasm 0.4 BETA 5

*   Fixed Sjasm endless loop.
*   Changed :: operator.
*   Added ## code part align option.
*   Added more text to this manual.

New in Sjasm 0.4 BETA 4

*   Fixed Sjasm crash while using structures.
*   Added more flexible code part page specification.

New in Sjasm 0.4 BETA 3

*   Fixed WHILE loops.
*   Improved code part sort.
*   Added check on negative page numbers.

New in Sjasm 0.4 BETA 2

*   Fixed UPDATE command.
*   Fixed jumps to numbered labels.
*   Fixed INCBIN file length check.
*   Added ERROR command.
*   Added CODE! overlay code parts.
*   Added more text to this manual.

New in Sjasm 0.4 BETA 1

*   Everything was new ~8^)

#### Differences with SjASM version 0.3

Sjasm version 0.4 is largely rewritten, and in some places the syntax and meaning of commands and operators has changed compared to previous versions of Sjasm. Some differences:

*   New name: Sjasm instead of SjASM.
*   DC, DZ, ABYTEC and so on only accept strings.
*   Character constants are 8 bit. No LD HL,'ab' anymore.
*   Structures cannot be nested.
*   The "16 bit fake instructions" like LD HL,DE or LDI A,(HL) have been replaced or removed.
*   PUSH and POP can have only one operand.
*   The way to update files has changed.
*   Commands cannot start with a dot.
*   Command line options have changed.

You can work your way around some of the differences by writing some macros.

#### Known bugs

Sjasm is still prototype-experimental-beta-like, so there may be some bugs - not that we know of any at this time.

If you encounter a bug, we would like to hear it. Please make sure it is a bug (in Sjasm or in this manual), and give a (small) source example if possible. Use info@xl2s.tk to contact us.

#### To do

In random order:

*   Make the error system look more intelligent
*   Make the code part placement more intelligent
*   Add command line options
*   Maybe add some predefined functions like random, sine and such

*   Improve this manual
*   Add timing information to the listing?

#### The assembling process

Sjasm will process your code a couple of times. Conceptually you could say Sjasm uses four passes:

*   Pass 1
*   Pass 2
*   Pass 3
*   Pass 4

The first pass is the pre-processor pass. The pre-processor does the following in this order:

*   Remove all comments
*   Concatenate lines you split up
*   Process define commands
*   Replace text macros and macro functions
*   Process the white space killer
*   Process other pre-processor commands like if, macro, while and struct
*   Cut multiple statement lines in pieces
*   Expand procedure macros

In the first pass you can only use (or reference) labels that are defined before you use them.

In the second pass Sjasm tries to figure out what values all labels should get, and in which order it should place all the code parts. It is not that difficult to make it impossible for Sjasm to do this, and make Sjasm take literally forever to complete this pass.

When all labels have the right values Sjasm generates the output in the third pass. After that, Sjasm goes over the whole code again to generate the listing file, and to see if it can generate some more error messages.

Introduction [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)


Copyright 2011 XL2S Entertainment