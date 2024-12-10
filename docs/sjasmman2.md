# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Source Format

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) Source Format [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)

### Source Format

[Comments](#comments)  
[Multi statement lines](#multi-statement-lines)  
[White space killer](#white-space-killer)  
[Repeat count](#repeat-count)  

In general, the format of a source line is as follows:
```
[label[:]] [repeat] [operation [operands]] [comment]
```
The fields should be separated by spaces or tabs.

Labels should start in the first column and are case-sensitive: 'Start' is different from 'start'. The : (colon) is ignored.

In general, labels must not be used with assembler commands. Putting a label before IF, IFDEF, DEFINE, MACRO, WHILE, REPEAT, ENDMACRO, ENDWHILE, INCLUDE and so on will make Sjasm not recognize the command.

The repeat field is used to specify how many times the operation should be executed and should be specified within square brackets ('[' and ']'). The default is one time. Most assembler commands do not allow a repeat count.

The operation is an instruction mnemonic or an assembler command and must not start in the first column. The operation should be in the same case: 'add' and 'ADD' are recognized, but 'Add' is not.

Most instructions and commands operate on one or more operands, which should be separated by commas most of the times.

The following example uses all fields:
```
MulBy8:	[3]	add	a, a	; a=a\*8
```
#### Comments

The assembler ignores comments. Sjasm supports two kinds of comments: line based and block based. A line based comment starts with a ; (semicolon) or a C++-like // (double slash) and ends at the end of the line. A comment may start anywhere on the source line, also on column one:
```
; comment
  ld a,7   // comment
```
The C-like block comment uses /\* to indicate the start and \*/ to indicate the end of a comment. These block comments may be nested and expanded over more lines. Block comments are replaced with a space character. Some examples:
```
ld /* comment */ a,80

/*
/* nested comment */
*/

 ld/*
 this will be ld a,3
 */a,3
```
#### Multi statement lines

The \\ (backslash) is used as line operator. If it is placed at the end of a line (but before the comment field), the next line extends the current line:
```
MulBy8: 
[3] 
add 	; backslash at the end of a line, as comments are ignored
a, a	; a=a*8
```

When the \ is used in the middle of a line, it indicates the start of a new line:
```
Maal8: add a,a\ add a,a\ add a,a ; a=a*8
```
Note the space after the backslash; it is needed here because the operation field must not start in column one.

#### White space killer

The >< (angle brackets) operator removes any spaces or tabs:
```
  l >< d a,3
```
becomes:
```
  ld a,3
```
To use this operator inside strings, precede the string with a @ (at):
```
  byte @'hi >< mom!'
```
becomes:
```
  byte 'himom!'
```
This is useful for use in macros, to generate label names.

#### Repeat count

When you want to repeat an instruction a couple of times, you can specify how many times the instruction should be executed within square brackets ('\[' and '\]').

So instead of this:
```
  inc hl
  inc hl
  add a,a
  add a,a
  add a,a
  add a,a
```
you could program this:
```
[2] inc hl
[4] add a,a
```
You can use % (percent sign) to get the current iteration, starting with 0.

So
```
[4] add a,%
```
is the same as:
```
  add a,0
  add a,1
  add a,2
  add a,3
```
% Might be more useful when you use it to define data.

You can repeat the repeat field, and use %%, %%% and so on the get the repeat count of the outer loops:
```
[2][3]byte %,%%
```
is the same as:
```
 byte 0,0
 byte 1,0
 byte 2,0
 byte 0,1
 byte 1,1
 byte 2,1
```
[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) Source Format [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) [Listing format](sjasmman12.md)


Copyright 2011 XL2S Entertainment