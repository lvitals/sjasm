# Sjasm 0.42 manual

[Sjasm manual](sjasmmanual.md) > Listing format

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) Listing format

### Listing format

[Assembly listing](#assembly-listing)  
[Label listing](#label-listing)  
[Output listing](#output-listing)

The assembly listing shows both the source and the generated code. This can help you debugging the source (or the generated code :). The file also contains a list of symbols and an overview of outputs, pages and code parts, so you can see where Sjasm puts your code.

#### Assembly listing

The listing follows the source code, and not the order in which the code parts may be placed in the output.

#### Label listing

The label listing lists all labels preceded by the page and the value. If the label is not used, this is marked with an X. Similarly a - (minus) indicates that the code part containing this label was not referenced and not assembled. An S indicates that the label may have had other values during the assembly, because it had its value set with the := command.

The labels are listed in order of appearance. Temporary labels and labels local to macros or loops are not listed.
```
    LABELS
---------------------------------------
00:00000080 X emU1
00:000000C0 X emUb
00:000000E6 S FT
00:0000010A   ppInit
00:0000011B - ppExit
```
#### Output listing

Add more information here :)

[Introduction](sjasmman0.md) [Command line options](sjasmman1.md) [Source Format](sjasmman2.md) [Labels](sjasmman3.md) [Expressions](sjasmman4.md) [Z80 Assembly syntax](sjasmman5.md) [Data definition](sjasmman6.md) [Output; paging and code parts](sjasmman7.md) [File handling](sjasmman8.md) [Conditional assembly](sjasmman9.md) [Loops](sjasmman10.md) [Macros](sjasmman11.md) Listing format

Copyright 2011 XL2S Entertainment