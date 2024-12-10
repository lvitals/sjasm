# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Macros

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) Macros [Listing format](sjasmman12.md)

### Macros

[Text macros without arguments](#text-macros-without-arguments)  
[Text macros with arguments](#text-macros-with-arguments)  
[Procedure macros](#procedure-macros)  
[Named parameters](#named-parameters)  
[Numbered parameters](#numbered-parameters)  
[Variable amount of parameters](#variable-amount-of-parameters)  
[Macro functions](#macro-functions)  
[Recursive macros](#recursive-macros)  
[Labels in macros and loops](#labels-in-macros-and-loops)

Macros are a kind of a search and replace mechanism, so you can avoid writing the same code over and over again. The assembler supports text macros as well as procedure macros and macro functions. Macros are only expanded in the first pass.

#### Text macros without arguments

Text macros are defined with the assembler command DEFINE. The syntax for DEFINE without arguments is:
```
  DEFINE name replacement
```
Text macros simply replace some text with another. The text to replace can be anywhere on a source line, except in strings. So the following code:
```
  define kip "hoppa!"
  byte kip,0,0,kip
  byte "kip"
```
will expand to:
```
  byte "hoppa!",0,0,"hoppa!"
  byte "kip"
```
When the text in a string should also be replaced, you should precede the string with a @:
```
  define defbyte byte
  defbyte "defbyte"
  defbyte @"defbyte"
```
expands to:
```
  byte "defbyte"
  byte "byte"
```
When the replacement is omitted, the name is replaced with itself. It is possible to re-define a text macro:
```
  define one

  byte one
  define one 1
  byte one
  define one 2
  byte one
```
expands to:
```
  byte one
  byte 1
  byte 2
```
Macro expansions can be nested and are expanded when they are used, so:
```
  define two one+one
  define one 1
  byte two
```
expands to:
```
  byte 1+1
```
even though one was not defined at the definition of two. A text macro will not be expanded within itself, so circular references do not result in infinite loops:
```
  define one two
  define two one
  byte one
```
expands to:
```
  byte one
```
because one will expand to two, which will expand to one, which will not expand again.

When the expansion should occur at the definition, use XDEFINE:
```
  define one 1
  xdefine two one+one
  define one 3
  byte two
```
expands to:
```
  byte 1+1
```
because two has been expanded to 1+1 at the definition.

The ASSIGN command evaluates an expression at the time the command is processed:
```
  ASSIGN name expression
```
Like the other text macros without arguments, macros defined with ASSIGN can be redefined later:
```
  assign c 1
  assign c c+1
```
Here is an example to show the differences between DEFINE, XDEFINE and ASSIGN:
```
  define c 1
  define c c+1   ; c expands to c+1

  define c 1
  xdefine c c+1  ; c expands to 1+1

  define c 1
  assign c c+1   ; c expands to 2
```
Text macros can be undefined with the UNDEF command:
```
  define kip hop
  undef kip
  byte kip
```
will expand to:
```
  byte kip
```
since the macro kip is not defined anymore.

DEFINE and XDEFINE are case-sensitive, so after DEFINE KIP only KIP will be expanded, kip, Kip, kIP and so on will not. By using IDEFINE or XIDEFINE instead of DEFINE or XDEFINE you define a case-insensitive macro. So:
```
  idefine kip 1
  byte kip,KIP,kiP,Kip
```
expands to:
```
  byte 1,1,1,1
```
#### Text macros with arguments

The syntax for DEFINE with arguments is:
```
  DEFINE name(arguments) replacement
```
There should be no space between the macro name and the opening parenthesis ( and when there are more then one arguments, they should be separated by commas. Instead of DEFINE, you can also use IDEFINE, XDEFINE or XIDEFINE, which mean the same as with macros without arguments. For example:
```
  idefine hop(param) byte param*param\ word 0
  Hop(1)
  Hop(2)
```
will expand to:
```
  byte 1*1
  word 0
  byte 2*2
  word 0
```
You cannot use UNDEF on text macros with arguments, and you cannot re-define them. However, it is possible to overload them, meaning defining a new macro with the same name, but with a different number of arguments:
```
  define hop(param) byte param*param
  define hop(param1, param2) byte param1*param1, param2+param2
  hop(3)
  hop(4,5)
```
expands to:
```
  byte 3*3
  byte 4*4, 5+5
```
When there are multiple parameters, they should be separated by commas. When you need to pass a comma as part of a parameter, the parameter (or just the comma) should be surrounded by { and } (braces). Braces are filtered out.

To expand to multiple lines, the \ (backslash) operator can be used:
```
  define bywo(p1,p2) byte p1\ word p2
  bywo(40h,8000h)
```
will eventually result in:
```
  byte 40h
  word 8000h
```
#### Procedure macros

Procedure macros can be used like assembler commands or assembler mnemonics and can expand to multiple lines. The syntax is:
```
  MACRO name parameters
  statements
  ENDMACRO
```
Macros are case-sensitive, unless you use IMACRO instead of MACRO.

An example without parameters:
```
  macro BDOS
  call 5
  endmacro

  ld c,5
  BDOS
```
results in:
```
  ld c,5
  call 5
```
If you define a macro with the same name as an assembler command or a Z80 mnemonic, you can use @ (at) to not invoke the macro:
```
  macro ccf
  byte 0
  endmacro

  ccf   ; macro
  @ccf  ; the Z80 instruction
```
#### Named parameters

Macro parameters exist in two kinds: named parameters and numbered parameters. The named parameters will be explained first.

An example with one named parameter:
```
  macro BDOS fun       ; macro definition
  ld c,fun
  call 5
  endmacro
  BDOS 5               ; macro call
```
expands to:
```
  ld c,5
  call 5
```
With : (colon) you can specify defaults for omitted parameters.
```
  macro BDOS fun:5
  ld c,fun
  call 5
  endmacro
  BDOS
```
expands to:
```
  ld c,5
  call 5
```
When there are multiple parameters, they should be separated by commas. When you need to pass a comma as part of a parameter, the parameter (or just the comma) should be surrounded by { and } (braces). This way you can also include commas in the default:
```
  macro string param: { "default",0 }
  byte param
  endmacro
  string { "mooi weer",0,0 }
  string
```
expands to:
```
  byte "mooi weer",0,0
  byte "default",0
```
When you define the last parameter to be 'greedy' with + (plus), all following parameters will be put into the last one, including the commas:
```
  macro string param+
  byte param
  endmacro
  string "kip",0,34
```
expands to:
```
  byte "kip",0,34
```
Of course it is also possible to give the greedy parameter a default:
```
  macro string num:32, str+:"default",0
  byte num, str
  endmacro
```
#### Numbered parameters

Instead of naming the parameters it is also possible to define the number of parameters:
```
  macro dbyte 2
  byte @1, @2
  endmacro
```
defines a macro dbyte which expects two parameters. Use @1 to refer to the first parameter, @2 to the second and so on. It is also possible to define a range:
```
  macro dbyte 2..3
  byte @1, @2
  ifnb @3
  byte @3
  endif
  endmacro
```
This defines a macro that needs two parameters and takes at most three. The IFNB statement is used to check if the third parameter is used. It is possible to define defaults for omitted parameters:
```
  macro string 0..1 "Hoppa!"
  byte @1
  endmacro
```
And the last numbered parameter can be made greedy:
```
  macro string 0..1+ "Hoppa!",0
  byte @1
  endmacro
```
It is also possible to combine named and numbered parameters, by putting a comma between them:
```
  macro onzin name:"Kees", 3
  byte name,0
  byte @1, @2, @3
  endmacro
```
Just like text macros, procedure macros can be overloaded:
```
  macro out9
  xor a
  endmacro

  macro out9 reg
  ld a,reg
  endmacro

  macro out9 reg1,reg2
  out9 reg1
  out9 reg2
  endmacro
```
#### Variable amount of parameters

You can use * (asterisk) to define macros with many parameters, or when the number of parameters is not known at the time of definition.
```
  macro atleastone 1..*
  byte @0
  endmacro
  macro anynumber *
  byte @0
  endmacro
```
@0 Contains the number of numbered arguments passed to the macro. You can use the REPEAT statement together with ROTATE to iterate through the arguments:
```
  macro cbyte 1..*
  byte @0
  repeat @0
  byte @1
  rotate 1
  endrepeat
  endmacro
```
ROTATE rotates the arguments to the left by the given number of places. So rotate 1 will rotate the value of @2 to @1, @3 to @2 and so on. The last value will get the value of @1. If the argument to ROTATE is negative, the arguments are rotated to the right.

#### Macro functions

Macro functions are a bit like defined text macros. The call is replaced with the returned text. Use the EXITMACRO command to return text:
```
  macro defined name
  ifdef name
  exitmacro -1
  else
  exitmacro 0
  endif
  endmacro
```
You could also use EXITMACRO in a macro procedure; it just stops the macro expansion and does not return a value.

When invoking or calling a macro function you must enclose the argument list in parentheses, even when there are no arguments. There are no spaces allowed between the name and the opening parentheses:
```
  if defined(DEBUG) or not defined(HOPPA)
  byte 0
  endif
```
If you want to return the result of an expression and not the expression itself as text, use XEXITMACRO:
```
  macro twotimes 1
  xexitmacro @1+@1
  endmacro

lab=2
  byte twotimes(lab)
```
this expands to: byte 4

and not to: byte lab+lab

It is not possible to generate code from macro functions; all assembler instructions and data definitions are ignored.

#### Recursive macros

Normally Sjasm will not expand a macro within itself. If you want to expand a macro recursively, use macro.recursive:
```
  macro.recursive HOP count
  if count
    byte count
    HOP count-1
  endif
  endmacro

  HOP 3
```
this expands to:
```
   byte 3
   byte 2
   byte 1
```
Most of the time it is easier to just use a loop.

#### Labels in macros and loops

When you define a local label inside a macro, the label will be local to the macro, each time it is expanded. You must use @ to escape from this behavior, if desirable:
```
  macro test
kip0
.kip1
@.kip2
  endmacro

  module main
hoi
  test
```
This defines the following labels: main.hoi, main.kip0, 0>kip1, main.kip0.kip2. As you can see labels local to macros get the form number>labelname. After the first @ the system behaves the same as labels outside macros.

To access a label that has the same name that is defined in an outside macro or loop, use .@ in front of a label instead of . (dot). The number of @s denotes the number of nesting levels:
```
  macro test
.hop              ; hop 1
  repeat 2
  call .hop       ; hop 2
  jp .@hop        ; hop 1
  call .@@hop     ; hop 0
.hop              ; hop 2
  endrepeat
  endmacro

  macro test2
.hop              ; hop 0
  test
  endmacro

  test2
```
To set a new value to a label defined outside a loop (or macro), you should also use .@:
```
  macro test 1
.teller:=0
  repeat $1
.@teller:=.teller+1
  byte .teller
  endrepeat
  endmacro
```
If you would use just .teller, you would define a new label, local to the repeat loop.

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) Macros [Listing format](sjasmman12.md)

Copyright 2011 XL2S Entertainment