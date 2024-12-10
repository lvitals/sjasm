# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Conditional assembly

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) Conditional assembly [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Conditional assembly

With the conditional commands you can test a condition and assemble the following block of statements or skip it, based on the condition. The condition is only checked in the first pass.

All conditional commands follow the same syntax:
```
  IF <condition>
  <statements>
  ELSEIF <condition>
  <statements>
  ELSE
  <statements>
  ENDIF
```
The statements following the IF command are processed when the condition is true or non-zero. The ELSEIF block is optional, and is processed when the IF condition and the previous ELSEIF conditions were not met. You can use as much ELSEIF blocks as you like. The ELSE block is also optional and can be used only once. If none of the IF and ELSEIF conditions was met, the statements following the ELSE command are processed. An if block should end with ENDIF.

Sjasm recognises the following conditional commands:

The ELSEIF variants can be constructed by placing ELSE before the IF command, for example: ELSEIFNNUM, ELSEIF, ELSEIFIN, etc.

**IF** <expression>

The following statements are processed if the expression evaluates to a non-zero value.

**IFB** <argument>

The following statements are processed if the argument is empty.

**IFDEF** <identifier>

The following statements are processed if the identifier is a text macro.

**IFDIF** <argument1>,<argument2>

The following statements are processed if argument1 is different from

argument2.

**IFDIFI** <argument1>,<argument2>

The case-insensitive version of IFDIF.

**IFEXISTS** <filename>

The following statements are processed if the file exists.

**IFID** <argument>

The following statements are processed if the argument could be a label.

**IFIDN** <argument1>,<argument2>

The following statements are processed if argument1 is identical to argument2.

**IFIDNI** <argument1>,<argument2>

The case-insensitive version of IFIDN.

**IFIN** <argument>,<list>

The following statements are processed if the argument exists in the list.

**IFINI** <argument>,<list>

The case-insensitive version of IFIN.

**IFNUM** <argument>

The following statements are processed if the argument could be a number.

**IFSTR** <argument>

The following statements are processed if the argument could be a string.

**IFNB** <argument>

The following statements are processed if the argument is not empty.

**IFNDEF** <identifier>

The following statements are processed if the identifier is not a text macro.

**IFNEXISTS** <filename>

The following statements are processed if the file does not exist.

**IFNID** <argument>

The following statements are processed if the argument could not be a label.

**IFNNUM** <argument>

The following statements are processed if the argument could not be a number.

**IFNSTR** <argument>

The following statements are processed if the argument could not be a string.

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) Conditional assembly [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment